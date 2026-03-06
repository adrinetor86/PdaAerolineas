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
    
    
    // public async Task<IActionResult> Historial(int id)
    // {
    //     var historial = await _repoAvion.GetHistorialAsync(id);
    //     var estadisticas = await _repoAvion.GetEstadisticasAsync(id);
    //         
    //     var viewModel = new HistorialAvionViewModel
    //     {
    //         Historial = historial,
    //         Estadisticas = estadisticas,
    //         TopRutas = await _repoAvion.GetTopRutasAsync(id)
    //     };
    //         
    //     return View(viewModel);
    // }
}