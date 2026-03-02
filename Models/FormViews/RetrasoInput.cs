using System.ComponentModel.DataAnnotations;

namespace PdaAerolineas.Models.FormViews;

public class RetrasoInput
{
    [Range(1, int.MaxValue, ErrorMessage = "Minutos debe ser mayor que 0")]
    public int Minutos { get; set; }

    // Opcional: si luego quieres soportar catálogo de códigos
    public int? IdCodRetraso { get; set; }
}

