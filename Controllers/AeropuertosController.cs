using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Repositories;
using PdaAerolineas.Services;

namespace PdaAerolineas.Controllers;

public class AeropuertosController : Controller
{
    private RepositoryAeropuertos _repoAeropuertos;
    private ServiceMetar _serviceMetar;
    public AeropuertosController(RepositoryAeropuertos repoAeropuertos,ServiceMetar serviceMetar)
    {
        _repoAeropuertos = repoAeropuertos;
        _serviceMetar = serviceMetar;
    }
    
    public async Task<IActionResult> Index(int? numPag, string busqueda)
    {
        int pagina = numPag ?? 1;
        int pageSize = 12; 

        var resultado = await _repoAeropuertos.GetAeropuertosPaginadosAsync(pagina, pageSize, busqueda);
            
        ViewData["TOTAL_REGISTROS"] = resultado.TotalRegistros;
        ViewData["BUSQUEDA"] = busqueda;

        return View(resultado.Aeropuertos);
    }
    
    
    public async Task<IActionResult> Clima(string iata)
    {
        if (string.IsNullOrEmpty(iata)) return RedirectToAction("Index");

        var clima = await _serviceMetar.GetMetarAsync(iata);
    
        if (clima == null)
        {
            TempData["Error"] = "No se pudo obtener la información meteorológica.";
            return RedirectToAction("Index");
        }

        return View(clima);
    }
}