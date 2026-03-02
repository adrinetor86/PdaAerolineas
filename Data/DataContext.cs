using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Data;

public class DataContext:DbContext
{
    public DataContext(DbContextOptions<DataContext> options):base(options){}
    
    
    public DbSet<VistaFlota> Flotas { get; set; }
    public DbSet<VistaVuelo> VistaVuelos { get; set; }
    public DbSet<Vuelo> Vuelos { get; set; }
    public DbSet<VueloTracking> VuelosTracking { get; set; }
    public DbSet<EstadoVuelo> EstadoVuelos { get; set; }
    public DbSet<Aerolinea> Aerolineas { get; set; }
    
    public DbSet<Avion> Aviones { get; set; }
    public DbSet<VistaAvion> VistaAviones { get; set; }
    public DbSet<Ruta> Rutas { get; set; }
    public DbSet<VistaRuta> VistaRutas { get; set; }
    
    public DbSet<Tripulante> Tripulantes { get; set; }

    public DbSet<VistaTripulante> VistaTripulantes { get; set; }
    public DbSet<AsignacionTripulacion> AsignacionTripulacion { get; set; }
    
    public DbSet<Mantenimiento> Mantenimientos { get; set; }
    public DbSet<MantenimientoTipo> MantenimientosTipos { get; set; }
    public DbSet<VistaMantenimientos> VistaMantenimientos { get; set; }
    
    public DbSet<Usuario> Usuarios { get; set; }
    public DbSet<UsersSecurity> UsersSecurity { get; set; }
    public DbSet<VistaUsuarios> VistaUsuarios { get; set; }
    
    public DbSet<VistaLogedUser> VistaLogedUser { get; set; }
    public DbSet<RetrasoVuelo> RetrasosVuelos { get; set; }
    
    public DbSet<VistaRetraso> VistaRetrasos { get; set; }
    public DbSet<CodigoRetrasoIata> CodigosRetrasos{ get; set; }
    
}