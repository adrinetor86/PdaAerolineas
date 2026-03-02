// Tracking en directo de un vuelo usando SignalR + Leaflet
// Requiere que la vista defina: window.VUELO_TRACKING = { idVuelo, hubUrl, bootstrapUrl }

(function () {
  'use strict';

  const cfg = window.VUELO_TRACKING;
  if (!cfg || cfg.idVuelo == null) return;

  const vueloId = Number(cfg.idVuelo);

  const elStatus = document.getElementById('trackingStatus');
  const elInfo = document.getElementById('trackingInfo');

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

  // --- Mapa (Leaflet)
  const map = L.map('map', { zoomControl: true });
  map.setView([40.4168, -3.7038], 5);

  const tiles = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; OpenStreetMap'
  });

  tiles.on('loading', () => console.debug('[tracking] tiles loading...'));
  tiles.on('load', () => console.debug('[tracking] tiles loaded'));
  tiles.on('tileerror', (e) => {
    console.error('[tracking] tile error', e);
    setStatus('Mapa cargado, pero fallan los tiles (revisa consola/red).');
  });

  tiles.addTo(map);

  setTimeout(() => map.invalidateSize(true), 250);

  // Icono tipo avión
  const planeIcon = L.divIcon({
    className: 'plane-marker',
    html: `<div id="plane-icon-body" style="transition: transform 0.6s ease-out; display: flex; justify-content: center; align-items: center;">
                <img src="/../assets/images/icons/plane-icon.png" style="width: 40px;height: 40px"/>
           </div>`,
    iconSize: [40, 40],
    iconAnchor: [20, 20] // La mitad del tamaño para que quede centrado
  });

  let marker = null;
  let routeLine = null;
  let frameAnimacion = null;

  function calcularAngulo(lat1, lng1, lat2, lng2) {
    const toRad = deg => deg * Math.PI / 180;
    const toDeg = rad => rad * 180 / Math.PI;
    const y = Math.sin(toRad(lng2 - lng1)) * Math.cos(toRad(lat2));
    const x = Math.cos(toRad(lat1)) * Math.sin(toRad(lat2)) - Math.sin(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.cos(toRad(lng2 - lng1));
    return (toDeg(Math.atan2(y, x)) + 360) % 360;
  }

  // FUNCION UPSERT MARKER LIMPIA
  function upsertMarker(lat, lng) {
    if (typeof lat !== 'number' || typeof lng !== 'number' || Number.isNaN(lat) || Number.isNaN(lng)) return;

    // Si es la primera vez que recibe coordenadas, lo planta en el mapa sin animar
    if (!marker) {
      marker = L.marker([lat, lng], { title: 'Avión', icon: planeIcon }).addTo(map);
      map.setView([lat, lng], 6);
      return;
    }

    const origen = marker.getLatLng();
    const destino = L.latLng(lat, lng);

    // Si no se ha movido, no hacemos nada
    if (origen.lat === destino.lat && origen.lng === destino.lng) return;

    // 1. ROTACIÓN: Hacemos que el avión mire hacia el destino
    const angulo = calcularAngulo(origen.lat, origen.lng, destino.lat, destino.lng);
    const divAvion = document.getElementById('plane-icon-body');
    if (divAvion) {
      divAvion.style.transform = `rotate(${angulo}deg)`;
    }

    // 2. DESLIZAMIENTO (RequestAnimationFrame Interpolation)
    const tiempoInicio = performance.now();
    const duracionAnimacion = 2900; // 2.9 segundos exactos

    function animar(tiempoActual) {
      let progreso = (tiempoActual - tiempoInicio) / duracionAnimacion;
      if (progreso > 1) progreso = 1;

      const latActual = origen.lat + (destino.lat - origen.lat) * progreso;
      const lngActual = origen.lng + (destino.lng - origen.lng) * progreso;

      marker.setLatLng([latActual, lngActual]);

      if (progreso < 1) {
        frameAnimacion = requestAnimationFrame(animar);
      }
    }

    if (frameAnimacion) cancelAnimationFrame(frameAnimacion);
    frameAnimacion = requestAnimationFrame(animar);
  }

  function upsertRoute(origen, destino) {
    if (!origen || !destino) return;
    const coords = [
      [origen.lat, origen.lng],
      [destino.lat, destino.lng]
    ];
    if (routeLine) {
      routeLine.setLatLngs(coords);
      return;
    }
    routeLine = L.polyline(coords, { color: '#2563eb', weight: 3, opacity: 0.7 }).addTo(map);
    map.fitBounds(routeLine.getBounds(), { padding: [20, 20] });
  }

  async function bootstrap() {
    setStatus('Cargando datos del vuelo...');

    const r = await fetch(cfg.bootstrapUrl, { headers: { 'Accept': 'application/json' } });
    let data = null;
    try {
      data = await r.json();
    } catch {}

    if (!r.ok || (data && data.success === false)) {
      setStatus('No se pudo cargar la posición inicial.');
      setInfo(['Error cargando datos del backend.']);
      return;
    }

    const infoLines = [];
    if (data.numeroVuelo) infoLines.push(`Vuelo: ${data.numeroVuelo}`);
    if (data.origen && data.destino) infoLines.push(`Ruta: ${data.origen.codigo} → ${data.destino.codigo}`);

    const tienePosicionActual = data.posicion && typeof data.posicion.lat === 'number' && typeof data.posicion.lng === 'number';

    if (data.origen && data.destino) upsertRoute(data.origen, data.destino);

    if (tienePosicionActual) {
      upsertMarker(data.posicion.lat, data.posicion.lng);
      infoLines.push(`Posición: OK (${data.posicion.lat.toFixed(4)}, ${data.posicion.lng.toFixed(4)})`);
    } else if (data.origen && typeof data.origen.lat === 'number' && typeof data.origen.lng === 'number') {
      upsertMarker(data.origen.lat, data.origen.lng);
      infoLines.push('Posición actual: mostrando avión en ORIGEN');
    }

    setInfo(infoLines);
    setStatus('Conectando en directo...');
    setTimeout(() => map.invalidateSize(true), 250);
  }

  // --- SignalR
  let connection = null;

  async function startRealtime() {
    connection = new signalR.HubConnectionBuilder()
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
      setStatus('Error iniciando el tracking.');
    }
  })();
})();