using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace PdaAerolineas.Models;
[Table("TRIPULANTE")]
public class Tripulante
{
    [Key]
    [Column("ID")]
    public int  IdTripulante { get; set; } 
    
    [Column("ID_AEROLINEA")]
    public int  IdAerolinea { get; set; }
    
    
    [Column("NOMBRE")]
    [Required(ErrorMessage = "Debe introducir un nombre valido")]
    public string Nombre { get; set; }
    
    [Column("APELLIDO")]
    [Required(ErrorMessage = "Debe introducir un apellido valido")]
    public string  Apellido { get; set; }
    
    [Column("ROL")]
    [Required(ErrorMessage = "Debe introducir un rol valido")]
    public string  Rol { get; set; }
    
    [Column("ACTIVO")]
    public bool  Activo { get; set; } 
}