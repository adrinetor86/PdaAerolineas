using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("MANTENIMIENTO_TIPO")]
public class MantenimientoTipo
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }

    [Column("NOMBRE")]
    public string Nombre { get; set; }

    [Column("INTERVALO_HORAS")]
    public int IntervaloHoras { get; set; }

    [Column("INTERVALO_CICLOS")]
    public int IntervaloCiclos { get; set; }

    [Column("INTERVALO_DIAS")] 
    public int IntervaloDias { get; set; }
    
}