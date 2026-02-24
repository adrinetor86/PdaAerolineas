using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;
[Table("TRIPULANTE")]
public class Tripulante
{
    [Key]
    [Column("ID")]
    public int  IdTripulante { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("APELLIDO")]
    public string  Apellido { get; set; }
    
    [Column("ROL")]
    public string  Rol { get; set; }
    
    [Column("ACTIVO")]
    public bool  Activo { get; set; } 
}