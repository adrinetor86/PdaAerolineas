using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("ASIGNACION_TRIPULACION")]
public class AsignacionTripulacion
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }  
    
    [Column("TRIPULANTE_ID")]
    public int IdTripulante { get; set; }
        
    [Column("VUELO_ID")]
    public int IdVuelo { get; set; }

    
}