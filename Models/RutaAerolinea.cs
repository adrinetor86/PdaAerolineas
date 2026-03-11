using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("RUTA_AEROLINEA")]
public class RutaAerolinea
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }
        
    [Required]
    [Column("RUTA_ID")]
    public int RutaId { get; set; }
        
    [Required]
    [Column("AEROLINEA_ID")]
    public int AerolineaId { get; set; }
        
    [Column("ACTIVA")]
    public bool Activa { get; set; }
        
    [Column("PRECIO_BASE")]
    public decimal? PrecioBase { get; set; }
        
    [Column("FRECUENCIA_SEMANAL")]
    public int? FrecuenciaSemanal { get; set; }
        
    [Column("FECHA_INICIO")]
    public DateTime FechaInicio { get; set; }
        
    [Column("FECHA_FIN")]
    public DateTime? FechaFin { get; set; }
        
    [Column("OBSERVACIONES")]
    [StringLength(500)]
    public string? Observaciones { get; set; }
}
