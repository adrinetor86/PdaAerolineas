
(function () {
    'use strict';

    const cfg = window.RADAR_CONFIG;
    if (!cfg) return;

    let map;
    let markers        = {};   // vueloId -> { marker, data, prevLat, prevLng, heading, routeInfo }
    let selectedVueloId = null;
    let routeLayer      = null;

    /* ═══════════════ CESIUM RADAR ═══════════════ */
    let cesiumViewer  = null;
    let cesiumEntities = {};   // vueloId -> Entity
    let vista3DActiva  = false;

    /* ── Heading (bearing) 0-360, 0=Norte, 90=Este ── */
    function calcularHeading(lat1, lng1, lat2, lng2) {
        const toRad = d => d * Math.PI / 180;
        const toDeg = r => r * 180 / Math.PI;
        const dLng = toRad(lng2 - lng1);
        const y = Math.sin(dLng) * Math.cos(toRad(lat2));
        const x = Math.cos(toRad(lat1)) * Math.sin(toRad(lat2)) -
            Math.sin(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.cos(dLng);
        return (toDeg(Math.atan2(y, x)) + 360) % 360;
    }

    /* ── Icono avión rotado ── */
    function crearIconoAvion(heading, seleccionado) {
        const color  = seleccionado ? '#ef4444' : '#3b82f6';
        const size   = seleccionado ? 36 : 28;
        const shadow = seleccionado
            ? 'filter:drop-shadow(0 0 8px rgba(239,68,68,0.7));'
            : 'filter:drop-shadow(0 2px 4px rgba(0,0,0,.4));';
        const h = Math.round(heading || 0);
        return L.divIcon({
            html: `<div style="width:${size}px;height:${size}px;transform:rotate(${h}deg);${shadow}transition:transform 0.8s ease;">
                       <svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="${color}">
                           <path d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5l8 2.5z"/>
                       </svg>
                   </div>`,
            className: 'bg-transparent',
            iconSize:   [size, size],
            iconAnchor: [size / 2, size / 2]
        });
    }

    /* ── Icono aeropuerto ── */
    function crearIconoAeropuerto(codigo, tipo) {
        const bg      = tipo === 'origen'
            ? 'background:linear-gradient(135deg,#15803d,#22c55e);'
            : 'background:linear-gradient(135deg,#b91c1c,#ef4444);';
        const labelBg = tipo === 'origen' ? '#16a34a' : '#dc2626';
        return L.divIcon({
            className: '',
            html: `<div style="display:flex;flex-direction:column;align-items:center;">
                       <div style="${bg}color:white;border-radius:50%;width:28px;height:28px;display:flex;align-items:center;justify-content:center;border:2px solid white;box-shadow:0 2px 8px rgba(0,0,0,.35);">
                           <svg width="13" height="13" viewBox="0 0 24 24" fill="white">
                               <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5a2.5 2.5 0 110-5 2.5 2.5 0 010 5z"/>
                           </svg>
                       </div>
                       <div style="margin-top:1px;background:${labelBg};color:white;font-size:8px;font-weight:800;padding:1px 4px;border-radius:3px;letter-spacing:.5px;">${codigo}</div>
                   </div>`,
            iconSize:     [34, 42],
            iconAnchor:   [17, 28],
            popupAnchor:  [0, -28]
        });
    }

    /* ── Extraer routeInfo ── */
    function extraerRouteInfo(v) {
        if (!v || !v.info) return null;
        const i = v.info;
        if (i.latOrigen == null || i.lngOrigen == null ||
            i.latDestino == null || i.lngDestino == null) return null;
        return {
            latOrigen:    i.latOrigen,
            lngOrigen:    i.lngOrigen,
            latDestino:   i.latDestino,
            lngDestino:   i.lngDestino,
            origen:       i.origen       || '?',
            destino:      i.destino      || '?',
            ciudadOrigen:  i.ciudadOrigen  || '',
            ciudadDestino: i.ciudadDestino || ''
        };
    }

    /* ═══════════════ INIT ═══════════════ */
    document.addEventListener('DOMContentLoaded', async () => {
        map = L.map('map', {
            zoomControl: true,
            fullscreenControl: true,
            fullscreenControlOptions: {
                position: 'topleft',
                title: 'Pantalla completa',
                titleCancel: 'Salir de pantalla completa'
            }
        }).setView([40.4167, -3.7032], 5);

        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
            maxZoom:     19,
            attribution: '&copy; CartoDB &copy; OSM'
        }).addTo(map);

        routeLayer = L.layerGroup().addTo(map);
        setTimeout(() => map.invalidateSize(true), 250);

        map.on('click', () => deseleccionarVuelo());

        await cargarDatosIniciales();

        /* ── SignalR ── */
        const connection = new signalR.HubConnectionBuilder()
            .withUrl(cfg.hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.onreconnecting(() => setStatus('Reconectando...', 'yellow'));
        connection.onreconnected(()  => setStatus('Online', 'green'));
        connection.onclose(()        => setStatus('Desconectado', 'red'));

        connection.on('RadarActualizado', (lista) => {
            if (!Array.isArray(lista)) return;
            lista.forEach(v => actualizarPosicionAvion(v));
            document.getElementById('count-aviones').innerText = Object.keys(markers).length;
        });

        connection.on('VueloCompletado', (msg) => {
            if (msg && msg.vueloId) eliminarVuelo(msg.vueloId);
        });

        try {
            await connection.start();
            await connection.invoke('JoinRadarGroup');
            setStatus('Online', 'green');
        } catch (e) {
            console.error('[radar] Error SignalR', e);
            setStatus('Error conexión', 'red');
        }
    });

    /* ── Status ── */
    function setStatus(text, color) {
        const el = document.getElementById('trackingStatus');
        if (!el) return;
        const c = { green: 'bg-green-500', yellow: 'bg-yellow-500', red: 'bg-red-500', blue: 'bg-blue-500' };
        el.innerHTML = `<span class="relative flex h-3 w-3">
                            <span class="relative inline-flex rounded-full h-3 w-3 ${c[color] || c.blue}"></span>
                        </span> ${text}`;
    }

    /* ── Bootstrap ── */
    async function cargarDatosIniciales() {
        try {
            const res  = await fetch(cfg.bootstrapUrl, { headers: { 'Accept': 'application/json' } });
            const json = await res.json();
            if (json.success && json.data) {
                json.data.forEach(v => actualizarPosicionAvion(v));
                document.getElementById('count-aviones').innerText = json.data.length;
            }
        } catch (e) {
            console.error('[radar] Error cargando datos iniciales', e);
        }
    }

    /* ═══════════════ ACTUALIZAR POSICIÓN ═══════════════ */
    function actualizarPosicionAvion(v) {
        if (!v || typeof v.lat !== 'number' || typeof v.lng !== 'number') return;
        if (isNaN(v.lat) || isNaN(v.lng)) return;

        const existing    = markers[v.vueloId];
        let heading       = 0;
        const newRouteInfo = extraerRouteInfo(v);

        if (existing) {
            const dLat = v.lat - existing.prevLat;
            const dLng = v.lng - existing.prevLng;

            if (Math.abs(dLat) > 0.0001 || Math.abs(dLng) > 0.0001) {
                heading = calcularHeading(existing.prevLat, existing.prevLng, v.lat, v.lng);
            } else if (existing.heading) {
                heading = existing.heading;
            } else if (existing.routeInfo) {
                heading = calcularHeading(
                    existing.routeInfo.latOrigen, existing.routeInfo.lngOrigen,
                    existing.routeInfo.latDestino, existing.routeInfo.lngDestino);
            }

            existing.prevLat = v.lat;
            existing.prevLng = v.lng;
            existing.heading = heading;
            if (newRouteInfo) existing.routeInfo = newRouteInfo;
            existing.data = v;

            existing.marker.setLatLng([v.lat, v.lng]);
            existing.marker.setIcon(crearIconoAvion(heading, v.vueloId === selectedVueloId));

            if (existing.marker.isPopupOpen()) {
                existing.marker.setPopupContent(crearPopup(v, heading, existing.routeInfo));
            }

            if (v.vueloId === selectedVueloId) dibujarRuta(existing);

        } else {
            const routeInfo = newRouteInfo;

            if (routeInfo) {
                heading = calcularHeading(
                    routeInfo.latOrigen, routeInfo.lngOrigen,
                    routeInfo.latDestino, routeInfo.lngDestino);
            }

            const marker = L.marker([v.lat, v.lng], { icon: crearIconoAvion(heading, false) })
                .addTo(map)
                .bindPopup(crearPopup(v, heading, routeInfo));

            marker.on('click', (e) => {
                L.DomEvent.stopPropagation(e);
                seleccionarVuelo(v.vueloId);
            });

            markers[v.vueloId] = {
                marker,
                data:     v,
                prevLat:  v.lat,
                prevLng:  v.lng,
                heading,
                routeInfo
            };

            agregarAListaLateral(v);
        }

        // Actualizar Cesium si está activo
        if (vista3DActiva && markers[v.vueloId]) {
            actualizarEntidadCesium(v.vueloId, markers[v.vueloId]);
        }
    }

    /* ═══════════════ SELECCIÓN ═══════════════ */
    function seleccionarVuelo(vueloId) {
        if (selectedVueloId === vueloId) { deseleccionarVuelo(); return; }

        if (selectedVueloId && markers[selectedVueloId]) {
            const prev = markers[selectedVueloId];
            prev.marker.setIcon(crearIconoAvion(prev.heading || 0, false));
        }

        selectedVueloId = vueloId;
        const entry = markers[vueloId];
        if (!entry) return;

        entry.marker.setIcon(crearIconoAvion(entry.heading || 0, true));
        entry.marker.openPopup();
        dibujarRuta(entry);

        document.querySelectorAll('#lista-vuelos > div[id]').forEach(el => {
            el.classList.remove('!bg-blue-50', '!border-blue-500');
            el.classList.add('border-transparent');
        });
        const item = document.getElementById(`item-${vueloId}`);
        if (item) {
            item.classList.remove('border-transparent');
            item.classList.add('!bg-blue-50', '!border-blue-500');
        }

        if (entry.routeInfo) {
            const ri     = entry.routeInfo;
            const bounds = L.latLngBounds(
                [ri.latOrigen,  ri.lngOrigen],
                [ri.latDestino, ri.lngDestino]
            ).extend([entry.data.lat, entry.data.lng]);
            map.flyToBounds(bounds, { padding: [80, 80], duration: 0.8, maxZoom: 8 });
        } else {
            const ll = entry.marker.getLatLng();
            map.flyTo([ll.lat, ll.lng], 7, { duration: 0.8 });
        }
    }

    function deseleccionarVuelo() {
        if (selectedVueloId && markers[selectedVueloId]) {
            const prev = markers[selectedVueloId];
            prev.marker.setIcon(crearIconoAvion(prev.heading || 0, false));
            prev.marker.closePopup();
        }
        selectedVueloId = null;
        routeLayer.clearLayers();

        document.querySelectorAll('#lista-vuelos > div[id]').forEach(el => {
            el.classList.remove('!bg-blue-50', '!border-blue-500');
            el.classList.add('border-transparent');
        });
    }

    /* ═══════════════ DIBUJAR RUTA ═══════════════ */
    function dibujarRuta(entry) {
        routeLayer.clearLayers();
        const ri = entry.routeInfo;
        if (!ri) return;

        const origenLL  = [ri.latOrigen,  ri.lngOrigen];
        const destinoLL = [ri.latDestino, ri.lngDestino];
        const avionLL   = [entry.data.lat, entry.data.lng];

        L.polyline([origenLL, destinoLL], {
            color: '#f59e0b', weight: 2.5, opacity: 0.6, dashArray: '10 6'
        }).addTo(routeLayer);

        L.polyline([origenLL, avionLL], {
            color: '#22c55e', weight: 3, opacity: 0.9
        }).addTo(routeLayer);

        L.marker(origenLL, { icon: crearIconoAeropuerto(ri.origen, 'origen'), zIndexOffset: -100 })
            .addTo(routeLayer)
            .bindTooltip(`<b>${ri.origen}</b> — ${ri.ciudadOrigen}<br><span style="color:#16a34a;font-weight:700;">ORIGEN</span>`,
                { direction: 'top', offset: [0, -30] });

        L.marker(destinoLL, { icon: crearIconoAeropuerto(ri.destino, 'destino'), zIndexOffset: -100 })
            .addTo(routeLayer)
            .bindTooltip(`<b>${ri.destino}</b> — ${ri.ciudadDestino}<br><span style="color:#dc2626;font-weight:700;">DESTINO</span>`,
                { direction: 'top', offset: [0, -30] });
    }

    /* ═══════════════ POPUP ═══════════════ */
    function crearPopup(v, heading, routeInfo) {
        const info     = v.info || {};
        const origen   = (routeInfo && routeInfo.origen)  || info.origen  || '?';
        const destino  = (routeInfo && routeInfo.destino) || info.destino || '?';
        const alt      = Math.round(info.altitud  || 0);
        const prog     = Math.round((info.progreso || 0) * 100);
        const hdg      = heading != null ? Math.round(heading) : '—';
        const matricula = v.matricula || '';

        return `<div style="font-size:12px;min-width:170px;">
            <div style="font-weight:800;color:#3b82f6;font-size:14px;margin-bottom:2px;">${v.numeroVuelo || 'N/A'}</div>
            ${matricula ? `<div style="font-size:10px;color:#9ca3af;margin-bottom:4px;font-family:monospace;">${matricula}</div>` : ''}
            <div style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">
                <span style="font-weight:700;color:#16a34a;">${origen}</span>
                <span style="color:#6b7280;">→</span>
                <span style="font-weight:700;color:#ef4444;">${destino}</span>
            </div>
            <div style="font-size:10px;color:#9ca3af;display:grid;grid-template-columns:1fr 1fr;gap:2px 10px;">
                <span>Alt: <b style="color:#e5e7eb;">${alt.toLocaleString()} ft</b></span>
                <span>HDG: <b style="color:#e5e7eb;">${hdg}°</b></span>
                <span>Progreso: <b style="color:#e5e7eb;">${prog}%</b></span>
            </div>
            <div style="margin-top:6px;background:rgba(255,255,255,.1);border-radius:4px;overflow:hidden;height:4px;">
                <div style="width:${prog}%;height:100%;background:linear-gradient(90deg,#3b82f6,#60a5fa);border-radius:4px;transition:width .6s;"></div>
            </div>
        </div>`;
    }

    /* ═══════════════ ELIMINAR ═══════════════ */
    function eliminarVuelo(vueloId) {
        eliminarEntidadCesium(vueloId);

        if (markers[vueloId]) {
            map.removeLayer(markers[vueloId].marker);
            delete markers[vueloId];
        }
        if (selectedVueloId === vueloId) {
            selectedVueloId = null;
            routeLayer.clearLayers();
        }

        const item = document.getElementById(`item-${vueloId}`);
        if (item) item.remove();

        document.getElementById('count-aviones').innerText = Object.keys(markers).length;
    }

    /* ═══════════════ LISTA LATERAL ═══════════════ */
    function agregarAListaLateral(v) {
        const lista = document.getElementById('lista-vuelos');
        if (!lista) return;
        if (document.getElementById(`item-${v.vueloId}`)) return;

        const placeholder = lista.querySelector('.italic');
        if (placeholder) placeholder.remove();

        const info     = v.info || {};
        const origen   = info.origen  || '?';
        const destino  = info.destino || '?';
        const alt      = Math.round(info.altitud || 0);
        const matricula = v.matricula || '';

        lista.insertAdjacentHTML('afterbegin', `
            <div id="item-${v.vueloId}"
                 class="p-3 hover:bg-gray-700/40 cursor-pointer transition-all duration-200 border-l-4 border-transparent"
                 onclick="window.__radarEnfocar && window.__radarEnfocar(${v.vueloId})">
                <div class="flex justify-between items-center">
                    <span class="font-bold text-blue-400 text-sm">${v.numeroVuelo || 'N/A'}</span>
                    <span class="text-[10px] bg-gray-700 px-1.5 py-0.5 rounded text-gray-400">${alt} ft</span>
                </div>
                <div class="text-[10px] text-gray-500 uppercase mt-1">${origen} → ${destino}</div>
                ${matricula ? `<div class="text-[9px] text-gray-600 font-mono mt-0.5">${matricula}</div>` : ''}
            </div>`);
    }

    /* ═══════════════ CESIUM — FUNCIONES ═══════════════ */
    function iniciarCesium() {
        if (cesiumViewer) return;

        cesiumViewer = new Cesium.Viewer('map3d', {
            terrain: Cesium.Terrain.fromWorldTerrain(),
            baseLayerPicker:      false,
            navigationHelpButton: false,
            sceneModePicker:      true,
            timeline:             false,
            animation:            false,
            fullscreenButton:     false,
            homeButton:           false,
            geocoder:             false,
            infoBox:              true,
            selectionIndicator:   true,
        });

        // Cargar entidades de aviones ya existentes en Leaflet
        Object.entries(markers).forEach(([vueloId, entry]) => {
            agregarEntidadCesium(vueloId, entry);
        });
    }

    function agregarEntidadCesium(vueloId, entry) {
        if (!cesiumViewer || cesiumEntities[vueloId]) return;

        const v    = entry.data;
        const info = v.info || {};
        const alt  = (info.altitud || 0) * 0.3048;
        const pos  = Cesium.Cartesian3.fromDegrees(v.lng, v.lat, alt);

        const entity = cesiumViewer.entities.add({
            id:   `vuelo_${vueloId}`,
            name: v.numeroVuelo || 'N/A',
            position: pos,
            orientation: Cesium.Transforms.headingPitchRollQuaternion(
                pos,
                new Cesium.HeadingPitchRoll(Cesium.Math.toRadians(entry.heading || 0), 0, 0)
            ),
            model: {
                uri:              '/assets/models/AirbusA320.glb',
                minimumPixelSize: 48,
                maximumScale:     20000,
                silhouetteColor:  Cesium.Color.WHITE,
                silhouetteSize:   2,
            },
            label: {
                text:       v.numeroVuelo || '',
                font:       '12px monospace',
                fillColor:  Cesium.Color.WHITE,
                outlineColor: Cesium.Color.BLACK,
                outlineWidth: 2,
                style:      Cesium.LabelStyle.FILL_AND_OUTLINE,
                pixelOffset: new Cesium.Cartesian2(0, -40),
                distanceDisplayCondition: new Cesium.DistanceDisplayCondition(0, 2000000),
            },
            description: `
                <table style="font-family:monospace;font-size:13px;width:100%">
                    <tr><td><b>Vuelo</b></td><td>${v.numeroVuelo || 'N/A'}</td></tr>
                    <tr><td><b>Ruta</b></td><td>${info.origen || '?'} → ${info.destino || '?'}</td></tr>
                    <tr><td><b>Altitud</b></td><td>${Math.round(info.altitud || 0).toLocaleString()} ft</td></tr>
                    <tr><td><b>Heading</b></td><td>${Math.round(entry.heading || 0)}°</td></tr>
                    <tr><td><b>Progreso</b></td><td>${Math.round((info.progreso || 0) * 100)}%</td></tr>
                </table>`
        });

        cesiumEntities[vueloId] = entity;
    }

    function actualizarEntidadCesium(vueloId, entry) {
        if (!cesiumViewer) return;

        if (!cesiumEntities[vueloId]) {
            agregarEntidadCesium(vueloId, entry);
            return;
        }

        const v    = entry.data;
        const info = v.info || {};
        const alt  = (info.altitud || 0) * 0.3048;
        const pos  = Cesium.Cartesian3.fromDegrees(v.lng, v.lat, alt);

        const entity     = cesiumEntities[vueloId];
        entity.position  = pos;
        entity.orientation = Cesium.Transforms.headingPitchRollQuaternion(
            pos,
            new Cesium.HeadingPitchRoll(Cesium.Math.toRadians(entry.heading || 0), 0, 0)
        );
    }

    function eliminarEntidadCesium(vueloId) {
        if (!cesiumViewer || !cesiumEntities[vueloId]) return;
        cesiumViewer.entities.remove(cesiumEntities[vueloId]);
        delete cesiumEntities[vueloId];
    }

    /* ═══════════════ TOGGLE VISTA ═══════════════ */
    function setVista(modo) {
        const map2d = document.getElementById('map');
        const map3d = document.getElementById('map3d');
        const btn2D = document.getElementById('btn2D');
        const btn3D = document.getElementById('btn3D');

        if (modo === '3d') {
            map2d.style.display = 'none';
            map3d.style.display = 'block';
            vista3DActiva = true;

            btn3D.classList.replace('bg-gray-200', 'bg-blue-600');
            btn3D.classList.replace('text-gray-700', 'text-white');
            btn2D.classList.replace('bg-blue-600',  'bg-gray-200');
            btn2D.classList.replace('text-white',    'text-gray-700');

            iniciarCesium();
        } else {
            map3d.style.display = 'none';
            map2d.style.display = 'block';
            vista3DActiva = false;

            btn2D.classList.replace('bg-gray-200', 'bg-blue-600');
            btn2D.classList.replace('text-gray-700', 'text-white');
            btn3D.classList.replace('bg-blue-600',  'bg-gray-200');
            btn3D.classList.replace('text-white',    'text-gray-700');

            setTimeout(() => map.invalidateSize(true), 100);
        }
    }

    /* ═══════════════ EXPONER AL WINDOW ═══════════════ */
    window.setVista      = setVista;
    window.__radarEnfocar = function (vueloId) {
        seleccionarVuelo(vueloId);
    };

})();