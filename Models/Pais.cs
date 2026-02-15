using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("PAIS")]
public class Pais
{
    [Key]
    [Column("ID")]
    public int  IdPais { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("CODIGO_ISO")]
    public string  Cod_Iso { get; set; }

}