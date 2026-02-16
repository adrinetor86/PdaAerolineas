using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class DashboardController : Controller
{

    private RepositoryFlotas _repoFlotas;

    public DashboardController(RepositoryFlotas repoFlotas)
    {
        _repoFlotas = repoFlotas;
    }

    public async Task<IActionResult> Index()
    {
        FlotaResumen flota= await _repoFlotas.GetFlotasByAerolineaAsync("Iberia");
        return View(flota);
    }
}