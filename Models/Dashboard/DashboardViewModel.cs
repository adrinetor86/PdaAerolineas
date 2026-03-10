namespace PdaAerolineas.Models.Dashboard;


    public class DashboardViewModel
    {
        // Estadísticas Generales
        public int TotalVuelos { get; set; }
        public int VuelosEnVuelo { get; set; }
        public int VuelosHoy { get; set; }
        public int VuelosCancelados { get; set; }
        
        // Aeronaves
        public int TotalAeronaves { get; set; }
        public int AeronavesOperativas { get; set; }
        public int AeronavesEnMantenimiento { get; set; }
        public int AeronavesEnVuelo { get; set; }
        
        // Pasajeros
        public int PasajerosHoy { get; set; }
        public double OcupacionPromedio { get; set; }
        public int TotalPasajerosMes { get; set; }
        
        // Mantenimiento
        public int MantenimientosActivos { get; set; }
        public int MantenimientosPendientes { get; set; }
        
        public List<ProximoVueloDto> ProximosVuelos { get; set; } = new();
        public List<VueloRecienteDto> VuelosRecientes { get; set; } = new();
        public List<TopRutaDto> TopRutas { get; set; } = new();
        
        // Gráficos (datos en JSON)
        public string VuelosPorHoraJson { get; set; }
        public string VuelosPorEstadoJson { get; set; }
        public string OcupacionSemanalJson { get; set; }
        public string AeronavesPorEstadoJson { get; set; }
    }
