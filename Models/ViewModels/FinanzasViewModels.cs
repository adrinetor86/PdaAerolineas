using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema; 

namespace PdaAerolineas.Models.ViewModels
{

    public class HistorialTripulanteViewModel
    {
        [Column("tripulante_id")]
        public int TripulanteId { get; set; }

        [Column("nombre")]
        public string Nombre { get; set; } = string.Empty;

        [Column("apellido")]
        public string Apellido { get; set; } = string.Empty;

        [Column("nombre_completo")]
        public string NombreCompleto { get; set; } = string.Empty;

        [Column("rol")]
        public string Rol { get; set; } = string.Empty;

        [Column("id_aerolinea")]
        public int? IdAerolinea { get; set; }

        [Column("nombre_aerolinea")]
        public string NombreAerolinea { get; set; } = string.Empty;

        [Column("codigo_aerolinea")]
        public string CodigoAerolinea { get; set; } = string.Empty;

        [Column("vuelo_id")]
        public int VueloId { get; set; }

        [Column("numero_vuelo")]
        public string NumeroVuelo { get; set; } = string.Empty;

        [Column("fecha_salida")]
        public DateTime FechaSalida { get; set; }

        [Column("fecha_llegada")]
        public DateTime FechaLlegada { get; set; }

        [Column("duracion_minutos")]
        public int DuracionMinutos { get; set; }

        [Column("aeropuerto_origen")]
        public string AeropuertoOrigen { get; set; } = string.Empty;

        [Column("iata_origen")]
        public string IataOrigen { get; set; } = string.Empty;

        [Column("ciudad_origen")]
        public string CiudadOrigen { get; set; } = string.Empty;

        [Column("aeropuerto_destino")]
        public string AeropuertoDestino { get; set; } = string.Empty;

        [Column("iata_destino")]
        public string IataDestino { get; set; } = string.Empty;

        [Column("ciudad_destino")]
        public string CiudadDestino { get; set; } = string.Empty;

        [Column("distancia_km")]
        public int DistanciaKm { get; set; }

        [Column("estado_vuelo")]
        public string EstadoVuelo { get; set; } = string.Empty;

        [Column("pasajeros_embarcados")]
        public int PasajerosEmbarcados { get; set; }

        [Column("precio_billete")]
        public decimal PrecioBillete { get; set; }

        // Calculados
        [NotMapped]
        public string DuracionFormateada =>
            $"{DuracionMinutos / 60}h {DuracionMinutos % 60}min";

        [NotMapped]
        public string RutaCorta => $"{IataOrigen} → {IataDestino}";
    }

    // =====================================================
    // INGRESOS POR VUELO (mapea v_ingresos_vuelos)
    // =====================================================
    public class IngresoVueloViewModel
    {
        [Column("vuelo_id")]
        public int VueloId { get; set; }

        [Column("numero_vuelo")]
        public string NumeroVuelo { get; set; } = string.Empty;

        [Column("fecha_salida")]
        public DateTime FechaSalida { get; set; }

        [Column("fecha_llegada")]
        public DateTime FechaLlegada { get; set; }

        [Column("pasajeros_confirmados")]
        public int PasajerosConfirmados { get; set; }

        [Column("pasajeros_embarcados")]
        public int PasajerosEmbarcados { get; set; }

        [Column("precio_billete")]
        public decimal PrecioBillete { get; set; }

        [Column("ingresos_totales")]
        public decimal IngresosTotales { get; set; }

        [Column("ingresos_proyectados")]
        public decimal IngresosProyectados { get; set; }

        [Column("aerolinea_id")]
        public int AerolineaId { get; set; }

        [Column("aerolinea")]
        public string Aerolinea { get; set; } = string.Empty;

        [Column("codigo_aerolinea")]
        public string CodigoAerolinea { get; set; } = string.Empty;

        [Column("iata_origen")]
        public string IataOrigen { get; set; } = string.Empty;

        [Column("ciudad_origen")]
        public string CiudadOrigen { get; set; } = string.Empty;

        [Column("iata_destino")]
        public string IataDestino { get; set; } = string.Empty;

        [Column("ciudad_destino")]
        public string CiudadDestino { get; set; } = string.Empty;

        [Column("distancia_km")]
        public int DistanciaKm { get; set; }

        [Column("estado_vuelo")]
        public string EstadoVuelo { get; set; } = string.Empty;

        [NotMapped]
        public string RutaCorta => $"{IataOrigen} → {IataDestino}";

        [NotMapped]
        public decimal OcupacionPct =>
            PasajerosConfirmados > 0
                ? (decimal)PasajerosEmbarcados / PasajerosConfirmados * 100
                : 0;
    }

