using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;

[Table("V_LOGGED_USER")]
public class VistaLoggedUser
{
    [Key]
    [Column("IDUSUARIO")]
    public int IdUsuario { get; set; }   
    
    [Column("EMAIL")]
    public string Email { get; set; }   
    
    [Column("IDAEROLINEA")]
    public int IdAerolinea { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("ROL_ID")]
    public int IdRol { get; set; }  
    
    [Column("ROL")]
    public string Rol { get; set; }
}