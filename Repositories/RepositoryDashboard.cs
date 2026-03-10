using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models.Dashboard;

namespace PdaAerolineas.Repositories;

public class RepositoryDashboard
{
    private readonly DataContext _context;
        
    public RepositoryDashboard(DataContext context)
    {
        _context = context;
    }
    
  public async Task<DashboardViewModel> GetDashboardDataAsync(int aerolineaId)
        {
            var viewModel = new DashboardViewModel();
            
            // ===== 1. ESTADÍSTICAS PRINCIPALES (mapea DashboardStats DTO) =====
            var stats = await _context.Database
                .SqlQuery<DashboardStats>($"EXEC SP_GET_DASHBOARD_STATS @aerolinea_id={aerolineaId}")
                .AsAsyncEnumerable()
                .FirstOrDefaultAsync();
            
            if (stats != null)
            {
                viewModel.TotalVuelos = stats.TotalVuelos;
                viewModel.VuelosEnVuelo = stats.VuelosEnVuelo;
                viewModel.VuelosHoy = stats.VuelosHoy;
                viewModel.VuelosCancelados = stats.VuelosCancelados;
                viewModel.TotalAeronaves = stats.TotalAeronaves;
                viewModel.AeronavesOperativas = stats.AeronavesOperativas;
                viewModel.AeronavesEnMantenimiento = stats.AeronavesEnMantenimiento;
                viewModel.AeronavesEnVuelo = stats.AeronavesEnVuelo;
                viewModel.PasajerosHoy = stats.PasajerosHoy;
                viewModel.OcupacionPromedio = stats.OcupacionPromedio;
                viewModel.TotalPasajerosMes = stats.TotalPasajerosMes;
                viewModel.MantenimientosActivos = stats.MantenimientosActivos;
                viewModel.MantenimientosPendientes = stats.MantenimientosPendientes;
            }
            
            // ===== 2. VUELOS POR HORA =====
            var vuelosPorHora = await _context.Database
                .SqlQuery<VuelosPorHoraDto>($"EXEC SP_GET_VUELOS_POR_HORA @aerolinea_id={aerolineaId}, @fecha={null}")
                .ToListAsync();
            
            viewModel.VuelosPorHoraJson = JsonSerializer.Serialize(
                vuelosPorHora.Select(v => new { hora = v.Hora, vuelos = v.Vuelos })
            );
            
            // ===== 3. VUELOS POR ESTADO =====
            var vuelosPorEstado = await _context.Database
                .SqlQuery<VuelosPorEstadoDto>($"EXEC SP_GET_VUELOS_POR_ESTADO @aerolinea_id={aerolineaId}")
                .ToListAsync();
            
            viewModel.VuelosPorEstadoJson = JsonSerializer.Serialize(
                vuelosPorEstado.Select(v => new { estado = v.Estado, total = v.Total })
            );
            
            // ===== 4. OCUPACIÓN SEMANAL =====
            var ocupacionSemanal = await _context.Database
                .SqlQuery<OcupacionSemanalDto>($"EXEC SP_GET_OCUPACION_SEMANAL @aerolinea_id={aerolineaId}")
                .ToListAsync();
            
            viewModel.OcupacionSemanalJson = JsonSerializer.Serialize(
                ocupacionSemanal.Select(o => new { fecha = o.Fecha, ocupacion = o.Ocupacion })
            );
            
            // ===== 5. AERONAVES POR ESTADO =====
            var aeronavesPorEstado = await _context.Database
                .SqlQuery<AeronavesPorEstadoDto>($"EXEC SP_GET_AERONAVES_POR_ESTADO @aerolinea_id={aerolineaId}")
                .ToListAsync();
            
            viewModel.AeronavesPorEstadoJson = JsonSerializer.Serialize(
                aeronavesPorEstado.Select(a => new { estado = a.Estado, total = a.Total })
            );
            
            // ===== 6. PRÓXIMOS VUELOS =====
            viewModel.ProximosVuelos = await _context.Database
                .SqlQuery<ProximoVueloDto>($"EXEC SP_GET_PROXIMOS_VUELOS @aerolinea_id={aerolineaId}, @limite={5}")
                .ToListAsync();
            
            // ===== 7. VUELOS RECIENTES =====
            viewModel.VuelosRecientes = await _context.Database
                .SqlQuery<VueloRecienteDto>($"EXEC SP_GET_VUELOS_RECIENTES @aerolinea_id={aerolineaId}, @limite={5}")
                .ToListAsync();
            
            // ===== 8. TOP RUTAS =====
            viewModel.TopRutas = await _context.Database
                .SqlQuery<TopRutaDto>($"EXEC SP_GET_TOP_RUTAS @aerolinea_id={aerolineaId}, @dias={30}, @limite={5}")
                .ToListAsync();
            
            return viewModel;
        }
    }