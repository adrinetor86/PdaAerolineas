using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;

[Table("V_LOGED_USER")]
public class VistaLogedUser
{
    [Key]
    [Column("IDUSUARIO")]
    public int IdUsuario { get; set; }   
    
    [Column("IDAEROLINEA")]
    public int IdAerolinea { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("ROL_ID")]
    public int IdRol { get; set; }
}