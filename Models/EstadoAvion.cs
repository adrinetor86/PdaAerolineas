using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("ESTADO_AVION")]
public class EstadoAvion
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }   
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
}