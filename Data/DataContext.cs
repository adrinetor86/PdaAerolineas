using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Dashboard;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Models.ViewModels;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Data;

public class DataContext:DbContext
{
    public DataContext(DbContextOptions<DataContext> options):base(options){}
    

    public DbSet<Aeropuerto> Aeropuertos { get; set; }
    public DbSet<Pais> Paises { get; set; }
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
    
    public DbSet<CombustibleVuelo> CombustibleVuelos { get; set; }

   public DbSet<IngresoVueloViewModel> IngresosVuelos { get; set; }
   public DbSet<GastoCombustibleViewModel> GastosCombustible { get; set; }
    
   
   public DbSet<HistorialTripulante> HistorialTripulantes { get; set; }
   public DbSet<FinanzasVuelo> FinanzasVuelos { get; set; }
 
// NUEVAS VISTAS
   public DbSet<VistaFinanzasResumen> VistaFinanzasResumen { get; set; }
   public DbSet<VistaHistorialTripulante> VistaHistorialTripulantes { get; set; }
   
   
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
        
        modelBuilder.Entity<HistorialTripulante>()
            .HasOne(h => h.Tripulante)
            .WithMany()
            .HasForeignKey(h => h.TripulanteId)
            .OnDelete(DeleteBehavior.Restrict);
 
        modelBuilder.Entity<HistorialTripulante>()
            .HasOne(h => h.Vuelo)
            .WithMany()
            .HasForeignKey(h => h.VueloId)
            .OnDelete(DeleteBehavior.Restrict);
 
        modelBuilder.Entity<FinanzasVuelo>()
            .HasOne(f => f.Vuelo)
            .WithOne()
            .HasForeignKey<FinanzasVuelo>(f => f.VueloId)
            .OnDelete(DeleteBehavior.Restrict);
 
        modelBuilder.Entity<VistaFinanzasResumen>()
            .ToView("V_FINANZAS_RESUMEN")
            .HasNoKey();
 
        modelBuilder.Entity<VistaHistorialTripulante>()
            .ToView("V_HISTORIAL_TRIPULANTES")
            .HasNoKey();

        
        modelBuilder.Entity<VistaRutaAerolinea>()
            .HasKey(v => new { v.RutaId, v.AerolineaId });
          // -- CombustibleVuelo --
            modelBuilder.Entity<CombustibleVuelo>(e =>
            {
                e.ToTable("combustible_vuelo");
                e.HasKey(x => x.Id);
                e.Property(x => x.Id).HasColumnName("id");
                e.Property(x => x.VueloId).HasColumnName("vuelo_id");
                e.Property(x => x.LitrosCargados).HasColumnName("litros_cargados").HasColumnType("decimal(10,2)");
                e.Property(x => x.LitrosConsumidos).HasColumnName("litros_consumidos").HasColumnType("decimal(10,2)");
                e.Property(x => x.PrecioPorLitro).HasColumnName("precio_por_litro").HasColumnType("decimal(10,4)");
                e.Property(x => x.FechaRegistro).HasColumnName("fecha_registro");
                e.Property(x => x.Observaciones).HasColumnName("observaciones").HasMaxLength(500);
                e.HasOne(x => x.Vuelo).WithMany().HasForeignKey(x => x.VueloId);
            });

            // -- Vista: v_historial_tripulante (sin PK → HasNoKey) --
            modelBuilder.Entity<HistorialTripulanteViewModel>(e =>
            {
                e.HasNoKey();
                e.ToView("v_historial_tripulante");
                e.Property(x => x.TripulanteId).HasColumnName("tripulante_id");
                e.Property(x => x.Nombre).HasColumnName("nombre");
                e.Property(x => x.Apellido).HasColumnName("apellido");
                e.Property(x => x.NombreCompleto).HasColumnName("nombre_completo");
                e.Property(x => x.Rol).HasColumnName("rol");
                e.Property(x => x.IdAerolinea).HasColumnName("id_aerolinea");
                e.Property(x => x.NombreAerolinea).HasColumnName("nombre_aerolinea");
                e.Property(x => x.CodigoAerolinea).HasColumnName("codigo_aerolinea");
                e.Property(x => x.VueloId).HasColumnName("vuelo_id");
                e.Property(x => x.NumeroVuelo).HasColumnName("numero_vuelo");
                e.Property(x => x.FechaSalida).HasColumnName("fecha_salida");
                e.Property(x => x.FechaLlegada).HasColumnName("fecha_llegada");
                e.Property(x => x.DuracionMinutos).HasColumnName("duracion_minutos");
                e.Property(x => x.AeropuertoOrigen).HasColumnName("aeropuerto_origen");
                e.Property(x => x.IataOrigen).HasColumnName("iata_origen");
                e.Property(x => x.CiudadOrigen).HasColumnName("ciudad_origen");
                e.Property(x => x.AeropuertoDestino).HasColumnName("aeropuerto_destino");
                e.Property(x => x.IataDestino).HasColumnName("iata_destino");
                e.Property(x => x.CiudadDestino).HasColumnName("ciudad_destino");
                e.Property(x => x.DistanciaKm).HasColumnName("distancia_km");
                e.Property(x => x.EstadoVuelo).HasColumnName("estado_vuelo");
                e.Property(x => x.PasajerosEmbarcados).HasColumnName("pasajeros_embarcados");
                e.Property(x => x.PrecioBillete).HasColumnName("precio_billete").HasColumnType("decimal(10,2)");
            });

