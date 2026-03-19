using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models.ViewModels;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers
{
    [Authorize(Policy = "AdminOrGestor")]
    public class CombustibleController : Controller
    {
        private readonly RepositoryCombustible _repoCombustible;
        private readonly RepositoryAerolineas  _repoAerolineas;

        public CombustibleController(
            RepositoryCombustible repoCombustible,
            RepositoryAerolineas repoAerolineas)
        {
            _repoCombustible = repoCombustible;
            _repoAerolineas  = repoAerolineas;
        }

        // GET /Combustible
        public async Task<IActionResult> Index(int? aerolineaId, int numPag = 1, int numFilas = 10)
        {
            if (numPag < 1) numPag = 1;
            if (numFilas < 1) numFilas = 10;

            ViewBag.Aerolineas  = await _repoAerolineas.GetAerolineasAsync();
            ViewBag.AerolineaId = aerolineaId;

            // Total filtrado (para KPIs)
            var listaTotal = await _repoCombustible.GetTodosAsync(aerolineaId);

            ViewBag.TotalLitrosCargados    = listaTotal.Sum(g => g.LitrosCargados);
            ViewBag.TotalLitrosConsumidos = listaTotal.Sum(g => g.LitrosConsumidos ?? 0);
            ViewBag.TotalCoste            = listaTotal.Sum(g => g.CosteConsumo > 0 ? g.CosteConsumo : g.CosteCarga);

            // Paginación
            var totalRegistros = listaTotal.Count;
            var totalPaginas = (int)Math.Ceiling(totalRegistros / (double)numFilas);
            if (totalPaginas < 1) totalPaginas = 1;
            if (numPag > totalPaginas) numPag = totalPaginas;

            var pagina = listaTotal
                .Skip((numPag - 1) * numFilas)
                .Take(numFilas)
                .ToList();

            ViewData["PAGINA_ACTUAL"]   = numPag;
            ViewData["TOTAL_PAGINAS"]   = totalPaginas;
            ViewData["TOTAL_REGISTROS"] = totalRegistros;
            ViewData["REGISTROS_PAG"]   = numFilas;

            return View(pagina);
        }


        // GET /Combustible/ActualizarConsumo/5
        public async Task<IActionResult> ActualizarConsumo(int id)
        {
            var entidad = await _repoCombustible.GetEntityByIdAsync(id);
            if (entidad == null) return NotFound();

            var vm = new ActualizarConsumoViewModel
            {
                CombustibleId  = id,
                LitrosConsumidos = entidad.LitrosCargados  // valor sugerido
            };
            return View(vm);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ActualizarConsumo(ActualizarConsumoViewModel vm)
        {
            if (!ModelState.IsValid)
                return View(vm);

            await _repoCombustible.ActualizarConsumoAsync(vm.CombustibleId, vm.LitrosConsumidos);
            return RedirectToAction(nameof(Index));
        }


        public async Task<IActionResult> DatosJson(int? aerolineaId)
        {
            var lista = await _repoCombustible.GetTodosAsync(aerolineaId);
            var datos = lista.Select(g => new
            {
                vuelo          = g.NumeroVuelo,
                ruta           = g.RutaCorta,
                fecha          = g.FechaSalida.ToString("dd/MM/yyyy"),
                litrosCargados = g.LitrosCargados,
                litrosConsumidos = g.LitrosConsumidos,
                precioPorLitro = g.PrecioPorLitro,
                costeCarga     = g.CosteCarga,
                costeConsumo   = g.CosteConsumo,
                pctConsumido   = g.PctConsumido
            });
            return Json(datos);
        }
    }
}
