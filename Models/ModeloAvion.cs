using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("MODELO_AVION")]
public class ModeloAvion
{
    [Key]
    [Column("ID")]
    public int  IdModelo { get; set; }
    
    [Column("FABRICANTE")]
    public string Fabricante { get; set; }
    
    [Column("NOMBRE_MODELO")]
    public string  Nombre { get; set; }
    
    [Column("CAPACIDAD_TOTAL")]
    public int  Capacidad { get; set; }
    
    [Column("ALCANCE_KM")]
    public int  Alcance { get; set; } 
    
}