using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using System.Text.Json;
using PdaAerolineas.Models.ViewModels;

namespace PdaAerolineas.Repositories
{
    public class RepositoryFinanzas
    {
        private readonly DataContext _context;

        public RepositoryFinanzas(DataContext context)
        {
            _context = context;
        }

        public async Task<List<FinanzasVueloDetalle>> GetFinanzasPorAerolineaAsync(
            int aerolineaId,
            DateTime? desde = null,
            DateTime? hasta = null)
        {
            var query = from f in _context.FinanzasVuelos
                        join v in _context.Vuelos on f.VueloId equals v.IdVuelo
                        join r in _context.Rutas on v.IdRuta equals r.IdRuta
                        join ao in _context.Aeropuertos on r.IdAeropuertoOrigen equals ao.IdAeropuerto // Corregido: IdAeropuertoOrigen
                        join ad in _context.Aeropuertos on r.IdAeropuertoDestino equals ad.IdAeropuerto
                        where v.IdAerolinea == aerolineaId
                        select new FinanzasVueloDetalle
                        {
                            Id = f.Id,
                            VueloId = f.VueloId,
                            NumeroVuelo = v.NumeroVuelo,
                            Ruta = ao.Cod_Iata + "-" + ad.Cod_Iata,
                            FechaSalida = v.FechaSalida,
                            IngresoPasajes = f.IngresoPasajes,
                            CosteCombustible = f.CosteCombustible,
                            CosteTripulacion = f.CosteTripulacion,
                            CosteMantenimiento = f.CosteMantenimiento,
                            OtrosCostes = f.OtrosCostes,
                            BeneficioNeto = f.BeneficioNeto,
                            FechaCalculo = f.FechaCalculo
                        };

            if (desde.HasValue)
                query = query.Where(f => f.FechaSalida >= desde.Value);

            if (hasta.HasValue)
                query = query.Where(f => f.FechaSalida <= hasta.Value);

            return await query
                .OrderByDescending(f => f.FechaSalida)
                .ToListAsync();
        }

        public async Task<FinanzasVuelo?> GetFinanzasPorVueloAsync(int vueloId)
        {
            return await _context.FinanzasVuelos
                .FirstOrDefaultAsync(f => f.VueloId == vueloId);
        }

        public async Task<Vuelo?> GetVueloPorIdAsync(int vueloId)
        {
            return await _context.Vuelos.FindAsync(vueloId);
        }

        public async Task<ResumenFinanciero> GetResumenFinancieroAsync(
            int aerolineaId,
            DateTime? desde = null,
            DateTime? hasta = null)
        {
            var query = _context.FinanzasVuelos
                .Include(f => f.Vuelo)
                .Where(f => f.Vuelo.IdAerolinea == aerolineaId);

            if (desde.HasValue)
                query = query.Where(f => f.Vuelo.FechaSalida >= desde.Value);

            if (hasta.HasValue)
                query = query.Where(f => f.Vuelo.FechaSalida <= hasta.Value);

            var finanzas = await query.ToListAsync();

            return new ResumenFinanciero
            {
                TotalVuelos = finanzas.Count,
                TotalIngresos = finanzas.Sum(f => f.IngresoPasajes),
                TotalCosteCombustible = finanzas.Sum(f => f.CosteCombustible),
                TotalCosteTripulacion = finanzas.Sum(f => f.CosteTripulacion),
                TotalCosteMantenimiento = finanzas.Sum(f => f.CosteMantenimiento),
                TotalOtrosCostes = finanzas.Sum(f => f.OtrosCostes),
                TotalCostes = finanzas.Sum(f => f.CosteCombustible + f.CosteTripulacion + f.CosteMantenimiento + f.OtrosCostes),
                BeneficioTotal = finanzas.Sum(f => f.BeneficioNeto),
                BeneficioPromedio = finanzas.Any() ? finanzas.Average(f => f.BeneficioNeto) : 0,
                MargenPromedio = finanzas.Any() && finanzas.Sum(f => f.IngresoPasajes) > 0
                    ? (finanzas.Sum(f => f.BeneficioNeto) / finanzas.Sum(f => f.IngresoPasajes)) * 100
                    : 0
            };
        }

