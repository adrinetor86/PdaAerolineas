
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.InteropServices.JavaScript;

namespace PdaAerolineas.Models;

[Table("MANTENIMIENTO")]
public class Mantenimiento
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }
    
    [Column("AVION_ID")]
    public int IdAvion { get; set; }
     
    [Column("MANTENIMIENTO_TIPO_ID")]
    public int IdMantenimientoTipo { get; set; }
    
    [Column("ESTADO")]
    public string Estado { get; set; }
        
    [Column("FECHA_PROGRAMADA")]
    public DateTime FechaProgramada { get; set; }
    
    [Column("FECHA_INICIO")]
    public DateTime? FechaInicio { get; set; }
    
    [Column("FECHA_FIN")]
    public DateTime? FechaFin { get; set; }
    
    [Column("DESCRIPCION")]
    public string? Descripcion { get; set; }
    
    
}