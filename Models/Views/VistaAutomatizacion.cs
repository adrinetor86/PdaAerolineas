using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PdaAerolineas.Models.Views;

[Keyless]
public class VistaFinanzasResumen
{
    [Column("aerolinea_id")]
    public int AerolineaId { get; set; }
 
    [Column("aerolinea")]
    public string Aerolinea { get; set; }
 
    [Column("total_vuelos")]
    public int TotalVuelos { get; set; }
 
    [Column("total_ingresos")]
    public decimal TotalIngresos { get; set; }
 
    [Column("total_costes")]
    public decimal TotalCostes { get; set; }
 
    [Column("beneficio_total")]
    public decimal BeneficioTotal { get; set; }
 
    [Column("beneficio_promedio")]
    public decimal BeneficioPromedio { get; set; }
}
 
[Keyless]
public class VistaHistorialTripulante
{
    [Column("id")]
    public int Id { get; set; }
 
    [Column("tripulante_id")]
    public int TripulanteId { get; set; }
 
    [Column("nombre_completo")]
    public string NombreCompleto { get; set; }
    
 
    [Column("vuelo_id")]
    public int VueloId { get; set; }
 
    [Column("numero_vuelo")]
    public string NumeroVuelo { get; set; }
 
    [Column("rol")]
    public string Rol { get; set; }
 
    [Column("horas_voladas")]
    public decimal? HorasVoladas { get; set; }
 
    [Column("fecha_salida")]
    public DateTime FechaSalida { get; set; }
 
    [Column("ruta")]
    public string Ruta { get; set; }
 
    [Column("aerolinea")]
    public string Aerolinea { get; set; }
 
    [Column("fecha_registro")]
    public DateTime FechaRegistro { get; set; }
 
    [Column("observaciones")]
    public string Observaciones { get; set; }
}