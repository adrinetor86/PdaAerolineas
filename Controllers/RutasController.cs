using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class RutasController : Controller
{

    private RepositoryRutas _repoRutas;
    private RepositoryVuelos _repoVuelos;


    public RutasController(RepositoryRutas repoRutas, RepositoryVuelos repoVuelos)
    {
        _repoRutas = repoRutas;
        _repoVuelos = repoVuelos;
    }
    // GET

    public async Task<IActionResult> Index()
    {
        
        //TODO METER EN SESION EL ID
         List<VistaRuta> rutas = await _repoVuelos.GetRutasAerolinea();
        return View(rutas);
    }
}