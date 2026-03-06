let map, markers = {};

const avionIcon = L.divIcon({
    html: `<svg class="w-8 h-8 text-blue-500" fill="currentColor" viewBox="0 0 24 24" style="transform: rotate(45deg);"><path d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5l8 2.5z"/></svg>`,
    className: 'bg-transparent',
    iconSize: [32, 32],
    iconAnchor: [16, 16]
});

document.addEventListener("DOMContentLoaded", async () => {
    // Inicializar mapa
    map = L.map('map').setView([40.4167, -3.7032], 5);
    L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png').addTo(map);

    // 1. Carga Inicial (Bootstrap)
    await cargarDatosIniciales();

    // 2. Conectar SignalR
    const connection = new signalR.HubConnectionBuilder()
        .withUrl(window.RADAR_CONFIG.hubUrl)
        .withAutomaticReconnect()
        .build();

    // Escuchar actualizaciones de CUALQUIER vuelo
    connection.on("UpdateTelemetria", (data) => {
        actualizarPosicionAvion(data);
    });

    connection.start().then(() => {
        document.getElementById('trackingStatus').innerHTML = '<span class="h-3 w-3 rounded-full bg-green-500"></span> Online';
    });
});

async function cargarDatosIniciales() {
    const res = await fetch(window.RADAR_CONFIG.bootstrapUrl);
    const json = await res.json();

    if (json.success) {
        json.data.forEach(v => actualizarPosicionAvion(v));
        document.getElementById('count-aviones').innerText = json.data.length;
    }
}

function actualizarPosicionAvion(v) {
    if (!v.lat || !v.lng) return;

    // Si el avión ya existe, lo movemos. Si no, lo creamos.
    if (markers[v.vueloId]) {
        markers[v.vueloId].setLatLng([v.lat, v.lng]);
    } else {
        const marker = L.marker([v.lat, v.lng], { icon: avionIcon })
            .addTo(map)
            .bindPopup(`<b>${v.numeroVuelo}</b><br>${v.info.origen} ➔ ${v.info.destino}`);

        markers[v.vueloId] = marker;
        agregarAListaLateral(v);
    }
}

function agregarAListaLateral(v) {
    const lista = document.getElementById('lista-vuelos');
    // Evitar duplicados en la lista visual
    if (document.getElementById(`item-${v.vueloId}`)) return;

    const html = `
        <div id="item-${v.vueloId}" class="p-3 hover:bg-gray-50 cursor-pointer transition-colors" onclick="enfocarAvion(${v.lat}, ${v.lng})">
            <div class="flex justify-between items-center">
                <span class="font-bold text-blue-600">${v.numeroVuelo}</span>
                <span class="text-[10px] bg-gray-100 px-1.5 py-0.5 rounded text-gray-500">${v.info.altitud} ft</span>
            </div>
            <div class="text-[10px] text-gray-400 uppercase mt-1">
                ${v.info.origen} ➔ ${v.info.destino}
            </div>
        </div>
    `;
    lista.insertAdjacentHTML('afterbegin', html);
}

function enfocarAvion(lat, lng) {
    map.flyTo([lat, lng], 8);
}