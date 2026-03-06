using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Views;


[Table("V_DASHBOARD_OPERACIONAL")]
public class VistaDashboard
{
    [Key]
    [Column("AEROLINEA_ID")] 
    public int IdAerolinea { get; set; } 
    
    [Column("NOMBRE_AEROLINEA")] 
    public string Nombre { get; set; }
    
    [Column("VUELOS_PROGRAMADOS_HOY")] 
    public int VuelosProgramadosHoy { get; set; }   
    
    [Column("VUELOS_EN_CURSO")] 
    public int VuelosCurso { get; set; }  
    
    [Column("VUELOS_ATERRIZADOS_HOY")] 
    public int VuelosAterrizadosHoy { get; set; }   
    
    [Column("VUELOS_CANCELADOS_HOY")] 
    public int VuelosCanceladosHoy { get; set; }  
    
    [Column("VUELOS_RETRASADOS_HOY")] 
    public int VuelosRetrasadosHoy { get; set; }
    
    [Column("AVIONES_OPERATIVOS")] 
    public int AvionesOperativos { get; set; } 
    
    [Column("AVIONES_EN_MANTENIMIENTO")] 
    public int AvionesMantenimiento { get; set; }
    
    [Column("AVIONES_EN_VUELO")] 
    public int AvionesVueloHoy { get; set; }
    
    [Column("OCUPACION_PROMEDIO_HOY")] 
    public double OcupacionPromedio { get; set; }
}