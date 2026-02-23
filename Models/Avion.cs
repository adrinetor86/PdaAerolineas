using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("AVION")]
public class Avion
{
    [Key]
    [Column("ID")]
    public int IdAvion { get; set; }
    
    [Column("MATRICULA")]
    [Required]
    public string Matricula { get; set; }
    
    [Column("MODELO_ID")]
    public int IdModelo { get; set; }
    
    [Column("AEROLINEA_ID")]
    public int IdAerolinea { get; set; }
    
    [Column("ESTADO_ID")]
    public int IdEstado { get; set; } 
    
    [Column("AEROPUERTO_ACTUAL_ID")]
    public int IdAeropuertoActual { get; set; }
    
    [Column("HORAS_VUELO_TOTALES")]
    public int HorasTotales { get; set; }
    
    [Column("CICLOS_TOTALES")]
    public int CiclosTotales { get; set; }

}