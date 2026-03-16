using System;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;


[Authorize("AdminOnly")]
public class PanelAdminController : Controller
{
    
    private RepositoryUsuarios _repoUsuarios;
    private RepositoryAerolineas _repoAerolineas;
    private RepositoryRutas _repoRutas;
    private RepositoryAeropuertos _repoAeropuertos;
    private RepositoryAviones _repoAviones;
    
    public PanelAdminController(RepositoryUsuarios repositoryUsuarios,RepositoryAerolineas repoAerolineas,
        RepositoryRutas repoRutas, RepositoryAeropuertos repoAeropuertos,RepositoryAviones repoAviones)
    {
        _repoUsuarios = repositoryUsuarios;
        _repoAerolineas = repoAerolineas;
        _repoRutas = repoRutas;
        _repoAeropuertos = repoAeropuertos;
        _repoAviones = repoAviones;
    }
    public IActionResult Index()
    {
        return View();
    }
    
    public async Task<IActionResult> Aerolineas(int numPag = 1, int numFilas = 10, string? busqueda = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;

        var (aerolineas, total) = await _repoAerolineas.GetAerolineasPaginadasAsync(numPag, numFilas, busqueda);
        int totalPaginas = (int)Math.Ceiling(total / (double)numFilas);

        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["PAGINA_ACTUAL"]   = numPag;
        ViewData["TOTAL_PAGINAS"]   = totalPaginas;
        ViewData["REGISTROS_PAG"]   = numFilas;
        ViewData["BUSQUEDA"]        = busqueda;

        return View(aerolineas);
    }

    public async Task<IActionResult> ModeloAviones()
    {
        List<ModeloAvion> modelos = await _repoAviones.GetModelosAvionAsync();

        return View(modelos);
    }

    [HttpGet]
    public IActionResult CreateModeloAvion()
    {
        return View(new ModeloAvion());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> CreateModeloAvion(ModeloAvion modelo)
    {
        if (string.IsNullOrWhiteSpace(modelo.Fabricante))
            ModelState.AddModelError(nameof(modelo.Fabricante), "El fabricante es obligatorio.");
        if (string.IsNullOrWhiteSpace(modelo.Nombre))
            ModelState.AddModelError(nameof(modelo.Nombre), "El modelo es obligatorio.");
        if (modelo.Capacidad <= 0)
            ModelState.AddModelError(nameof(modelo.Capacidad), "La capacidad debe ser mayor que cero.");
        if (modelo.Alcance <= 0)
            ModelState.AddModelError(nameof(modelo.Alcance), "El alcance debe ser mayor que cero.");

        if (!ModelState.IsValid)
            return View(modelo);

        var (success, message) = await _repoAviones.CreateModeloAvionAsync(
            modelo.Fabricante.Trim(),
            modelo.Nombre.Trim(),
            modelo.Capacidad,
            modelo.Alcance);

        if (!success)
        {
            ModelState.AddModelError(string.Empty, message);
            return View(modelo);
        }

        TempData["SUCCESS"] = message;
        return RedirectToAction("ModeloAviones");
    }

    public async Task<IActionResult> Usuarios(int numPag = 1, int numFilas = 10,
        string? busqueda = null, int? aerolineaId = null, bool? activo = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;

        var (usuarios, total) = await _repoUsuarios.GetUsuariosPaginadosAsync(numPag, numFilas, busqueda, aerolineaId, activo);
        int totalPaginas = (int)Math.Ceiling(total / (double)numFilas);

        // Para el select de aerolíneas en el filtro
        ViewData["AEROLINEAS"]      = await _repoAerolineas.GetAerolineasAsync();
        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["PAGINA_ACTUAL"]   = numPag;
        ViewData["TOTAL_PAGINAS"]   = totalPaginas;
        ViewData["REGISTROS_PAG"]   = numFilas;
        ViewData["BUSQUEDA"]        = busqueda;
        ViewData["AEROLINEA_ID"]    = aerolineaId;
        ViewData["ACTIVO"]          = activo;

        return View(usuarios);
    }
    
  
    public async Task<IActionResult> Rutas(int numPag = 1, int numFilas = 10, string? busqueda = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;

        var (rutas, total) = await _repoRutas.GetRutasPaginadasAsync(numPag, numFilas, busqueda);
        int totalPaginas = (int)Math.Ceiling(total / (double)numFilas);

        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["PAGINA_ACTUAL"] = numPag;
        ViewData["TOTAL_PAGINAS"] = totalPaginas;
        ViewData["REGISTROS_PAG"] = numFilas;
        ViewData["BUSQUEDA"] = busqueda;

        return View(rutas);
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
}