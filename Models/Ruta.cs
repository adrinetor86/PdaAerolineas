using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("RUTA")]
public class Ruta
{
    [Key]
    [Column("ID")]
    public int  IdRuta { get; set; }
    
    [Column("AEROPUERTO_ORIGEN_ID")]
    public int IdAeropuertoOrigen { get; set; }
    
    [Column("AEROPUERTO_DESTINO_ID")]
    public int  IdAeropuertoDestino { get; set; }
    
    [Column("DISTANCIA_KM")]
    public int  Distancia { get; set; } 
}