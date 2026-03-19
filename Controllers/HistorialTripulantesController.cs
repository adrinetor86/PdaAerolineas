using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Helpers;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers
{
    [Authorize]
    public class HistorialTripulantesController : Controller
    {
        private readonly RepositoryHistorialTripulantes _repoHistorial;

        public HistorialTripulantesController(RepositoryHistorialTripulantes repoHistorial)
        {
            _repoHistorial = repoHistorial;
        }


        public async Task<IActionResult> Detalle(int tripulanteId, int numPag = 1, int numFilas = 10)
        {
            int aerolineaId = User.GetAerolineaId();

            if (numPag < 1) numPag = 1;
            if (numFilas < 1) numFilas = 10;

            var tripulante = await _repoHistorial.GetTripulanteConEstadisticasAsync(tripulanteId, aerolineaId);

            if (tripulante == null)
            {
                return NotFound();
            }

            var (historial, total) = await _repoHistorial.GetHistorialPorTripulantePaginadoAsync(
                aerolineaId,
                tripulanteId,
                numPag,
                numFilas);

            ViewBag.HistorialVuelos = historial;

            ViewData["PAGINA_ACTUAL"] = numPag;
            ViewData["TOTAL_PAGINAS"] = Math.Max(1, (int)Math.Ceiling(total / (double)numFilas));
            ViewData["TOTAL_REGISTROS"] = total;
            ViewData["REGISTROS_PAG"] = numFilas;

            return View(tripulante);
        }


        [HttpGet]
        public async Task<IActionResult> EstadisticasJson(int tripulanteId)
        {
            var estadisticas = await _repoHistorial.GetEstadisticasTripulanteAsync(tripulanteId);
            return Json(estadisticas);
        }
    }
}