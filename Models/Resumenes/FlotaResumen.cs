namespace PdaAerolineas.Models.Resumenes;

public class FlotaResumen
{
    public int NumeroFlota { get; set; }
    public int AvionesOperativos { get; set; }
    public int VuelosActivos { get; set; }
    public int AvionesMantenimiento { get; set; }
    public List<VistaFlota> Flota { get; set; }
}