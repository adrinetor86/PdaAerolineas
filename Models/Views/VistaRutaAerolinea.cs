using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;

[Table("V_RUTAS_AEROLINEAS")]
public class VistaRutaAerolinea
{
    [Key]
    [Column("ruta_id")]
    public int RutaId { get; set; }
    
    [Column("aerolinea_id")]
    public int AerolineaId { get; set; }
    
    [Column("aerolinea")]
    public string Aerolinea { get; set; }
    
    [Column("codigo_aerolinea")]
    public string CodigoAerolinea { get; set; }
    
    [Column("codigo_ruta")]
    public string CodigoRuta { get; set; }
    
    [Column("aeropuerto_origen_id")]
    public int AeropuertoOrigenId { get; set; }
    
    [Column("codigo_origen")]
    public string CodigoOrigen { get; set; }
    
    [Column("aeropuerto_origen")]
    public string AeropuertoOrigen { get; set; }
    
    [Column("ciudad_origen")]
    public string CiudadOrigen { get; set; }
    
    [Column("aeropuerto_destino_id")]
    public int AeropuertoDestinoId { get; set; }
    
    [Column("codigo_destino")]
    public string CodigoDestino { get; set; }
    
    [Column("aeropuerto_destino")]
    public string AeropuertoDestino { get; set; }
    
    [Column("ciudad_destino")]
    public string CiudadDestino { get; set; }
    
    [Column("distancia_km")]
    public int DistanciaKm { get; set; }
    
    [Column("activa")]
    public bool Activa { get; set; }
    
    [Column("precio_base")]
    public decimal? PrecioBase { get; set; }
    
    [Column("frecuencia_semanal")]
    public int? FrecuenciaSemanal { get; set; }
    
    [Column("fecha_inicio")]
    public DateTime? FechaInicio { get; set; }
    
    [Column("fecha_fin")]
    public DateTime? FechaFin { get; set; }
    
    [Column("total_vuelos")]
    public int TotalVuelos { get; set; }
    
    [Column("vuelos_completados")]
    public int VuelosCompletados { get; set; }
}

