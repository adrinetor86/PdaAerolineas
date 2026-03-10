using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("AEROLINEA")]
public class Aerolinea
{
   [Key]
    [Column("ID")]
    public int IdAerolinea { get; set; }
    
    [Required(ErrorMessage = "El nombre es obligatorio")]
    [StringLength(100)]
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [StringLength(250)]
    [Column("LOGO")]
    public string? Logo { get; set; }  
    
    [Required(ErrorMessage = "El código IATA es obligatorio")]
    [StringLength(3, MinimumLength = 2)]
    [Column("CODIGO_IATA")]
    public string CodIata { get; set; }
    

    
}