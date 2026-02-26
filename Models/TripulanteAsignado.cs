namespace PdaAerolineas.Models;

public class TripulanteAsignado
{
    public Tripulante Comandante { get; set; }
    public Tripulante Oficial { get; set; }
    public List<Tripulante> Tcps { get; set; }
    
}