        public async Task<List<FinanzasPorRuta>> GetFinanzasPorRutaAsync(
            int aerolineaId,
            DateTime? desde = null,
            DateTime? hasta = null)
        {
            var query = from f in _context.FinanzasVuelos
                        join v in _context.Vuelos on f.VueloId equals v.IdVuelo
                        join r in _context.Rutas on v.IdRuta equals r.IdRuta
                        join ao in _context.Aeropuertos on r.IdAeropuertoOrigen equals ao.IdAeropuerto
                        join ad in _context.Aeropuertos on r.IdAeropuertoDestino equals ad.IdAeropuerto
                        where v.IdAerolinea == aerolineaId
                        group f by new { r.IdRuta, Ruta = ao.Cod_Iata + "-" + ad.Cod_Iata } into g
                        select new FinanzasPorRuta
                        {
                            RutaId = g.Key.IdRuta,
                            Ruta = g.Key.Ruta,
                            TotalVuelos = g.Count(),
                            TotalIngresos = g.Sum(x => x.IngresoPasajes),
                            TotalCostes = g.Sum(x => x.CosteCombustible + x.CosteTripulacion + x.CosteMantenimiento + x.OtrosCostes),
                            BeneficioTotal = g.Sum(x => x.BeneficioNeto),
                            BeneficioPromedio = g.Average(x => x.BeneficioNeto)
                        };

            var resultados = await query.ToListAsync();

            if (desde.HasValue || hasta.HasValue)
            {
                var vuelosFiltrados = await _context.Vuelos
                    .Where(v => v.IdAerolinea == aerolineaId)
                    .Where(v => !desde.HasValue || v.FechaSalida >= desde.Value)
                    .Where(v => !hasta.HasValue || v.FechaSalida <= hasta.Value)
                    .Select(v => v.IdVuelo)
                    .ToListAsync();

                if (!vuelosFiltrados.Any())
                    return new List<FinanzasPorRuta>();

                resultados = resultados.ToList();
            }

            return resultados.OrderByDescending(r => r.BeneficioTotal).ToList();
        }

        public async Task ActualizarFinanzasManualAsync(
            int vueloId,
            decimal? ingresoPasajes = null,
            decimal? costeCombustible = null,
            decimal? costeTripulacion = null,
            decimal? costeMantenimiento = null,
            decimal? otrosCostes = null)
        {
            var finanzas = await _context.FinanzasVuelos
                .FirstOrDefaultAsync(f => f.VueloId == vueloId);

            if (finanzas == null)
                return;

            if (ingresoPasajes.HasValue)
                finanzas.IngresoPasajes = ingresoPasajes.Value;

            if (costeCombustible.HasValue)
                finanzas.CosteCombustible = costeCombustible.Value;

            if (costeTripulacion.HasValue)
                finanzas.CosteTripulacion = costeTripulacion.Value;

            if (costeMantenimiento.HasValue)
                finanzas.CosteMantenimiento = costeMantenimiento.Value;

            if (otrosCostes.HasValue)
                finanzas.OtrosCostes = otrosCostes.Value;

            finanzas.BeneficioNeto = finanzas.IngresoPasajes - 
                (finanzas.CosteCombustible + finanzas.CosteTripulacion + 
                 finanzas.CosteMantenimiento + finanzas.OtrosCostes);

            finanzas.FechaCalculo = DateTime.Now;

            await _context.SaveChangesAsync();
        }

