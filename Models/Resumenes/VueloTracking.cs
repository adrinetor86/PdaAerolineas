using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Resumenes;


[Table("V_VUELOS_TRACKING")]
public class VueloTracking
{
    [Key]
    [Column("vuelo_id")]
    public int VueloId { get; set; }

    [Column("numero_vuelo")]
    public string NumeroVuelo { get; set; }

    [Column("estado_id")]
    public int EstadoId { get; set; }

    [Column("aerolinea")]
    public string Aerolinea { get; set; }

    [Column("matricula")]
    public string Matricula { get; set; }

    [Column("codigo_origen")]
    public string CodigoOrigen { get; set; }

    [Column("ciudad_origen")]
    public string CiudadOrigen { get; set; }

    [Column("lat_origen")]
    public decimal? LatOrigen { get; set; }

    [Column("lng_origen")]
    public decimal? LngOrigen { get; set; }

    [Column("codigo_destino")]
    public string CodigoDestino { get; set; }

    [Column("ciudad_destino")]
    public string CiudadDestino { get; set; }

    [Column("lat_destino")]
    public decimal? LatDestino { get; set; }

    [Column("lng_destino")]
    public decimal? LngDestino { get; set; }

    [Column("fecha_salida")]
    public DateTime FechaSalida { get; set; }

    [Column("fecha_llegada")]
    public DateTime FechaLlegada { get; set; }

    [Column("progreso")]
    public double? Progreso { get; set; }

    [Column("latitud_actual")]
    public double? LatitudActual { get; set; }

    [Column("longitud_actual")]
    public double? LongitudActual { get; set; }

    [Column("altitud_pies")]
    public double? AltitudPies { get; set; }
}
