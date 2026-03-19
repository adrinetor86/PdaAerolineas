using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories
{
    public class RepositoryAutomatizacion
    {
        private readonly DataContext _context;

        public RepositoryAutomatizacion(DataContext context)
        {
            _context = context;
        }

        public async Task EjecutarAutomatizacionCompletaAsync(int vueloId)
        {
            var paramVueloId = new SqlParameter("@vuelo_id", vueloId);
            
            await _context.Database.ExecuteSqlRawAsync(
                "EXEC SP_AUTOMATIZAR_FINALIZACION_VUELO @vuelo_id",
                paramVueloId);
        }

        public async Task<bool> VueloTieneAutomatizacionCompletaAsync(int vueloId)
        {
            var tieneCombustible = await _context.CombustibleVuelos
                .AnyAsync(c => c.VueloId == vueloId);

            var tieneFinanzas = await _context.FinanzasVuelos
                .AnyAsync(f => f.VueloId == vueloId);

            var tieneHistorial = await _context.HistorialTripulantes
                .AnyAsync(h => h.VueloId == vueloId);

            return tieneCombustible && tieneFinanzas && tieneHistorial;
        }

        public async Task<FinanzasVuelo?> GetFinanzasVueloAsync(int vueloId)
        {
            return await _context.FinanzasVuelos
                .FirstOrDefaultAsync(f => f.VueloId == vueloId);
        }

        public async Task<List<VistaHistorialTripulante>> GetHistorialTripulantesVueloAsync(int vueloId)
        {
            return await _context.VistaHistorialTripulantes
                .Where(h => h.VueloId == vueloId)
                .ToListAsync();
        }

        public async Task<VistaFinanzasResumen?> GetResumenFinanzasAerolineaAsync(int aerolineaId)
        {
            return await _context.VistaFinanzasResumen
                .Where(v => v.AerolineaId == aerolineaId)
                .FirstOrDefaultAsync();
        }

        public async Task<List<VistaFinanzasResumen>> GetResumenFinanzasTodasAerolineasAsync()
        {
            return await _context.VistaFinanzasResumen
                .OrderByDescending(v => v.BeneficioTotal)
                .ToListAsync();
        }
    }
}