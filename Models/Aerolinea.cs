using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("AEROLINEA")]
public class Aerolinea
{
    [Key]
    [Column("ID")]
    public int  IdAerolinea { get; set; }
    
    [Column("NOMBRE")]
    public string Nombre { get; set; }
    
    [Column("LOGO")]
    public string  Logo { get; set; }
    
    [Column("CODIGO_IATA")]
    public string  Cod_Iata { get; set; }
    
}