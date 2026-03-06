using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;



[HighRoles]
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
         //Si no existe seteo a 0 
         int idAerolinea = HttpContext.Session.GetInt32("AEROLINEA") ?? 0;
         
         //Seteamos la base en madrid
         List<VistaRuta> rutas = await _repoRutas.GetRutasAerolinea(1,idAerolinea);
         
        return View(rutas);
    }
}