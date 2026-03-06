using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;

[Table("V_HISTORIAL_VUELOS_AVION")]
public class VistaHistorialVuelo
{
        [Key] 
        [Column("VUELO_ID")]
        public int VueloId { get; set; }
        
        [Column("AVION_ID")]
        public int AvionId { get; set; }
        
        [Column("MATRICULA")]
        public string Matricula { get; set; }
        
        [Column("FABRICANTE")]
        public string Fabricante { get; set; }
        
        [Column("NOMBRE_MODELO")]
        public string NombreModelo { get; set; }
        
        [Column("AEROLINEA")]
        public string Aerolinea { get; set; }
        
        [Column("CODIGO_AEROLINEA")]
        public string CodigoAerolinea { get; set; }
        
        [Column("NUMERO_VUELO")]
        public string NumeroVuelo { get; set; }
        
        [Column("FECHA_SALIDA")]
        public DateTime FechaSalida { get; set; }
        
        [Column("FECHA_LLEGADA")]
        public DateTime FechaLlegada { get; set; }
        
        [Column("ESTADO_VUELO")]
        public string EstadoVuelo { get; set; }
        
        [Column("ESTADO_ID")]
        public int EstadoId { get; set; }
        
        
        [Column("CODIGO_ORIGEN")]
        public string CodigoOrigen { get; set; }
        
        [Column("AEROPUERTO_ORIGEN")]
        public string AeropuertoOrigen { get; set; }
        
        [Column("CIUDAD_ORIGEN")]
        public string CiudadOrigen { get; set; }
        
        [Column("CODIGO_DESTINO")]
        public string CodigoDestino { get; set; }
        
        [Column("AEROPUERTO_DESTINO")]
        public string AeropuertoDestino { get; set; }
        
        [Column("CIUDAD_DESTINO")]
        public string CiudadDestino { get; set; }
        
        [Column("DISTANCIA_KM")]
        public int DistanciaKm { get; set; }

        [Column("CAPACIDAD_TOTAL")]
        public int CapacidadTotal { get; set; }
        
        [Column("PASAJEROS_CONFIRMADOS")]
        public int PasajerosConfirmados { get; set; }
        
        [Column("PASAJEROS_EMBARCADOS")]
        public int PasajerosEmbarcados { get; set; }
        
        [Column("PORCENTAJE_OCUPACION")]
        public decimal? PorcentajeOcupacion { get; set; }
        

        [Column("DURACION_MINUTOS")]
        public int DuracionMinutos { get; set; }
        
        [Column("MINUTOS_RETRASO")]
        public int MinutosRetraso { get; set; }

        [Column("TELEMETRIA")]
        public string? Telemetria { get; set; }

    
        [Column("PUERTA")]
        public string? Puerta { get; set; }
        
        [Column("RUTA_CODIGO")]
        public string RutaCodigo { get; set; }
        

        [NotMapped]
        public string DuracionFormateada => 
            $"{DuracionMinutos / 60}h {DuracionMinutos % 60}min";
        
        [NotMapped]
        public bool TieneRetraso => MinutosRetraso > 0;
        
        [NotMapped]
        public bool TieneTelemetria => !string.IsNullOrEmpty(Telemetria);
        
        [NotMapped]
        public string ModeloCompleto => $"{Fabricante} {NombreModelo}";
}