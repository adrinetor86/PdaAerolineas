using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories
{
    public class RepositoryHistorialTripulantes
    {
        private readonly DataContext _context;

        public RepositoryHistorialTripulantes(DataContext context)
        {
            _context = context;
        }

        public async Task<(List<VistaHistorialTripulante> Datos, int TotalRegistros)> GetHistorialPaginadoAsync(
            int aerolineaId,
            int numPag,
            int numFilas,
            int? tripulanteId = null,
            DateTime? desde = null,
            DateTime? hasta = null)
        {
            var pTotal = new SqlParameter("@TotalRegistros", System.Data.SqlDbType.Int)
            {
                Direction = System.Data.ParameterDirection.Output
            };

            // Ejecutamos el procedimiento para obtener el resultado paginado + total.
            var lista = await _context.VistaHistorialTripulantes
                .FromSqlInterpolated(
                    $"EXEC SP_HISTORIAL_TRIPULANTES_PAGINADO @AerolineaId={aerolineaId}, @PageNumber={numPag}, @PageSize={numFilas}, @TripulanteId={tripulanteId}, @Desde={desde}, @Hasta={hasta}, @TotalRegistros={pTotal} OUTPUT")
                .AsNoTracking()
                .ToListAsync();

            int total = (pTotal.Value != DBNull.Value) ? (int)pTotal.Value : 0;
            return (lista, total);
        }

        public async Task<List<VistaHistorialTripulante>> GetHistorialPorTripulanteAsync(int tripulanteId)
        {
            return await _context.VistaHistorialTripulantes
                .Where(h => h.TripulanteId == tripulanteId)
                .OrderByDescending(h => h.FechaSalida)
                .ToListAsync();
        }

        public async Task<List<VistaTripulante>> GetTripulantesPorAerolineaAsync(int aerolineaId)
        {
            return await _context.VistaTripulantes
                .Where(t => t.IdAerolinea == aerolineaId)
                .OrderBy(t => t.Nombre)
                .ToListAsync();
        }

        public async Task<TripulanteEstadisticas?> GetTripulanteConEstadisticasAsync(int tripulanteId, int aerolineaId)
        {
            var tripulante = await _context.Tripulantes
                .FirstOrDefaultAsync(t => t.IdTripulante == tripulanteId && t.IdAerolinea == aerolineaId);

            if (tripulante == null)
                return null;

            var estadisticas = await GetEstadisticasTripulanteAsync(tripulanteId);

            return new TripulanteEstadisticas
            {
                Tripulante = tripulante,
                TotalVuelos = estadisticas.TotalVuelos,
                TotalHoras = estadisticas.TotalHoras,
                UltimoVuelo = estadisticas.UltimoVuelo
            };
        }

        public async Task<EstadisticasTripulante> GetEstadisticasTripulanteAsync(int tripulanteId)
        {
            var historial = await _context.HistorialTripulantes
                .Where(h => h.TripulanteId == tripulanteId)
                .ToListAsync();

            var ultimoVuelo = await _context.HistorialTripulantes
                .Where(h => h.TripulanteId == tripulanteId)
                .OrderByDescending(h => h.FechaRegistro)
                .Select(h => h.FechaRegistro)
                .FirstOrDefaultAsync();

            return new EstadisticasTripulante
            {
                TotalVuelos = historial.Count,
                TotalHoras = historial.Sum(h => h.HorasVoladas ?? 0),
                UltimoVuelo = ultimoVuelo
            };
        }

        public async Task<int> RegistrarHistorialManualAsync(
            int tripulanteId,
            int vueloId,
            string rol,
            decimal horasVoladas,
            string? observaciones = null)
        {
            var historial = new HistorialTripulante
            {
                TripulanteId = tripulanteId,
                VueloId = vueloId,
                Rol = rol,
                HorasVoladas = horasVoladas,
                Observaciones = observaciones ?? "Registro manual",
                FechaRegistro = DateTime.Now
            };

            _context.HistorialTripulantes.Add(historial);
            await _context.SaveChangesAsync();

            return historial.Id;
        }

        public async Task EliminarHistorialAsync(int historialId)
        {
            var historial = await _context.HistorialTripulantes.FindAsync(historialId);

            if (historial != null)
            {
                _context.HistorialTripulantes.Remove(historial);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<(List<VistaHistorialTripulante> Datos, int TotalRegistros)> GetHistorialPorTripulantePaginadoAsync(
            int aerolineaId,
            int tripulanteId,
            int numPag,
            int numFilas)
        {
            var pTotal = new SqlParameter("@TotalRegistros", System.Data.SqlDbType.Int)
            {
                Direction = System.Data.ParameterDirection.Output
            };

            var lista = await _context.VistaHistorialTripulantes
                .FromSqlInterpolated(
                    $"EXEC SP_HISTORIAL_TRIPULANTES_PAGINADO @AerolineaId={aerolineaId}, @PageNumber={numPag}, @PageSize={numFilas}, @TripulanteId={tripulanteId}, @Desde={null}, @Hasta={null}, @TotalRegistros={pTotal} OUTPUT")
                .AsNoTracking()
                .ToListAsync();

            // Normalizar rol cuando viene genérico desde la automatización.
            var rolReal = await _context.Tripulantes
                .Where(t => t.IdTripulante == tripulanteId)
                .Select(t => t.Rol)
                .FirstOrDefaultAsync();

            if (!string.IsNullOrWhiteSpace(rolReal))
            {
                foreach (var h in lista)
                {
                    if (string.IsNullOrWhiteSpace(h.Rol)
                        || h.Rol.Equals("Tripulante de Vuelo", StringComparison.OrdinalIgnoreCase))
                    {
                        h.Rol = rolReal;
                    }
                }
            }

            int total = (pTotal.Value != DBNull.Value) ? (int)pTotal.Value : 0;
            return (lista, total);
        }
    }

    public class TripulanteEstadisticas
    {
        public Tripulante Tripulante { get; set; } = null!;
        public int TotalVuelos { get; set; }
        public decimal TotalHoras { get; set; }
        public DateTime? UltimoVuelo { get; set; }
    }

    public class EstadisticasTripulante
    {
        public int TotalVuelos { get; set; }
        public decimal TotalHoras { get; set; }
        public DateTime? UltimoVuelo { get; set; }
    }
}

