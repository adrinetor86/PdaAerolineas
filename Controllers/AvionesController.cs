using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class AvionesController : Controller
{

    private RepositoryAviones _repoAviones;

    public AvionesController(RepositoryAviones repoAviones)
    {
        _repoAviones = repoAviones;
    }
    
    public async Task<IActionResult> Historial(int id)
    {
        List<VistaHistorialVuelo> historial = await _repoAviones.GetHistorialByAvionIdAsync(id);

        if (historial.Count == 0)
        {
            ViewData["AVION_INFO"] = "Sin datos";
            return View(new List<VistaHistorialVuelo>());
        }

        var vuelo = historial.First();
        ViewData["AVION_INFO"] = $"{vuelo.Matricula} — {vuelo.Fabricante} {vuelo.NombreModelo}";
        ViewData["AVION_ID"] = id;

        return View(historial);
    }
}