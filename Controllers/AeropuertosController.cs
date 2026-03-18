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
    
    public async Task<IActionResult> Aeropuertos(int numPag = 1, int numFilas = 10, string? busqueda = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;

        var (lista, total) = await _repoAeropuertos.GetAeropuertosPaginadosAsync(numPag, numFilas, busqueda ?? string.Empty);
        int totalPaginas = (int)Math.Ceiling(total / (double)numFilas);

        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["PAGINA_ACTUAL"] = numPag;
        ViewData["TOTAL_PAGINAS"] = totalPaginas;
        ViewData["REGISTROS_PAG"] = numFilas;
        ViewData["BUSQUEDA"] = busqueda;

        return View(lista);
    }
    
    
    public async Task<IActionResult> Clima(string iata)
    {
        if (string.IsNullOrEmpty(iata)) return RedirectToAction("Aeropuertos");

        var clima = await _serviceMetar.GetMetarAsync(iata);
    
        if (clima == null)
        {
       
            return RedirectToAction("Aeropuertos");
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
        
        return RedirectToAction("Aeropuertos", "PanelAdmin");
    }

}