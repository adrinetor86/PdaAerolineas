using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

[SessionCheck]
public class MantenimientosController : Controller
{

    private RepositoryMantenimientos _repoMantenimientos;
    private RepositoryVuelos _repoVuelos;
    private RepositoryAviones _repoAviones;

    public MantenimientosController(RepositoryMantenimientos repoMantenimientos,RepositoryVuelos repoVuelos,
        RepositoryAviones repoAviones)
    {
        _repoMantenimientos = repoMantenimientos;
        _repoVuelos = repoVuelos;
        _repoAviones = repoAviones;
    }
    
    
    //TODO CAMBIAR EL HARDCODE AEROLINEA
    public async Task<IActionResult> Index(
        int    numPag        = 1,
        int    numFilas      = 10,
        string? estado       = null,
        DateTime? fechaProgramada = null,
        string? busqueda     = null
        )
    {

       int idAero= HttpContext.Session.GetObject<int>("AEROLINEA");
        
        var (mantenimientos, total) =
            await _repoMantenimientos.GetMantenimientosPaginadosAsync(numPag, numFilas, idAero,estado, fechaProgramada, busqueda);
        ViewData["TOTAL_REGISTROS"] = total;
        
        return View(mantenimientos);
    }
    
    
    
    public async Task<IActionResult> Programar()
    {
        //TODO QUITAR EL HARD
        ViewData["AVIONES"] = await _repoAviones.GetVistaAvionesAsync(1);
        ViewData["TIPOSMANTENIMIENTO"] = await _repoMantenimientos.GetTiposMantenimientoAsync();
        return View();
    }
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Programar(int avion,int tipoMantenimiento,DateTime fechaProgramada)
    {
        
        //TODO QUITAR EL HARD
        ViewData["AVIONES"] = await _repoAviones.GetVistaAvionesAsync(1);
        ViewData["TIPOSMANTENIMIENTO"] = await _repoMantenimientos.GetTiposMantenimientoAsync();
        
        await _repoMantenimientos.ProgramarMantenimientoAsync(avion, tipoMantenimiento, fechaProgramada);
        
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Update(int idMantenimiento)
    {
        
        VistaMantenimientos? mantenimiento = await _repoMantenimientos.GetMantenimientoByIdAsync(idMantenimiento);
        if (mantenimiento is null) return NotFound();
        
        return View(mantenimiento);
    }    
    
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Update(int idMantenimiento,string descripcion)
    {
        await _repoMantenimientos.UpdateDescripcionAsync(idMantenimiento, descripcion);
        return RedirectToAction("Index");
    }
    
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> IniciarMantenimiento(int idMantenimiento)
    {
        var (ok, mensaje) = await _repoMantenimientos.IniciarMantenimientoAsync(idMantenimiento);
    
        return Ok(new { ok, mensaje });
    }
    
    
    
}