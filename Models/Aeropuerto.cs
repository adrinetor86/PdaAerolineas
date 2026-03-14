using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PdaAerolineas.Models;

[Table("aeropuerto")]
public class Aeropuerto
{
    [Key]
    [Column("id")]
    public int IdAeropuerto { get; set; }

    [Column("nombre")]
    [Required(ErrorMessage = "El nombre es obligatorio.")]
    [StringLength(150, ErrorMessage = "Máximo 150 caracteres.")]
    public string Nombre { get; set; }

    [Column("codigo_iata")]
    [Required(ErrorMessage = "El código IATA es obligatorio.")]
    [StringLength(3, MinimumLength = 3, ErrorMessage = "El código IATA debe tener exactamente 3 caracteres.")]
    public string Cod_Iata { get; set; }

    [Column("codigo_icao")]
    [Required(ErrorMessage = "El código ICAO es obligatorio.")]
    [StringLength(4, MinimumLength = 4, ErrorMessage = "El código ICAO debe tener exactamente 4 caracteres.")]
    public string Cod_Icao { get; set; }

    [Column("ciudad")]
    [Required(ErrorMessage = "La ciudad es obligatoria.")]
    [StringLength(100, ErrorMessage = "Máximo 100 caracteres.")]
    public string Ciudad { get; set; }

    [Column("pais_id")]
    [Required(ErrorMessage = "El país es obligatorio.")]
    [Range(1, int.MaxValue, ErrorMessage = "Selecciona un país válido.")]
    public int IdPais { get; set; }

    [Column("latitud")]
    [Required(ErrorMessage = "La latitud es obligatoria.")]
    [Range(-90.0, 90.0, ErrorMessage = "La latitud debe estar entre -90 y 90.")]
    public decimal Latitud { get; set; }

    [Column("longitud")]
    [Required(ErrorMessage = "La longitud es obligatoria.")]
    [Range(-180.0, 180.0, ErrorMessage = "La longitud debe estar entre -180 y 180.")]
    public decimal Longitud { get; set; }
}