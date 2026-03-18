
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
    lines.forEach(l => {
      const div = document.createElement('div');
      div.textContent = l;
      elInfo.appendChild(div);
    });
  }

  /* ═══════════════ LEAFLET ═══════════════ */
  const map = L.map('map', {
    zoomControl: true,
    fullscreenControl: true
  }).setView([40.4, -3.7], 5);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; CartoDB &copy; OSM'
  }).addTo(map);

  setTimeout(() => map.invalidateSize(true), 250);

  const planeIcon = L.divIcon({
    className: '',
    html: `
    <div id="plane-icon-body" style="
        display:flex;
        justify-content:center;
        align-items:center;
        transform-origin:center;
    ">
        <img src="/assets/images/icons/plane-icon.png"
             style="width:40px;height:40px;background:transparent;display:block;" />
    </div>
  `,
    iconSize: [40, 40],
    iconAnchor: [20, 20]
  });
  let marker = null;
  let routeLine = null;
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
    if (!marker) {
      marker = L.marker([lat, lng], { icon: planeIcon }).addTo(map);
      return;
    }

    const origen = marker.getLatLng();
    const destino = L.latLng(lat, lng);

    const angulo = calcularAngulo(origen.lat, origen.lng, destino.lat, destino.lng);
    const divAvion = document.getElementById('plane-icon-body');
    if (divAvion) divAvion.style.transform = `rotate(${angulo}deg)`;

    const inicio = performance.now();
    const duracion = 2000;
    marker.setLatLng([lat, lng]);
    
    
    function animar(t) {
      let p = (t - inicio) / duracion;
      if (p > 1) p = 1;

      const latActual = origen.lat + (destino.lat - origen.lat) * p;
      const lngActual = origen.lng + (destino.lng - origen.lng) * p;

      marker.setLatLng([latActual, lngActual]);

      if (p < 1) frameAnimacion = requestAnimationFrame(animar);
    }

    if (frameAnimacion) cancelAnimationFrame(frameAnimacion);
    frameAnimacion = requestAnimationFrame(animar);
  }

  function upsertRoute(o, d) {
    if (!o || !d) return;
    const coords = [[o.lat, o.lng], [d.lat, d.lng]];
    if (routeLine) return routeLine.setLatLngs(coords);

    routeLine = L.polyline(coords, { color: '#2563eb' }).addTo(map);
    map.fitBounds(routeLine.getBounds());
  }

  /* ═══════════════ CESIUM ═══════════════ */
  let cesiumViewer = null;
  let cesiumEntity = null;
  let vista3DActiva = false;

  let headingSuave = 0;


  function iniciarCesium(lat, lng, alt, heading) {
    if (cesiumViewer) return;

    cesiumViewer = new Cesium.Viewer('map3d', {
      terrain: Cesium.Terrain.fromWorldTerrain(),
      timeline: false,
      animation: false
    });

    const pos = Cesium.Cartesian3.fromDegrees(lng, lat, alt * 0.3048);

    cesiumEntity = cesiumViewer.entities.add({
      position: pos,
      model: {
        uri: '/assets/models/AirbusA320.glb',
        minimumPixelSize: 64
      }
    });

    cesiumViewer.trackedEntity = cesiumEntity;
  }

  function actualizarCesium(lat, lng, alt, heading) {
    if (!cesiumEntity) return;

    const pos = Cesium.Cartesian3.fromDegrees(lng, lat, alt * 0.3048);

    const h = heading;

    // 🔥 CORRECCIÓN CLAVE
    const headingCorregido = h - 90;

    cesiumEntity.position = pos;
    cesiumEntity.orientation = Cesium.Transforms.headingPitchRollQuaternion(
        pos,
        new Cesium.HeadingPitchRoll(
            Cesium.Math.toRadians(headingCorregido),
            0,
            0
        )
    );
  }

  /* ═══════════════ SIGNALR ═══════════════ */
  async function startRealtime() {
    const connection = new signalR.HubConnectionBuilder()
        .withUrl(cfg.hubUrl)
        .withAutomaticReconnect()
        .build();

    connection.on('PosicionActualizada', msg => {
      if (msg.vueloId !== vueloId) return;

      if (marker) {
        const prev = marker.getLatLng();
        const heading = calcularAngulo(prev.lat, prev.lng, msg.lat, msg.lng);

        upsertMarker(msg.lat, msg.lng);

        if (vista3DActiva) {
          actualizarCesium(msg.lat, msg.lng, msg.altitud || 35000, heading);
        }
      } else {
        upsertMarker(msg.lat, msg.lng);
      }
    });

    await connection.start();
    await connection.invoke('JoinVueloGroup', vueloId);
  }

  /* ═══════════════ INIT ═══════════════ */
  (async () => {
    const r = await fetch(cfg.bootstrapUrl);
    const data = await r.json();

    if (data.origen && data.destino) {
      upsertRoute(data.origen, data.destino);
    }

    if (data.posicion) {
      upsertMarker(data.posicion.lat, data.posicion.lng);
    }

    startRealtime();
  })();

  /* ═══════════════ UI ═══════════════ */
  function setVista(modo) {
    const map2d = document.getElementById('map');
    const map3d = document.getElementById('map3d');
    const btn2d = document.getElementById('btn2D');
    const btn3d = document.getElementById('btn3D');

    const activarBoton = (btnActivo, btnInactivo) => {
      if (!btnActivo || !btnInactivo) return;
      btnActivo.classList.add('bg-blue-600', 'text-white');
      btnActivo.classList.remove('bg-gray-200', 'text-gray-700');
      btnInactivo.classList.remove('bg-blue-600', 'text-white');
      btnInactivo.classList.add('bg-gray-200', 'text-gray-700');
    };

    if (modo === '3d') {
      map2d.style.display = 'none';
      map3d.style.display = 'block';
      vista3DActiva = true;
      activarBoton(btn3d, btn2d);

      if (marker) {
        const ll = marker.getLatLng();
        iniciarCesium(ll.lat, ll.lng, 35000, 0);
      }
    } else {
      map3d.style.display = 'none';
      map2d.style.display = 'block';
      vista3DActiva = false;
      activarBoton(btn2d, btn3d);
      setTimeout(() => map.invalidateSize(), 100);
    }
  }

  window.setVista = setVista;

})();