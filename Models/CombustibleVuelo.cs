using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("combustible_vuelo")]
public class CombustibleVuelo
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("vuelo_id")]
    [Required]
    public int VueloId { get; set; }

    [Column("litros_cargados")]
    [Required]
    [Range(1, double.MaxValue, ErrorMessage = "Los litros cargados deben ser mayores que 0")]
    public decimal LitrosCargados { get; set; }

    [Column("litros_consumidos")]
    public decimal? LitrosConsumidos { get; set; }

    [Column("precio_por_litro")]
    [Required]
    [Range(0.0001, double.MaxValue, ErrorMessage = "El precio debe ser positivo")]
    public decimal PrecioPorLitro { get; set; }

    [Column("fecha_registro")]
    public DateTime FechaRegistro { get; set; } = DateTime.Now;

    [Column("observaciones")]
    [MaxLength(500)]
    public string? Observaciones { get; set; }

    // Navegación
    public Vuelo? Vuelo { get; set; }
    
    [NotMapped]
    public decimal CosteCarga => LitrosCargados * PrecioPorLitro;

    [NotMapped]
    public decimal CosteConsumo => (LitrosConsumidos ?? 0) * PrecioPorLitro;

    [NotMapped]
    public decimal? PorcentajeConsumido =>
        LitrosConsumidos.HasValue && LitrosCargados > 0
            ? (LitrosConsumidos.Value / LitrosCargados) * 100
            : null;
}