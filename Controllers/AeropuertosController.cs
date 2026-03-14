using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;
using PdaAerolineas.Services;

namespace PdaAerolineas.Controllers;

public class AeropuertosController : Controller
{
    private RepositoryAeropuertos _repoAeropuertos;
    private ServiceMetar _serviceMetar;
    public AeropuertosController(RepositoryAeropuertos repoAeropuertos, ServiceMetar serviceMetar)
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

    [HttpGet]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Create()
    {
        await CargarSelects();
        return View(new Aeropuerto());
    }
    
    private async Task CargarSelects()
    {
        var paises = await _repoAeropuertos.GetPaisesAsync();
        ViewBag.Paises = new SelectList(paises, "IdPais", "Nombre");

    }
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Create(Aeropuerto aeropuerto)
    {
        if (!ModelState.IsValid)
        {
            await CargarSelects();
            return View(aeropuerto);
        }

        var result = await _repoAeropuertos.CreateAeropuertoAsync(
            aeropuerto.Nombre,
            aeropuerto.Cod_Iata.ToUpperInvariant(),
            aeropuerto.Cod_Icao.ToUpperInvariant(),
            aeropuerto.Ciudad,
            aeropuerto.IdPais,
            aeropuerto.Latitud,
            aeropuerto.Longitud);

        if (!result.Success)
        {
            ModelState.AddModelError("", result.Message);
            await CargarSelects();
            return View(aeropuerto);
        }

        TempData["SUCCESS"] = result.Message;
        
        return RedirectToAction("Aeropuertos", "PanelAdmin");
    }

    [HttpGet]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Update(int idAeropuerto)
    {
        var aeropuerto = await _repoAeropuertos.FindAeropuertoAsync(idAeropuerto);
        if (aeropuerto == null) return RedirectToAction("Aeropuertos", "PanelAdmin");

        await CargarSelects();
        return View(aeropuerto);
    }
    

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Update(Aeropuerto aeropuerto)
    {
        if (!ModelState.IsValid)
        {
            await CargarSelects();
            return View(aeropuerto);
        }

        var result = await _repoAeropuertos.UpdateAeropuertoAsync(
            aeropuerto.IdAeropuerto,
            aeropuerto.Nombre,
            aeropuerto.Cod_Iata.ToUpperInvariant(),
            aeropuerto.Cod_Icao.ToUpperInvariant(),
            aeropuerto.Ciudad,
            aeropuerto.IdPais,
            aeropuerto.Latitud,
            aeropuerto.Longitud);

        if (!result.Success)
        {
            ModelState.AddModelError("", result.Message);
            await CargarSelects();
            return View(aeropuerto);
        }

        TempData["SUCCESS"] = result.Message;
        return RedirectToAction("Aeropuertos", "PanelAdmin");
    }

}