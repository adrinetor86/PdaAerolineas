using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("USUARIO")]
public class Usuario
{
    [Key]
    [Column("ID")]
    public int  IdUsusario { get; set; }
    
    [Column("NOMBRE_USUARIO")]
    public string Nombre { get; set; }
    
    [Column("PASSWORD_HASH")]
    public string  Password { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("ACTIVO")]
    public bool  Activo { get; set; } 
    
}