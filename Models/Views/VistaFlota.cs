using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("V_FLOTA_ESTADO")]
public class VistaFlota
{
    [Key]
    [Column("AVION_ID")]
    public int AvionId { get; set; }
    
    [Column("MATRICULA")]
    public string Matricula { get; set; }
    
    [Column("AEROLINEA")]
    public string Aerolinea { get; set; }
    
    [Column("FABRICANTE")]
    public string Fabricante { get; set; }
    
    [Column("NOMBRE_MODELO")]
    public string NombreModelo { get; set; }
    
    [Column("CAPACIDAD_TOTAL")]
    public int CapacidadTotal { get; set; }
    
    [Column("IDESTADO")]
    public int IdEstadoAvion { get; set; }
    
    [Column("ESTADO")]
    public string Estado { get; set; }
    
    [Column("UBICACION")]
    public string Ubicacion { get; set; }
    
    [Column("CODIGO_AEROPUERTO")]
    public string CodigoAeropuerto { get; set; }
    
    [Column("HORAS_VUELO_TOTALES")]
    public int HorasVueloTotales { get; set; }
    
    [Column("CICLOS_TOTALES")]
    public int CiclosTotales { get; set; }
    
    [Column("PROXIMO_MANTENIMIENTO")]
    public DateTime? ProximoMantenimiento { get; set; }
    
    [Column("VUELO_ACTUAL")]
    public string? VueloActual { get; set; }
}