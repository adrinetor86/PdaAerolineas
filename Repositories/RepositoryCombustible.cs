using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.ViewModels;

namespace PdaAerolineas.Repositories
{
    public class RepositoryCombustible
    {
        private readonly DataContext _context;

        public RepositoryCombustible(DataContext context)
        {
            _context = context;
        }
        
        public async Task<List<GastoCombustibleViewModel>> GetTodosAsync(int? aerolineaId = null)
        {
            var query = _context.GastosCombustible.AsQueryable();

            if (aerolineaId.HasValue)
                query = query.Where(g => g.AerolineaId == aerolineaId.Value);

            return await query
                .OrderByDescending(g => g.FechaSalida)
                .ToListAsync();
        }
        
        public async Task<GastoCombustibleViewModel?> GetByVueloIdAsync(int vueloId)
        {
            return await _context.GastosCombustible
                .FirstOrDefaultAsync(g => g.VueloId == vueloId);
        }


        public async Task<CombustibleVuelo?> GetEntityByIdAsync(int id)
        {
            return await _context.CombustibleVuelos.FindAsync(id);
        }

        public async Task<bool> VueleTieneCombustibleAsync(int vueloId)
        {
            return await _context.CombustibleVuelos
                .AnyAsync(c => c.VueloId == vueloId);
        }
        
        public async Task<List<VueloSelectItem>> GetVuelosSinCombustibleAsync()
        {
            // Ids de vuelos que ya tienen combustible
            var conCombustible = await _context.CombustibleVuelos
                .Select(c => c.VueloId)
                .ToListAsync();

            return await _context.Vuelos
                .Where(v => !conCombustible.Contains(v.IdVuelo))
                .OrderByDescending(v => v.FechaSalida)
                .Select(v => new VueloSelectItem
                {
                    Id          = v.IdVuelo,
                    Descripcion = v.NumeroVuelo + " — " + v.FechaSalida.ToString("dd/MM/yyyy HH:mm")
                })
                .ToListAsync();
        }
        
        public async Task<(decimal TotalLitrosCargados, decimal TotalLitrosConsumidos, decimal TotalCoste)>
            GetResumenCombustibleAsync(int aerolineaId, DateTime? desde = null, DateTime? hasta = null)
        {
            var query = _context.GastosCombustible
                .Where(g => g.AerolineaId == aerolineaId);

            if (desde.HasValue) query = query.Where(g => g.FechaSalida >= desde.Value);
            if (hasta.HasValue) query = query.Where(g => g.FechaSalida <= hasta.Value);

            var lista = await query.ToListAsync();
            var totalCargados  = lista.Sum(g => g.LitrosCargados);
            var totalConsumidos = lista.Sum(g => g.LitrosConsumidos ?? 0);
            var totalCoste     = lista.Sum(g => g.CosteConsumo > 0 ? g.CosteConsumo : g.CosteCarga);

            return (totalCargados, totalConsumidos, totalCoste);
        }


        public async Task<int> RegistrarCombustibleAsync(
            int vueloId,
            decimal litrosCargados,
            decimal precioPorLitro,
            string? observaciones = null)
        {
            // Si no vienen litros cargados explícitos, los tomamos del vuelo (pasajeros_embarcados = combustible cargado).
            if (litrosCargados <= 0)
            {
                var litrosDesdeVuelo = await _context.Vuelos
                    .Where(v => v.IdVuelo == vueloId)
                    .Select(v => (decimal)v.PasajerosEmbarcados)
                    .FirstOrDefaultAsync();

                litrosCargados = litrosDesdeVuelo;
            }

            var pVuelo    = new SqlParameter("@vuelo_id",        vueloId);
            var pLitros   = new SqlParameter("@litros_cargados", litrosCargados);
            var pPrecio   = new SqlParameter("@precio_litro",    precioPorLitro);
            var pObs      = new SqlParameter("@observaciones",   (object?)observaciones ?? DBNull.Value);

            // sp_registrar_combustible hace SELECT SCOPE_IDENTITY() (numeric/decimal), así que no puede mapearse directo a int.
            var result = await _context.Database
                .SqlQueryRaw<decimal>("EXEC sp_registrar_combustible @vuelo_id, @litros_cargados, @precio_litro, @observaciones",
                    pVuelo, pLitros, pPrecio, pObs)
                .ToListAsync();

            var nuevoIdDecimal = result.FirstOrDefault();
            return Convert.ToInt32(nuevoIdDecimal);
        }
        
        public async Task ActualizarConsumoAsync(int combustibleId, decimal litrosConsumidos)
        {
            var pId      = new SqlParameter("@combustible_id",    combustibleId);
            var pLitros  = new SqlParameter("@litros_consumidos", litrosConsumidos);

            await _context.Database.ExecuteSqlRawAsync(
                "EXEC sp_actualizar_consumo @combustible_id, @litros_consumidos",
                pId, pLitros);
        }


        // Borrado deshabilitado: no se permite eliminar registros de combustible.

        public async Task<int?> AutoRegistrarCombustibleDesdeVueloAsync(
            int vueloId,
            decimal precioPorLitro,
            string? observaciones = null)
        {
            // Si ya existe combustible para ese vuelo, no hacemos nada.
            if (await VueleTieneCombustibleAsync(vueloId))
                return null;

            // Litros desde el vuelo (pasajeros_embarcados = combustible cargado)
            var litrosDesdeVuelo = await _context.Vuelos
                .Where(v => v.IdVuelo == vueloId)
                .Select(v => (decimal)v.PasajerosEmbarcados)
                .FirstOrDefaultAsync();

            if (litrosDesdeVuelo <= 0)
                return null;

            var nuevoId = await RegistrarCombustibleAsync(vueloId, litrosDesdeVuelo, precioPorLitro, observaciones);
            return nuevoId;
        }
    }
}