            // -- Vista: v_ingresos_vuelos --
            modelBuilder.Entity<IngresoVueloViewModel>(e =>
            {
                e.HasNoKey();
                e.ToView("v_ingresos_vuelos");
                e.Property(x => x.VueloId).HasColumnName("vuelo_id");
                e.Property(x => x.NumeroVuelo).HasColumnName("numero_vuelo");
                e.Property(x => x.FechaSalida).HasColumnName("fecha_salida");
                e.Property(x => x.FechaLlegada).HasColumnName("fecha_llegada");
                e.Property(x => x.PasajerosConfirmados).HasColumnName("pasajeros_confirmados");
                e.Property(x => x.PasajerosEmbarcados).HasColumnName("pasajeros_embarcados");
                e.Property(x => x.PrecioBillete).HasColumnName("precio_billete").HasColumnType("decimal(10,2)");
                e.Property(x => x.IngresosTotales).HasColumnName("ingresos_totales").HasColumnType("decimal(20,2)");
                e.Property(x => x.IngresosProyectados).HasColumnName("ingresos_proyectados").HasColumnType("decimal(20,2)");
                e.Property(x => x.AerolineaId).HasColumnName("aerolinea_id");
                e.Property(x => x.Aerolinea).HasColumnName("aerolinea");
                e.Property(x => x.CodigoAerolinea).HasColumnName("codigo_aerolinea");
                e.Property(x => x.IataOrigen).HasColumnName("iata_origen");
                e.Property(x => x.CiudadOrigen).HasColumnName("ciudad_origen");
                e.Property(x => x.IataDestino).HasColumnName("iata_destino");
                e.Property(x => x.CiudadDestino).HasColumnName("ciudad_destino");
                e.Property(x => x.DistanciaKm).HasColumnName("distancia_km");
                e.Property(x => x.EstadoVuelo).HasColumnName("estado_vuelo");
            });

            // -- Vista: v_gastos_combustible --
            modelBuilder.Entity<GastoCombustibleViewModel>(e =>
            {
                e.HasNoKey();
                e.ToView("v_gastos_combustible");
                e.Property(x => x.Id).HasColumnName("id");
                e.Property(x => x.VueloId).HasColumnName("vuelo_id");
                e.Property(x => x.NumeroVuelo).HasColumnName("numero_vuelo");
                e.Property(x => x.FechaSalida).HasColumnName("fecha_salida");
                e.Property(x => x.AerolineaId).HasColumnName("aerolinea_id");
                e.Property(x => x.Aerolinea).HasColumnName("aerolinea");
                e.Property(x => x.IataOrigen).HasColumnName("iata_origen");
                e.Property(x => x.CiudadOrigen).HasColumnName("ciudad_origen");
                e.Property(x => x.IataDestino).HasColumnName("iata_destino");
                e.Property(x => x.CiudadDestino).HasColumnName("ciudad_destino");
                e.Property(x => x.LitrosCargados).HasColumnName("litros_cargados").HasColumnType("decimal(10,2)");
                e.Property(x => x.LitrosConsumidos).HasColumnName("litros_consumidos").HasColumnType("decimal(10,2)");
                e.Property(x => x.PrecioPorLitro).HasColumnName("precio_por_litro").HasColumnType("decimal(10,4)");
                e.Property(x => x.CosteCarga).HasColumnName("coste_carga").HasColumnType("decimal(20,4)");
                e.Property(x => x.CosteConsumo).HasColumnName("coste_consumo").HasColumnType("decimal(20,4)");
                e.Property(x => x.PctConsumido).HasColumnName("pct_consumido").HasColumnType("decimal(10,2)");
                e.Property(x => x.FechaRegistro).HasColumnName("fecha_registro");
                e.Property(x => x.Observaciones).HasColumnName("observaciones");
                e.Property(x => x.EstadoVuelo).HasColumnName("estado_vuelo");
            });
        
        
        
        base.OnModelCreating(modelBuilder);
    }
    
}