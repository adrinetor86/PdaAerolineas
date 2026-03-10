namespace PdaAerolineas.Models.FormViews;

public class RutasAvion
{
    public int Id { get; set; }
    public int Distancia { get; set; }
    public string CodOrigen { get; set; }
    public string NombreOrigen { get; set; }
    public string CiudadOrigen { get; set; } 
    public string CodDestino { get; set; }
    public string NombreDestino { get; set; }
    public string CiudadDestino {get; set; }
    public decimal Duracion { get; set; }
    public string DuracionFomateada { get; set; }
}