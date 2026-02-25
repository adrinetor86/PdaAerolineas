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
        //HARDCODEADO PARA QUE EL AEROPUERTO BASE SEA EL 1 (MADRID)
         List<VistaRuta> rutas = await _repoRutas.GetRutasAerolinea(1);
         
        return View(rutas);
    }
}