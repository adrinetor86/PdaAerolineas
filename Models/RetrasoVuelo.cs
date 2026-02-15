using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("RETRASO_VUELO")]
public class RetrasoVuelo
{
    [Key]
    [Column("ID")]
    public int  IdRetraso { get; set; }
    
    [Column("VUELO_ID")]
    public int IdVuelo { get; set; }
    
    [Column("CODIGO_RETRASO_ID")]
    public int  IdCodRetraso { get; set; }
    
    [Column("MINUTOS")]
    public int  Minutos { get; set; }

}