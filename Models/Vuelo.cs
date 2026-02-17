using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("VUELO")]
public class Vuelo
{
    [Key]
    [Column("ID")]
    public int IdVuelo { get; set; }
    
    [Column("NUMERO_VUELO")]
    public string? NumeroVuelo { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int IdAerolinea { get; set; }
    
    [Column("RUTA_ID")]
    public int IdRuta { get; set; }
    
    [Column("AVION_ID")]
    public int IdAvion { get; set; }
    
    [Column("FECHA_SALIDA")]
    public DateTime? FechaSalida { get; set; }
    
    [Column("FECHA_LLEGADA")]
    public DateTime? FechaLlegada { get; set; }
    
    [Column("ESTADO_ID")]
    public int IdEstado { get; set; }
    
    [Column("PUERTA")]
    public string? Puerta { get; set; }
    
    [Column("CAPACIDAD_TOTAL")]
    public int CapacidadTotal { get; set; }
    
    [Column("PASAJEROS_CONFIRMADOS")]
    public int PasajerosConfirmados { get; set; }
    
    [Column("PASAJEROS_EMBARCADOS")]
    public int PasajerosEmbarcados { get; set; }
    
    // Navegación
    [ForeignKey("IdAerolinea")]
    public Aerolinea? Aerolinea { get; set; }
    
    [ForeignKey("IdRuta")]
    public Ruta? Ruta { get; set; }
    
    [ForeignKey("IdAvion")]
    public Avion? Avion { get; set; }
    
    [ForeignKey("IdEstado")]
    public EstadoVuelo? Estado { get; set; }
}