        public async Task EliminarFinanzasAsync(int vueloId)
        {
            var finanzas = await _context.FinanzasVuelos
                .FirstOrDefaultAsync(f => f.VueloId == vueloId);

            if (finanzas != null)
            {
                _context.FinanzasVuelos.Remove(finanzas);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<FinanzasDashboardViewModel> GetDashboardFinanzasAsync(int aerolineaId)
        {
            // 1. Ejecución secuencial para evitar InvalidOperationException en DbContext
            var resumen = await _context.VistaFinanzasResumen
                .Where(r => r.AerolineaId == aerolineaId)
                .FirstOrDefaultAsync();

            var detalle = await GetFinanzasPorAerolineaAsync(aerolineaId);

            // 2. Procesamiento de series para gráficos
            var vuelosRecientes = detalle
                .OrderByDescending(x => x.FechaSalida)
                .Take(12)
                .OrderBy(x => x.FechaSalida)
                .ToList();

            var labelsVuelos = vuelosRecientes.Select(x => x.NumeroVuelo).ToList();
            var ingresosVuelos = vuelosRecientes.Select(x => x.IngresoPasajes).ToList();
            var costesVuelos = vuelosRecientes.Select(x => x.CosteTotal).ToList();

            var serieBeneficioDia = detalle
                .GroupBy(x => x.FechaSalida.Date)
                .Select(g => new { Fecha = g.Key, Beneficio = g.Sum(v => v.BeneficioNeto) })
                .OrderBy(x => x.Fecha)
                .TakeLast(30)
                .ToList();

            var labelsDias = serieBeneficioDia.Select(x => x.Fecha.ToString("dd/MM")).ToList();
            var beneficiosDias = serieBeneficioDia.Select(x => x.Beneficio).ToList();

            return new FinanzasDashboardViewModel
            {
                Resumen = resumen,
                DetalleVuelos = detalle,
                LabelsVuelosJson = JsonSerializer.Serialize(labelsVuelos),
                IngresosVuelosJson = JsonSerializer.Serialize(ingresosVuelos),
                CostesVuelosJson = JsonSerializer.Serialize(costesVuelos),
                LabelsDiasJson = JsonSerializer.Serialize(labelsDias),
                BeneficiosDiasJson = JsonSerializer.Serialize(beneficiosDias)
            };
        }
    }

    public class FinanzasVueloDetalle
    {
        public int Id { get; set; }
        public int VueloId { get; set; }
        public string NumeroVuelo { get; set; } = string.Empty;
        public string Ruta { get; set; } = string.Empty;
        public DateTime FechaSalida { get; set; }
        public decimal IngresoPasajes { get; set; }
        public decimal CosteCombustible { get; set; }
        public decimal CosteTripulacion { get; set; }
        public decimal CosteMantenimiento { get; set; }
        public decimal OtrosCostes { get; set; }
        public decimal BeneficioNeto { get; set; }
        public DateTime FechaCalculo { get; set; }

        public decimal CosteTotal => CosteCombustible + CosteTripulacion + CosteMantenimiento + OtrosCostes;
        public decimal MargenPorcentaje => IngresoPasajes > 0 ? (BeneficioNeto / IngresoPasajes) * 100 : 0;
    }

    public class ResumenFinanciero
    {
        public int TotalVuelos { get; set; }
        public decimal TotalIngresos { get; set; }
        public decimal TotalCosteCombustible { get; set; }
        public decimal TotalCosteTripulacion { get; set; }
        public decimal TotalCosteMantenimiento { get; set; }
        public decimal TotalOtrosCostes { get; set; }
        public decimal TotalCostes { get; set; }
        public decimal BeneficioTotal { get; set; }
        public decimal BeneficioPromedio { get; set; }
        public decimal MargenPromedio { get; set; }
    }

    public class FinanzasPorRuta
    {
        public int RutaId { get; set; }
        public string Ruta { get; set; } = string.Empty;
        public int TotalVuelos { get; set; }
        public decimal TotalIngresos { get; set; }
        public decimal TotalCostes { get; set; }
        public decimal BeneficioTotal { get; set; }
        public decimal BeneficioPromedio { get; set; }
    }
}