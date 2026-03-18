using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("V_AVIONES")]
public class VistaAvion
{
    [Key]
    [Column("ID")]
    public int Id { get; set; } 
    
    [Column("IDAEROLINEA")]
    public int IdAerolinea { get; set; }
    
    [Column("AEROLINEA")]
    public string Aerolinea { get; set; }
    
    [Column("MATRICULA")]
    public string Matricula { get; set; }  
    
    [Column("MODELO")]
    public string Modelo { get; set; } 
    
    [Column("ESTADO")]
    public string Estado { get; set; } 
    
    [Column("AEROPUERTO_ACTUAL")]
    public string AeropuertoActual { get; set; }   
    
    [Column("HORAS_VUELO_TOTALES")]
    public int HorasVuelo { get; set; }   
    
    [Column("CICLOS_TOTALES")]
    public int CiclosTotales { get; set; }
    
    
}