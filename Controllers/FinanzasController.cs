using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Helpers;
using PdaAerolineas.Repositories;
using PdaAerolineas.Models.ViewModels;

namespace PdaAerolineas.Controllers
{
    [Authorize(Policy = "AdminOrGestor")]
    public class FinanzasController : Controller
    {
        private readonly RepositoryFinanzas _repoFinanzas;
        private readonly RepositoryAutomatizacion _repoAutomatizacion;

        public FinanzasController(
            RepositoryFinanzas repoFinanzas,
            RepositoryAutomatizacion repoAutomatizacion,
            RepositoryAerolineas repoAerolineas)
        {
            _repoFinanzas = repoFinanzas;
            _repoAutomatizacion = repoAutomatizacion;
        }

        public async Task<IActionResult> Index(int numPag = 1, int numFilas = 10)
        {
            if (numPag < 1) numPag = 1;
            if (numFilas < 1) numFilas = 10;

            int aerolineaId = User.GetAerolineaId();

            FinanzasDashboardViewModel vm = await _repoFinanzas.GetDashboardFinanzasAsync(aerolineaId);
            ViewBag.AerolineaId = aerolineaId;

            var totalRegistros = vm.DetalleVuelos?.Count ?? 0;
            var totalPaginas = (int)Math.Ceiling(totalRegistros / (double)numFilas);
            if (totalPaginas < 1) totalPaginas = 1;
            if (numPag > totalPaginas) numPag = totalPaginas;

            if (vm.DetalleVuelos != null)
            {
                vm.DetalleVuelos = vm.DetalleVuelos
                    .Skip((numPag - 1) * numFilas)
                    .Take(numFilas)
                    .ToList();
            }

            ViewData["PAGINA_ACTUAL"]   = numPag;
            ViewData["TOTAL_PAGINAS"]   = totalPaginas;
            ViewData["TOTAL_REGISTROS"] = totalRegistros;
            ViewData["REGISTROS_PAG"]   = numFilas;

            return View(vm);
        }

        public async Task<IActionResult> Detalle(int vueloId)
        {
            var finanzas = await _repoAutomatizacion.GetFinanzasVueloAsync(vueloId);
            
            if (finanzas == null)
            {
                return NotFound();
            }
            
            int aerolineaId = User.GetAerolineaId();
            if (!User.IsInRole("Administrador"))
            {
                var vuelo = await _repoFinanzas.GetVueloPorIdAsync(vueloId);
                if (vuelo.IdAerolinea != aerolineaId)
                {
                    return Forbid();
                }
            }
            
            return View(finanzas);
        }

        [Authorize(Policy = "AdminOnly")]
        public async Task<IActionResult> Resumen()
        {
            var resumen = await _repoAutomatizacion.GetResumenFinanzasTodasAerolineasAsync();
            return View("Rutas", resumen);
        }

        [HttpPost]
        [Authorize(Policy = "AdminOnly")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RecalcularFinanzas(int vueloId)
        {
            try
            {
                await _repoAutomatizacion.EjecutarAutomatizacionCompletaAsync(vueloId);
                TempData["Success"] = "Finanzas recalculadas correctamente";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error al recalcular finanzas: " + ex.Message;
            }
            
            return RedirectToAction(nameof(Detalle), new { vueloId });
        }
    }
}