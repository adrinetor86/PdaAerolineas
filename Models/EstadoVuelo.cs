using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("ESTADO_VUELO")]
public class EstadoVuelo
{
    [Key]
    [Column("ID")]
    public int IdEstado { get; set; }
    
    [Column("NOMBRE")]
    public string NombreEstado { get; set; }
    
}