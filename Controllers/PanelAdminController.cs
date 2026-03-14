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
    
    public PanelAdminController(RepositoryUsuarios repositoryUsuarios,RepositoryAerolineas repoAerolineas,RepositoryRutas repoRutas, RepositoryAeropuertos repoAeropuertos)
    {
        _repoUsuarios = repositoryUsuarios;
        _repoAerolineas = repoAerolineas;
        _repoRutas = repoRutas;
        _repoAeropuertos = repoAeropuertos;
    }
    public IActionResult Index()
    {
        return View();
    }
    
    public async Task<IActionResult> Usuarios()
    {
        List<VistaAdministracionUsuarios> usuarios = await _repoUsuarios.GetUsuariosAsync();

        return View(usuarios);
    }    
    
    public async Task<IActionResult> Aerolineas()
    {
        List<Aerolinea> aerolineas = await _repoAerolineas.GetAerolineasAsync();

        return View(aerolineas);
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