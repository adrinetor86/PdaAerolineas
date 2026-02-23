using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("V_TRIPULACION_ROLES")]
public class VistaTripulante
{
    [Key]
    [Column("TRIPULANTE_ID")]
    public int  IdTripulante { get; set; }
    
    [Column("NOMBRE_COMPLETO")]
    public string Nombre { get; set; }
    
    [Column("ROL")]
    public string  Rol { get; set; }
    
    [Column("LICENCIA")]
    public string  Licencia { get; set; }
    
    
}

// t.id            AS tripulante_id,
// t.nombre +t.apellido,
// t.apellido,
// t.licencia,
// rt.id           AS rol_id,
// rt.nombre       AS rol,
// -- Si ya está asignado a ESTE vuelo lo marcamos
// CASE WHEN at2.tripulante_id IS NOT NULL
// THEN 1 ELSE 0
// END             AS ya_asignado
// FROM tripulante t
// INNER JOIN asignacion_tripulacion at2
// ON at2.tripulante_id = t.id
// AND at2.vuelo_id = @vuelo_id  -- para saber su rol en este vuelo
// INNER JOIN rol_tripulacion rt
// ON at2.rol_tripulacion_id = rt.id
//
// -- UNION con los que no están asignados aún a este vuelo
// UNION
//
// SELECT
// t.id,
// t.nombre,
// t.apellido,
// t.licencia,
// NULL AS rol_id,
// NULL AS rol,
// 0    AS ya_asignado