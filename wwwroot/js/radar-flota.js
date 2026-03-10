(function () {
    'use strict';

    const cfg = window.RADAR_CONFIG;
    if (!cfg) return;

    let map, markers = {};

    const planeIcon = L.divIcon({
        html: `<svg class="w-7 h-7" fill="#2563eb" viewBox="0 0 24 24" style="filter:drop-shadow(0 1px 2px rgba(0,0,0,.3))"><path d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5l8 2.5z"/></svg>`,
        className: 'bg-transparent',
        iconSize: [28, 28],
        iconAnchor: [14, 14]
    });

    document.addEventListener("DOMContentLoaded", async () => {
        map = L.map('map', { zoomControl: true }).setView([40.4167, -3.7032], 5);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
            maxZoom: 19,
            attribution: '&copy; CartoDB &copy; OSM'
        }).addTo(map);

        setTimeout(() => map.invalidateSize(true), 250);

        await cargarDatosIniciales();

        const connection = new signalR.HubConnectionBuilder()
            .withUrl(cfg.hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.onreconnecting(() => setStatus('Reconectando...', 'yellow'));
        connection.onreconnected(() => setStatus('Online', 'green'));
        connection.onclose(() => setStatus('Desconectado', 'red'));

        connection.on("RadarActualizado", (lista) => {
            if (!Array.isArray(lista)) return;
            lista.forEach(v => actualizarPosicionAvion(v));
            document.getElementById('count-aviones').innerText = Object.keys(markers).length;
        });

        connection.on("VueloCompletado", (msg) => {
            if (!msg || !msg.vueloId) return;
            eliminarVuelo(msg.vueloId);
        });

        try {
            await connection.start();
            await connection.invoke("JoinRadarGroup");
            setStatus('Online', 'green');
        } catch (e) {
            setStatus('Error conexión', 'red');
        }
    });

    function setStatus(text, color) {
        const el = document.getElementById('trackingStatus');
        if (!el) return;
        const colors = { green: 'bg-green-500', yellow: 'bg-yellow-500', red: 'bg-red-500', blue: 'bg-blue-500' };
        el.innerHTML = `<span class="relative flex h-3 w-3"><span class="relative inline-flex rounded-full h-3 w-3 ${colors[color] || colors.blue}"></span></span> ${text}`;
    }

    async function cargarDatosIniciales() {
        try {
            const res = await fetch(cfg.bootstrapUrl, { headers: { 'Accept': 'application/json' } });
            const json = await res.json();
            if (json.success && json.data) {
                json.data.forEach(v => actualizarPosicionAvion(v));
                document.getElementById('count-aviones').innerText = json.data.length;
            }
        } catch (e) {
            console.error('[radar] Error cargando datos iniciales', e);
        }
    }

    function actualizarPosicionAvion(v) {
        if (!v || typeof v.lat !== 'number' || typeof v.lng !== 'number') return;
        if (isNaN(v.lat) || isNaN(v.lng)) return;

        if (markers[v.vueloId]) {
            markers[v.vueloId].setLatLng([v.lat, v.lng]);
        } else {
            const marker = L.marker([v.lat, v.lng], { icon: planeIcon })
                .addTo(map)
                .bindPopup(crearPopup(v));
            markers[v.vueloId] = marker;
            agregarAListaLateral(v);
        }

        const m = markers[v.vueloId];
        if (m.isPopupOpen()) {
            m.setPopupContent(crearPopup(v));
        }
    }

    function crearPopup(v) {
        const origen = v.info ? v.info.origen : '?';
        const destino = v.info ? v.info.destino : '?';
        const alt = v.info ? Math.round(v.info.altitud) : 0;
        const prog = v.info ? Math.round((v.info.progreso || 0) * 100) : 0;
        return `<div style="font-size:12px">
                    <div style="font-weight:bold;color:#2563eb">${v.numeroVuelo || 'N/A'}</div>
                    <div>${origen} → ${destino}</div>
                    <div>Alt: ${alt} ft · ${prog}%</div>
                </div>`;
    }

    function eliminarVuelo(vueloId) {
        if (markers[vueloId]) {
            map.removeLayer(markers[vueloId]);
            delete markers[vueloId];
        }
        const item = document.getElementById(`item-${vueloId}`);
        if (item) item.remove();
        document.getElementById('count-aviones').innerText = Object.keys(markers).length;
    }

    function agregarAListaLateral(v) {
        const lista = document.getElementById('lista-vuelos');
        if (!lista) return;
        if (document.getElementById(`item-${v.vueloId}`)) return;

        const placeholder = lista.querySelector('.italic');
        if (placeholder) placeholder.remove();

        const origen = v.info ? v.info.origen : '?';
        const destino = v.info ? v.info.destino : '?';
        const alt = v.info ? Math.round(v.info.altitud) : 0;

        const html = `
            <div id="item-${v.vueloId}" class="p-3 hover:bg-gray-50 cursor-pointer transition-colors" onclick="window.__radarEnfocar && window.__radarEnfocar(${v.vueloId})">
                <div class="flex justify-between items-center">
                    <span class="font-bold text-blue-600 text-sm">${v.numeroVuelo || 'N/A'}</span>
                    <span class="text-[10px] bg-gray-100 px-1.5 py-0.5 rounded text-gray-500">${alt} ft</span>
                </div>
                <div class="text-[10px] text-gray-400 uppercase mt-1">${origen} → ${destino}</div>
            </div>`;
        lista.insertAdjacentHTML('afterbegin', html);
    }

    window.__radarEnfocar = function (vueloId) {
        const m = markers[vueloId];
        if (m) {
            const ll = m.getLatLng();
            map.flyTo([ll.lat, ll.lng], 8);
            m.openPopup();
        }
    };
})();
