using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Auth;

[Table("USUARIO")]
public class Usuario
{
    [Key]
    [Column("ID")]
    public int  IdUsusario { get; set; }
    
    [Required(ErrorMessage = "El nombre es obligatorio")]
    [StringLength(50, ErrorMessage = "El nombre no puede exceder 50 caracteres")]
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Required(ErrorMessage = "Los apellidos son obligatorios")]
    [StringLength(50, ErrorMessage = "Los apellidos no pueden exceder 50 caracteres")]
    [Column("APELLIDOS")]
    public string Apellidos { get; set; }
    
    [Required(ErrorMessage = "El email es obligatorio")]
    [EmailAddress(ErrorMessage = "El formato del email no es válido")]
    [StringLength(100)]
    [Column("EMAIL")]
    public string  Email { get; set; }    
    
    [Required(ErrorMessage = "La contraseña es obligatoria")]
    [Column("PASSWORD")]
    public string  Password { get; set; }
    
    [Required(ErrorMessage = "Debe seleccionar una aerolínea")]
    [Column("AEROLINEA_ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("ACTIVO")]
    public bool  Activo { get; set; } 
    
}