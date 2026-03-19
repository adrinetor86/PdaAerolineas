using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("finanzas_vuelo")]
public class FinanzasVuelo
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
 
    [Column("vuelo_id")]
    [Required]
    public int VueloId { get; set; }
 
    [Column("ingreso_pasajes")]
    public decimal IngresoPasajes { get; set; }
 
    [Column("coste_combustible")]
    public decimal CosteCombustible { get; set; }
 
    [Column("coste_tripulacion")]
    public decimal CosteTripulacion { get; set; }
 
    [Column("coste_mantenimiento")]
    public decimal CosteMantenimiento { get; set; }
 
    [Column("otros_costes")]
    public decimal OtrosCostes { get; set; }
 
    [Column("beneficio_neto")]
    public decimal BeneficioNeto { get; set; }
 
    [Column("fecha_calculo")]
    public DateTime FechaCalculo { get; set; } = DateTime.Now;
 
    public Vuelo Vuelo { get; set; }
 
    [NotMapped]
    public decimal CosteTotal => CosteCombustible + CosteTripulacion + CosteMantenimiento + OtrosCostes;
 
    [NotMapped]
    public decimal MargenPorcentaje => IngresoPasajes > 0 ? (BeneficioNeto / IngresoPasajes) * 100 : 0;
}