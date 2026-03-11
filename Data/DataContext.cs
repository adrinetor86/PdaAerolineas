using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Dashboard;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Data;

public class DataContext:DbContext
{
    public DataContext(DbContextOptions<DataContext> options):base(options){}
    

    public DbSet<Aeropuerto> Aeropuertos { get; set; }
    public DbSet<VistaFlota> Flotas { get; set; }
    public DbSet<VistaVuelo> VistaVuelos { get; set; }
    public DbSet<Vuelo> Vuelos { get; set; }
    public DbSet<VueloTracking> VuelosTracking { get; set; }
    public DbSet<VistaHistorialVuelo> VistaHistorialVuelos { get; set; }
    public DbSet<EstadoVuelo> EstadoVuelos { get; set; }
    public DbSet<Aerolinea> Aerolineas { get; set; }
    
    public DbSet<Avion> Aviones { get; set; }
    public DbSet<VistaAvion> VistaAviones { get; set; }
    public DbSet<ModeloAvion> ModelosAvion { get; set; }
    public DbSet<EstadoAvion> EstadosAviones { get; set; }
    
    public DbSet<VistaDashboard> VistaDashboard { get; set; }
    
    public DbSet<Ruta> Rutas { get; set; }
    public DbSet<VistaRuta> VistaRutas { get; set; }
    public DbSet<RutaAerolinea> RutasAerolinea { get; set; }
    public DbSet<VistaRutaAerolinea> VistaRutasAerolinea { get; set; }
    public DbSet<RolUsuario> RolesUsuario { get; set; }
    
    public DbSet<Tripulante> Tripulantes { get; set; }

    public DbSet<VistaTripulante> VistaTripulantes { get; set; }
    public DbSet<AsignacionTripulacion> AsignacionTripulacion { get; set; }
    
    public DbSet<Mantenimiento> Mantenimientos { get; set; }
    public DbSet<MantenimientoTipo> MantenimientosTipos { get; set; }
    public DbSet<VistaMantenimientos> VistaMantenimientos { get; set; }
    
    public DbSet<Usuario> Usuarios { get; set; }
    public DbSet<UsersSecurity> UsersSecurity { get; set; }
    public DbSet<VistaUsuarios> VistaUsuarios { get; set; }
    public DbSet<VistaAdministracionUsuarios> VistaAdministracionUsuarios { get; set; }
    
    public DbSet<VistaLoggedUser> VistaLogedUser { get; set; }
    public DbSet<RetrasoVuelo> RetrasosVuelos { get; set; }
    
    public DbSet<VistaRetraso> VistaRetrasos { get; set; }
    public DbSet<CodigoRetrasoIata> CodigosRetrasos{ get; set; }
    
    public DbSet<EstadoVuelo> EstadosVuelo { get; set; }
    public DbSet<EstadoAvion> EstadosAvion { get; set; }

    
    public DbSet<DashboardStats> DashboardStats { get; set; }
    public DbSet<VuelosPorHoraDto> VuelosPorHora { get; set; }
    public DbSet<VuelosPorEstadoDto> VuelosPorEstado { get; set; }
    public DbSet<OcupacionSemanalDto> OcupacionSemanal { get; set; }
    public DbSet<AeronavesPorEstadoDto> AeronavesPorEstado { get; set; }
    public DbSet<ProximoVueloDto> ProximosVuelos { get; set; }
    public DbSet<VueloRecienteDto> VuelosRecientes { get; set; }
    public DbSet<TopRutaDto> TopRutas { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<DashboardStats>().HasNoKey().ToView(null);
        modelBuilder.Entity<VuelosPorHoraDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<VuelosPorEstadoDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<OcupacionSemanalDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<AeronavesPorEstadoDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<ProximoVueloDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<VueloRecienteDto>().HasNoKey().ToView(null);
        modelBuilder.Entity<TopRutaDto>().HasNoKey().ToView(null);
        
        // VistaRutaAerolinea tiene clave compuesta (ruta_id + aerolinea_id)
        modelBuilder.Entity<VistaRutaAerolinea>()
            .HasKey(v => new { v.RutaId, v.AerolineaId });
        
        base.OnModelCreating(modelBuilder);
    }
    
}