namespace PdaAerolineas.Models.Dashboard;

 public class DashboardStats
    {
        public int TotalVuelos { get; set; }
        public int VuelosEnVuelo { get; set; }
        public int VuelosHoy { get; set; }
        public int VuelosCancelados { get; set; }
        public int TotalAeronaves { get; set; }
        public int AeronavesOperativas { get; set; }
        public int AeronavesEnMantenimiento { get; set; }
        public int AeronavesEnVuelo { get; set; }
        public int PasajerosHoy { get; set; }
        public double OcupacionPromedio { get; set; }
        public int TotalPasajerosMes { get; set; }
        public int MantenimientosActivos { get; set; }
        public int MantenimientosPendientes { get; set; }
    }
    
    // DTO para SP_GET_VUELOS_POR_HORA
    public class VuelosPorHoraDto
    {
        public string Hora { get; set; }
        public int Vuelos { get; set; }
    }
    
    // DTO para SP_GET_VUELOS_POR_ESTADO
    public class VuelosPorEstadoDto
    {
        public string Estado { get; set; }
        public int Total { get; set; }
    }
    
    // DTO para SP_GET_OCUPACION_SEMANAL
    public class OcupacionSemanalDto
    {
        public string Fecha { get; set; }
        public double Ocupacion { get; set; }
    }
    
    // DTO para SP_GET_AERONAVES_POR_ESTADO
    public class AeronavesPorEstadoDto
    {
        public string Estado { get; set; }
        public int Total { get; set; }
    }
    
    // DTO para SP_GET_PROXIMOS_VUELOS
    public class ProximoVueloDto
    {
        public string NumeroVuelo { get; set; }
        public string Ruta { get; set; }
        public DateTime FechaSalida { get; set; }
        public int PasajerosConfirmados { get; set; }
        public int CapacidadTotal { get; set; }
        public string Puerta { get; set; }
        public double PorcentajeOcupacion { get; set; }
    }
    
    // DTO para SP_GET_VUELOS_RECIENTES
    public class VueloRecienteDto
    {
        public string NumeroVuelo { get; set; }
        public string Ruta { get; set; }
        public string Estado { get; set; }
        public DateTime Fecha { get; set; }
        public int Pasajeros { get; set; }
    }
    
    // DTO para SP_GET_TOP_RUTAS
    public class TopRutaDto
    {
        public string Ruta { get; set; }
        public int TotalVuelos { get; set; }
        public int TotalPasajeros { get; set; }
    }