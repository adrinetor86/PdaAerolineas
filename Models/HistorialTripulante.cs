using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("historial_tripulante")]
public class HistorialTripulante
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
 
    [Column("tripulante_id")]
    [Required]
    public int TripulanteId { get; set; }
 
    [Column("vuelo_id")]
    [Required]
    public int VueloId { get; set; }
 
    [Column("fecha_registro")]
    public DateTime FechaRegistro { get; set; } = DateTime.Now;
 
    [Column("rol")]
    [Required]
    [MaxLength(50)]
    public string Rol { get; set; }
 
    [Column("horas_voladas")]
    public decimal? HorasVoladas { get; set; }
 
    [Column("observaciones")]
    [MaxLength(500)]
    public string Observaciones { get; set; }
 
    public Tripulante Tripulante { get; set; }
    public Vuelo Vuelo { get; set; }
}