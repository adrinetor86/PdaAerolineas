using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("CODIGO_RETRASO_IATA")]
public class CodigoRetrasoIata
{
    [Key]
    [Column("ID")]
    public int Id { get; set; }  
    
    [Column("CODIGO")]
    public string Codigo { get; set; }
        
    [Column("DESCRIPCION")]
    public string Descripcion { get; set; }
}