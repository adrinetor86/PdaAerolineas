using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class VuelosController : Controller
{
    private RepositoryVuelos _repoVuelos;

    public VuelosController(RepositoryVuelos repoVuelos)
    {
        _repoVuelos = repoVuelos;
    }
    
    
    public async Task<IActionResult> Index()
    {
        List<VistaVuelo> vuelo = await _repoVuelos.GetVuelosAsync();
        return View(vuelo);
    }
}