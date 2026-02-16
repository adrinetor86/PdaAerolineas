using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("V_VUELOS")]
public class VistaVuelo
{
    [Key]
    [Column("VUELO_ID")]
    public int IdVuelo { get; set; }   
    
    [Column("NUMERO_VUELO")]
    public string NumVuelo { get; set; }
    
    [Column("AEROLINEA")]
    public string Aerolinea { get; set; }
    
    // [Column("AEROPUERTO_ORIGEN")]
    // public string AeropuertoOrigen { get; set; }
    
    [Column("CODIGO_ORIGEN")]
    public string CodOrigen { get; set; }
    
    [Column("CIUDAD_ORIGEN")]
    public string CiudadOrigen { get; set; }

    // [Column("AEROPUERTO_DESTINO")]
    // public string AeropuertoDestino { get; set; }
    
    [Column("CODIGO_DESTINO")]
    public string CodDestino { get; set; }
    
    [Column("CIUDAD_DESTINO")]
    public string CiudadDestino{ get; set; }   
    
    [Column("MATRICULA")]
    public string Matricula { get; set; }
    
    [Column("NOMBRE_MODELO")]
    public string Modelo{ get; set; }   
    
    [Column("FECHA_SALIDA")]
    public DateTime Salida{ get; set; }   
    
    [Column("FECHA_LLEGADA")]
    public DateTime Llegada{ get; set; }   
    
    [Column("ESTADO_VUELO")]
    public string Estado{ get; set; }   
    
    [Column("PUERTA")]
    public string? Puerta{ get; set; }   

    [Column("CAPACIDAD_TOTAL")]
    public int Capacidad{ get; set; }   
    
    [Column("PASAJEROS_CONFIRMADOS")]
    public int PasajerosConfirmados{ get; set; }  
    
    [Column("PASAJEROS_EMBARCADOS")]
    public int PasajerosEmbarcados{ get; set; }   
    
    [Column("PORCENTAJE_OCUPACION")]
    public decimal Ocupacion{ get; set; }  
    
    [Column("DISTANCIA_KM")]
    public int Distancia{ get; set; }   
}