using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class DashboardController : Controller
{

    private RepositoryFlota _repoFlota;

    public DashboardController(RepositoryFlota repoFlota)
    {
        _repoFlota = repoFlota;
    }

    public async Task<IActionResult> Index()
    {
        FlotaResumen flota= await _repoFlota.GetFlotasByAerolineaAsync("Iberia");
        return View(flota);
    }
}