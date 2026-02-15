using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("AEROPUERTO")]
public class Aeropuerto
{
    [Key]
    [Column("ID")]
    public int  IdAeropuerto { get; set; }
    
    [Column("NOMBRE")]
    [Required]
    public string Nombre { get; set; }
    
    [Column("CODIGO_IATA")]
    [Required]
    public string  Cod_Iata { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("CIUDAD")]
    [Required]
    public string  Ciudad { get; set; } 
    
    [Column("PAIS_ID")]
    public int  IdPais { get; set; }
    
}