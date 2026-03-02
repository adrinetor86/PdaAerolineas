using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models.Auth;


[Table("USERS_SECURITY")]
public class UsersSecurity
{
    [Key]
    [Column("ID_USUARIO")]
    public int  IdUsusario { get; set; }
    
    [Column("SALT")]
    public string Salt { get; set; }
    
    [Column("Pass")]
    public byte[] Pass { get; set; }
    
}