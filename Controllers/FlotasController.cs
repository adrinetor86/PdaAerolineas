using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class FlotasController : Controller
{
    
    private RepositoryFlotas _repoFlotas;
    private RepositoryVuelos _repoVuelos;
    private RepositoryAviones _repoAviones;


    public FlotasController(RepositoryFlotas repoFlotas,RepositoryVuelos repoVuelos,RepositoryAviones repoAviones)
    {
        _repoFlotas = repoFlotas;
        _repoVuelos = repoVuelos;
        _repoAviones = repoAviones;
    }

    public async Task<IActionResult> Index(
        int numPag = 1,
        int numFilas = 10,
        int? idEstado = null,
        int? idAerolinea = 1,
        string? busqueda = null)
    {
        
        
        int? idAero = HttpContext.Session.GetInt32("AEROLINEA");
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;
        
        var (flotas, total)= await _repoFlotas.GetFlotasPaginadoAsync(numPag, numFilas,idEstado,idAero,busqueda);
        
        
        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["ESTADOS"] = await _repoAviones.GetEstadosAviones();
        
        return View(flotas);
    }
    
    [HttpPost]
    [ActionName("Index")]
    public IActionResult IndexPost(int numPag, int numFilas, int? idEstado, int? idAerolinea, string? busqueda)
    {
        return RedirectToAction("Index", new { numPag, numFilas, idEstado, idAerolinea, busqueda });
    }

}


