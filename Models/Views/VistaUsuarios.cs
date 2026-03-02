using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;



[Table("V_DATOS_USUARIO")]
public class VistaUsuarios
{

    [Key]
    [Column("ID")]
    public int IdUsuario { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int IdAerolinea { get; set; }
    
    [Column("EMAIL")]
    public string Email { get; set; }   
    
    [Column("PASSWORD")]
    public string Password { get; set; }
    
    [Column("SALT")]
    public string Salt { get; set; }
    
    [Column("PASS")]
    public byte[] Pass { get; set; }
    
}
