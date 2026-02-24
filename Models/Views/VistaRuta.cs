using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("V_RUTAS_AVION")]
public class VistaRuta
{
        [Key]
        [Column("RUTA_ID")]
        public int Id { get; set; }
        
        [Column("DISTANCIA_KM")]
        public int Distancia { get; set; }
        [Column("ID_ORIGEN")]
        public int IdOrigen { get; set; }      
        [Column("CODIGO_ORIGEN")]
        public string CodOrigen { get; set; }
        [Column("NOMBRE_ORIGEN")]
        public string NombreOrigen { get; set; }
        [Column("CIUDAD_ORIGEN")]
        public string CiudadOrigen { get; set; } 
        [Column("LATITUD_ORIGEN")]
        public decimal LatitudOrigen {get; set; }
        [Column("LONGITUD_ORIGEN")]
        public decimal LongitudOrigen {get; set; }
        [Column("ID_DESTINO")]
        public int IdDestino { get; set; }    
        [Column("CODIGO_DESTINO")]
        public string CodDestino { get; set; }
        [Column("NOMBRE_DESTINO")]
        public string NombreDestino { get; set; }
        [Column("CIUDAD_DESTINO")]
        public string CiudadDestino {get; set; } 
        [Column("LATITUD_DESTINO")]
        public decimal LatitudDestino {get; set; }
        [Column("LONGITUD_DESTINO")]
        public decimal LongitudDestino {get; set; }
        
        [Column("DURACION_MINUTOS")]
        public int Duracion { get; set; }
        [Column("DURACION_FORMATEADA")]
        public string DuracionFomateada { get; set; }
    
}