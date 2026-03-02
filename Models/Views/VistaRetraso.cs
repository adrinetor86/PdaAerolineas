using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;


[Table("V_RETRASOS_DETALLADOS")]
public class VistaRetraso
{
    [Key]
    [Column("RETRASO_ID")]
    public int IdRetraso { get; set; } 
    
    [Column("ID_VUELO")]
    public int IdVuelo { get; set; }
    
    [Column("NUMERO_VUELO")]
    public string NumVuelo { get; set; }
    
    [Column("FECHA_SALIDA")]
    public DateTime Salida { get; set; }  
    
    [Column("ORIGEN")]
    public string Origen{ get; set; }  
    
    [Column("DESTINO")]
    public string Destino { get; set; }  
    
    [Column("CODIGO_RETRASO")]
    public string CodRetraso { get; set; }    
    
    [Column("MOTIVO_RETRASO")]
    public string MotRetraso { get; set; }   
    
    [Column("MINUTOS_RETRASO")]
    public int MinRetraso { get; set; }    
    
    [Column("CATEGORIA_RETRASO")]
    public string CategoriaRetraso { get; set; }     
    

}