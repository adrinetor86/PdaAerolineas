namespace PdaAerolineas.Models.Resumenes;

public class PosicionVuelo
{
    public string Timestamp { get; set; }
    public double Lat { get; set; }
    public double Lng { get; set; }
    public double Altitud { get; set; }
    public double Progreso { get; set; }
}