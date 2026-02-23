using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class TripulacionController : Controller
{
    private RepositoryTripulantes _repoTripulantes;

    public TripulacionController(RepositoryTripulantes repositoryTripulantes)
    {
        _repoTripulantes = repositoryTripulantes;
    }
    
    public async Task<IActionResult> Index()
    {
      List<VistaTripulante> tripulantes= await _repoTripulantes.GetTripulantesAsync();
        return View(tripulantes);
    }
}