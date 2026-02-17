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
        ViewData["ESTADOS"]=  await _repoVuelos.GetEstadosVuelosAync();
        return View(vuelo);
    }

    
    

    [HttpPost]

    public async Task<IActionResult> Index(int idVuelo, int idEstado)
    {
        
        await _repoVuelos.UpdateEstadoVueloAsync(idVuelo, idEstado);
        return RedirectToAction("Index");
    }
    
}