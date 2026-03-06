using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;

[Table("V_ADMINISTRACION_USUARIOS")]
public class VistaAdministracionUsuarios
{
    [Key]
    [Column("ID")]
    public int Id { get; set; } 
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }   
    
    [Column("APELLIDOS")]
    public string Apellidos { get; set; }
    
    [Column("EMAIL")]
    public string Email { get; set; } 
    
    [Column("ROL")]
    public string Rol { get; set; }
    
    [Column("ACTIVO")]
    public bool Activo { get; set; }
}