// Tracking en directo de un vuelo usando SignalR + Leaflet + Cesium
// Requiere que la vista defina: window.VUELO_TRACKING = { idVuelo, hubUrl, bootstrapUrl }

(function () {
  'use strict';

  const cfg = window.VUELO_TRACKING;
  if (!cfg || cfg.idVuelo == null) return;

  const vueloId = Number(cfg.idVuelo);

  const elStatus = document.getElementById('trackingStatus');
  const elInfo   = document.getElementById('trackingInfo');

  function setStatus(text) {
    if (elStatus) elStatus.textContent = text;
  }

  function setInfo(lines) {
    if (!elInfo) return;
    elInfo.innerHTML = '';
    for (const l of lines) {
      const div = document.createElement('div');
      div.textContent = l;
      elInfo.appendChild(div);
    }
  }

  /* ═══════════════ LEAFLET ═══════════════ */
  const map = L.map('map', { zoomControl: true });
  map.setView([40.4168, -3.7038], 5);

  const tiles = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; OpenStreetMap'
  });

  tiles.on('tileerror', (e) => {
    console.error('[tracking] tile error', e);
    setStatus('Mapa cargado, pero fallan los tiles.');
  });

  tiles.addTo(map);
  setTimeout(() => map.invalidateSize(true), 250);

  const planeIcon = L.divIcon({
    className: 'plane-marker',
    html: `<div id="plane-icon-body" style="transition:transform 0.6s ease-out;display:flex;justify-content:center;align-items:center;">
                   <img src="/assets/images/icons/plane-icon.png" style="width:40px;height:40px"/>
               </div>`,
    iconSize: [40, 40],
    iconAnchor: [20, 20]
  });

  let marker         = null;
  let routeLine      = null;
  let frameAnimacion = null;

  function calcularAngulo(lat1, lng1, lat2, lng2) {
    const toRad = d => d * Math.PI / 180;
    const toDeg = r => r * 180 / Math.PI;
    const y = Math.sin(toRad(lng2 - lng1)) * Math.cos(toRad(lat2));
    const x = Math.cos(toRad(lat1)) * Math.sin(toRad(lat2)) -
        Math.sin(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.cos(toRad(lng2 - lng1));
    return (toDeg(Math.atan2(y, x)) + 360) % 360;
  }

  function upsertMarker(lat, lng) {
    if (typeof lat !== 'number' || typeof lng !== 'number' || isNaN(lat) || isNaN(lng)) return;

    if (!marker) {
      marker = L.marker([lat, lng], { title: 'Avión', icon: planeIcon }).addTo(map);
      map.setView([lat, lng], 6);
      return;
    }

    const origen  = marker.getLatLng();
    const destino = L.latLng(lat, lng);

    if (origen.lat === destino.lat && origen.lng === destino.lng) return;

    const angulo = calcularAngulo(origen.lat, origen.lng, destino.lat, destino.lng);
    const divAvion = document.getElementById('plane-icon-body');
    if (divAvion) divAvion.style.transform = `rotate(${angulo}deg)`;

    const tiempoInicio      = performance.now();
    const duracionAnimacion = 2900;

    function animar(tiempoActual) {
      let progreso = (tiempoActual - tiempoInicio) / duracionAnimacion;
      if (progreso > 1) progreso = 1;

      const latActual = origen.lat + (destino.lat - origen.lat) * progreso;
      const lngActual = origen.lng + (destino.lng - origen.lng) * progreso;

      marker.setLatLng([latActual, lngActual]);

      if (progreso < 1) frameAnimacion = requestAnimationFrame(animar);
    }

    if (frameAnimacion) cancelAnimationFrame(frameAnimacion);
    frameAnimacion = requestAnimationFrame(animar);
  }

  function upsertRoute(origen, destino) {
    if (!origen || !destino) return;
    const coords = [[origen.lat, origen.lng], [destino.lat, destino.lng]];
    if (routeLine) { routeLine.setLatLngs(coords); return; }
    routeLine = L.polyline(coords, { color: '#2563eb', weight: 3, opacity: 0.7 }).addTo(map);
    map.fitBounds(routeLine.getBounds(), { padding: [20, 20] });
  }

  /* ═══════════════ BOOTSTRAP ═══════════════ */
  async function bootstrap() {
    setStatus('Cargando datos del vuelo...');

    const r = await fetch(cfg.bootstrapUrl, { headers: { 'Accept': 'application/json' } });
    let data = null;
    try { data = await r.json(); } catch {}

    if (!r.ok || (data && data.success === false)) {
      setStatus('No se pudo cargar la posición inicial.');
      setInfo(['Error cargando datos del backend.']);
      return;
    }

    const infoLines = [];
    if (data.numeroVuelo) infoLines.push(`Vuelo: ${data.numeroVuelo}`);
    if (data.origen && data.destino) infoLines.push(`Ruta: ${data.origen.codigo} → ${data.destino.codigo}`);

    if (data.origen && data.destino) upsertRoute(data.origen, data.destino);

    const tienePosicion = data.posicion &&
        typeof data.posicion.lat === 'number' &&
        typeof data.posicion.lng === 'number';

    if (tienePosicion) {
      upsertMarker(data.posicion.lat, data.posicion.lng);
      infoLines.push(`Posición: OK (${data.posicion.lat.toFixed(4)}, ${data.posicion.lng.toFixed(4)})`);
    } else if (data.origen && typeof data.origen.lat === 'number') {
      upsertMarker(data.origen.lat, data.origen.lng);
      infoLines.push('Posición actual: mostrando avión en ORIGEN');
    }

    setInfo(infoLines);
    setStatus('Conectando en directo...');
    setTimeout(() => map.invalidateSize(true), 250);
  }

  /* ═══════════════ SIGNALR ═══════════════ */
  async function startRealtime() {
    const connection = new signalR.HubConnectionBuilder()
        .withUrl(cfg.hubUrl)
        .withAutomaticReconnect()
        .build();

    connection.onreconnecting(() => setStatus('Reconectando...'));
    connection.onreconnected(() => setStatus('Conectado (reconectado).'));
    connection.onclose(() => setStatus('Desconectado.'));

    connection.on('PosicionActualizada', (msg) => {
      if (!msg) return;
      const msgVueloId = Number(msg.vueloId);
      if (!Number.isFinite(msgVueloId) || msgVueloId !== vueloId) return;

      if (typeof msg.lat === 'number' && typeof msg.lng === 'number') {
        upsertMarker(msg.lat, msg.lng);
      }

      if (vista3DActiva) {
        actualizarCesiumTracking(msg.lat, msg.lng, msg.altitud || 35000, msg.heading || 0);
      }
    });

    connection.on('VueloCompletado', (msg) => {
      if (!msg) return;
      const msgVueloId = Number(msg.vueloId);
      if (!Number.isFinite(msgVueloId) || msgVueloId !== vueloId) return;
      setStatus('Vuelo completado.');
    });

    await connection.start();
    await connection.invoke('JoinVueloGroup', vueloId);
    setStatus('Conectado en directo.');
  }

  (async () => {
    try {
      await bootstrap();
      await startRealtime();
    } catch (e) {
      console.error('[tracking] Error:', e);
      setStatus('Error iniciando el tracking.');
    }
  })();

  /* ═══════════════ CESIUM TRACKING ═══════════════ */
  let cesiumViewer   = null;
  let cesiumEntity   = null;
  let vista3DActiva  = false;

  function iniciarCesiumTracking(lat, lng, alt, heading) {
    if (cesiumViewer) return;

    cesiumViewer = new Cesium.Viewer('map3d', {
      terrain: Cesium.Terrain.fromWorldTerrain(),
      baseLayerPicker:      false,
      navigationHelpButton: false,
      timeline:             false,
      animation:            false,
      fullscreenButton:     false,
      homeButton:           false,
      geocoder:             false,
      infoBox:              true,
      selectionIndicator:   true,
    });

    const altMetros = (alt || 0) * 0.3048;
    const posicion  = Cesium.Cartesian3.fromDegrees(lng, lat, altMetros);

    cesiumEntity = cesiumViewer.entities.add({
      position: posicion,
      orientation: Cesium.Transforms.headingPitchRollQuaternion(
          posicion,
          new Cesium.HeadingPitchRoll(Cesium.Math.toRadians(heading || 0), 0, 0)
      ),
      model: {
        uri:              '/assets/models/AirbusA320.glb',
        minimumPixelSize: 64,
        maximumScale:     20000,
        silhouetteColor:  Cesium.Color.WHITE,
        silhouetteSize:   2,
      },
      path: {
        resolution: 1,
        material: new Cesium.PolylineGlowMaterialProperty({
          glowPower: 0.1,
          color:     Cesium.Color.fromCssColorString('#3b82f6'),
        }),
        width:     3,
        leadTime:  0,
        trailTime: 3600,
      }
    });

    cesiumViewer.trackedEntity = cesiumEntity;
  }

  function actualizarCesiumTracking(lat, lng, alt, heading) {
    if (!cesiumViewer || !cesiumEntity) return;

    const altMetros = (alt || 0) * 0.3048;
    const pos       = Cesium.Cartesian3.fromDegrees(lng, lat, altMetros);

    cesiumEntity.position    = pos;
    cesiumEntity.orientation = Cesium.Transforms.headingPitchRollQuaternion(
        pos,
        new Cesium.HeadingPitchRoll(Cesium.Math.toRadians(heading || 0), 0, 0)
    );
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
      btn2D.classList.replace('bg-blue-600', 'bg-gray-200');
      btn2D.classList.replace('text-white',   'text-gray-700');

      if (marker) {
        const ll = marker.getLatLng();
        iniciarCesiumTracking(ll.lat, ll.lng, 35000, 0);
      }
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
  window.setVista = setVista;

})();