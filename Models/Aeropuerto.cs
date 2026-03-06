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
 
    public string Nombre { get; set; }
    
    [Column("CODIGO_IATA")]
    public string  Cod_Iata { get; set; }
    
    [Column("CODIGO_ICAO")]
    public string Cod_Icao { get; set; }
    
    [Column("CIUDAD")]
    public string  Ciudad { get; set; } 
    
    [Column("PAIS_ID")]
    public int  IdPais { get; set; }   
    
    [Column("LATITUD")]
    public decimal  Latitud { get; set; }  
    
    [Column("LONGITUD")]
    public decimal  Longitud { get; set; }
    
}