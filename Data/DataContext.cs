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
    
    public DbSet<Usuario> Usuarios { get; set; }
    
}