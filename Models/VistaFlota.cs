using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("V_FLOTA_ESTADO")]
public class VistaFlota
{
    [Key]
    [Column("avion_id")]
    public int AvionId { get; set; }
    
    [Column("matricula")]
    public string Matricula { get; set; }
    
    [Column("aerolinea")]
    public string Aerolinea { get; set; }
    
    [Column("fabricante")]
    public string Fabricante { get; set; }
    
    [Column("nombre_modelo")]
    public string NombreModelo { get; set; }
    
    [Column("capacidad_total")]
    public int CapacidadTotal { get; set; }
    
    [Column("estado")]
    public string Estado { get; set; }
    
    [Column("ubicacion")]
    public string Ubicacion { get; set; }
    
    [Column("codigo_aeropuerto")]
    public string CodigoAeropuerto { get; set; }
    
    [Column("horas_vuelo_totales")]
    public int HorasVueloTotales { get; set; }
    
    [Column("ciclos_totales")]
    public int CiclosTotales { get; set; }
    
    //PROBAR CAMBIAR DATO
    [Column("proximo_mantenimiento")]
    public string ProximoMantenimiento { get; set; } 
    
    [Column("vuelo_actual")]
    public string VueloActual { get; set; }
}
