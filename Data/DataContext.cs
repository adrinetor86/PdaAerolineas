using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Resumenes;

namespace PdaAerolineas.Data;

public class DataContext:DbContext
{
    public DataContext(DbContextOptions<DataContext> options):base(options){}
    
    
    public DbSet<VistaFlota> Flotas { get; set; }
    public DbSet<VistaVuelo> VistaVuelos { get; set; }
    public DbSet<Vuelo> Vuelos { get; set; }
    public DbSet<EstadoVuelo> EstadoVuelos { get; set; }
    
    public DbSet<Avion> Aviones { get; set; }
    public DbSet<Ruta> Rutas { get; set; }
    public DbSet<VistaRuta> VistaRutas { get; set; }
    
    public DbSet<Tripulante> Tripulantes { get; set; }

    public DbSet<VistaTripulante> VistaTripulantes { get; set; }
    
    public DbSet<Usuario> Usuarios { get; set; }
    
}