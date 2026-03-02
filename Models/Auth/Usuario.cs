using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Auth;

[Table("USUARIO")]
public class Usuario
{
    [Key]
    [Column("ID")]
    public int  IdUsusario { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("APELLIDOS")]
    public string Apellidos { get; set; }
    
    [Column("EMAIL")]
    public string  Email { get; set; }    
    
    [Column("PASSWORD")]
    public string  Password { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("ACTIVO")]
    public bool  Activo { get; set; } 
    
}