using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("ROL")]
public class RolUsuario
{
    [Key]
    [Column("ID")]
    
    public int Id { get; set; }
    
    [Required(ErrorMessage = "Debe seleccionar una rol")]
    [Column("NOMBRE")]
    public string Nombre { get; set; }
}