    // =====================================================
    // GASTOS COMBUSTIBLE (mapea v_gastos_combustible)
    // =====================================================
    public class GastoCombustibleViewModel
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("vuelo_id")]
        public int VueloId { get; set; }

        [Column("numero_vuelo")]
        public string NumeroVuelo { get; set; } = string.Empty;

        [Column("fecha_salida")]
        public DateTime FechaSalida { get; set; }

        [Column("aerolinea_id")]
        public int AerolineaId { get; set; }

        [Column("aerolinea")]
        public string Aerolinea { get; set; } = string.Empty;

        [Column("iata_origen")]
        public string IataOrigen { get; set; } = string.Empty;

        [Column("ciudad_origen")]
        public string CiudadOrigen { get; set; } = string.Empty;

        [Column("iata_destino")]
        public string IataDestino { get; set; } = string.Empty;

        [Column("ciudad_destino")]
        public string CiudadDestino { get; set; } = string.Empty;

        [Column("litros_cargados")]
        public decimal LitrosCargados { get; set; }

        [Column("litros_consumidos")]
        public decimal? LitrosConsumidos { get; set; }

        [Column("precio_por_litro")]
        public decimal PrecioPorLitro { get; set; }

        [Column("coste_carga")]
        public decimal CosteCarga { get; set; }

        [Column("coste_consumo")]
        public decimal CosteConsumo { get; set; }

        [Column("pct_consumido")]
        public decimal? PctConsumido { get; set; }

        [Column("fecha_registro")]
        public DateTime FechaRegistro { get; set; }

        [Column("observaciones")]
        public string? Observaciones { get; set; }

        [Column("estado_vuelo")]
        public string EstadoVuelo { get; set; } = string.Empty;

        [NotMapped]
        public string RutaCorta => $"{IataOrigen} → {IataDestino}";
    }

    // =====================================================
    // RESUMEN FINANCIERO (resultado de sp_resumen_financiero)
    // =====================================================
    public class ResumenFinancieroViewModel
    {
        [Column("total_vuelos")]
        public int TotalVuelos { get; set; }

        [Column("total_pasajeros")]
        public int TotalPasajeros { get; set; }

        [Column("ingresos_totales")]
        public decimal IngresosTotales { get; set; }

        [Column("gastos_combustible")]
        public decimal GastosCombustible { get; set; }

        [Column("beneficio_neto")]
        public decimal BeneficioNeto { get; set; }

        [NotMapped]
        public decimal MargenPct =>
            IngresosTotales > 0
                ? BeneficioNeto / IngresosTotales * 100
                : 0;
    }

    // =====================================================
    // TOP RUTAS RENTABLES (resultado de sp_top_rutas_rentables)
    // =====================================================
    public class TopRutaRentableViewModel
    {
        [Column("ruta")]
        public string Ruta { get; set; } = string.Empty;

        [Column("ciudades")]
        public string Ciudades { get; set; } = string.Empty;

        [Column("distancia_km")]
        public int DistanciaKm { get; set; }

        [Column("precio_billete")]
        public decimal PrecioBillete { get; set; }

        [Column("num_vuelos")]
        public int NumVuelos { get; set; }

        [Column("total_pasajeros")]
        public int TotalPasajeros { get; set; }

        [Column("ingresos_totales")]
        public decimal IngresosTotales { get; set; }
    }

    // =====================================================
    // RESUMEN TRIPULANTE 
    // =====================================================
    public class ResumenTripulanteViewModel
    {
        [Column("tripulante_id")] // Ajusta estos si los sacas de un SP distinto
        public int TripulanteId { get; set; }

        [Column("nombre_completo")]
        public string NombreCompleto { get; set; } = string.Empty;

        [Column("rol")]
        public string Rol { get; set; } = string.Empty;

        [Column("nombre_aerolinea")]
        public string NombreAerolinea { get; set; } = string.Empty;

        [Column("total_vuelos")]
        public int TotalVuelos { get; set; }

        [Column("total_horas_vuelo")]
        public int TotalHorasVuelo { get; set; }

        [Column("total_km")]
        public int TotalKm { get; set; }

        [Column("ultimo_vuelo")]
        public DateTime? UltimoVuelo { get; set; }

        [NotMapped]
        public string HorasFormateadas => $"{TotalHorasVuelo}h";
    }

    // =====================================================
    // FORMS Y FILTROS (Estos NO se mapean a SQL, son para la vista)
    // =====================================================
    public class RegistrarCombustibleViewModel
    {
        public int VueloId { get; set; }

        // Opcional: si se deja en 0 (o no se completa), el sistema tomará el valor desde el vuelo.
        public decimal LitrosCargados { get; set; }

        public decimal PrecioPorLitro { get; set; }
        public string? Observaciones { get; set; }
        public List<VueloSelectItem> VuelosDisponibles { get; set; } = new();
    }

    public class VueloSelectItem
    {
        public int Id { get; set; }
        public string Descripcion { get; set; } = string.Empty;
    }

    public class ActualizarConsumoViewModel
    {
        public int CombustibleId { get; set; }
        public decimal LitrosConsumidos { get; set; }
    }

    public class FiltroFinanzasViewModel
    {
        public int? AerolineaId { get; set; }
        public DateTime? FechaDesde { get; set; }
        public DateTime? FechaHasta { get; set; }
    }
}