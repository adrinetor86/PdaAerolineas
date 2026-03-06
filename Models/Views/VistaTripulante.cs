using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("V_TRIPULACION_ROLES")]
public class VistaTripulante
{
    [Key]
    [Column("TRIPULANTE_ID")]
    public int  IdTripulante { get; set; }  
    
    [Column("AEROLINEA_ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("NOMBRE_COMPLETO")]
    public string Nombre { get; set; }
    
    [Column("ROL")]
    public string  Rol { get; set; }
    
}