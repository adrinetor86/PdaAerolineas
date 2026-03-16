using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

[Authorize("AdminOrGestor")]
public class RutasController : Controller
{
    private RepositoryRutas _repoRutas;
    private RepositoryAeropuertos _repoAeropuertos;

    public RutasController(RepositoryRutas repoRutas, RepositoryAeropuertos repoAeropuertos)
    {
        _repoRutas = repoRutas;
        _repoAeropuertos = repoAeropuertos;
    }

    public async Task<IActionResult> Index()
    {
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var rutasAerolinea = await _repoRutas.GetRutasAerolineaAsync(idAerolinea);
        var rutasMapa = await _repoRutas.GetRutasMapaAerolineaAsync(idAerolinea);
        var rutasDisponibles = await _repoRutas.GetRutasNoOperadasAsync(idAerolinea);

        ViewData["RUTAS_MAPA"] = rutasMapa;
        ViewData["RUTAS_DISPONIBLES"] = rutasDisponibles;

        return View(rutasAerolinea);
    }

    
    [HttpPost]
    public async Task<IActionResult> Asignar(int idRuta, decimal? precioBase, int? frecuenciaSemanal)
    {
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        if (idRuta <= 0)
            return Json(new { success = false, errors = new[] { new FormError { Field = "idRuta", Message = "Debe seleccionar una ruta." } } });

        var result = await _repoRutas.AsignarRutaAsync(idRuta, idAerolinea, precioBase, frecuenciaSemanal);
        return Json(new { success = result.Success, message = result.Message });
    }

    [HttpPost]
    public async Task<IActionResult> Desactivar(int idRuta)
    {
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoRutas.DesactivarRutaAsync(idRuta, idAerolinea);
        return Json(new { success = result.Success, message = result.Message });
    }

    [HttpPost]
    public async Task<IActionResult> Reactivar(int idRuta)
    {

        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoRutas.ReactivarRutaAsync(idRuta, idAerolinea);
        return Json(new { success = result.Success, message = result.Message });
    }
    
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Create()
    {
        var aeropuertos = await _repoAeropuertos.GetAeropuertosAsync();
        return View(aeropuertos);
    }  
    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Create(int aeropuertoOrigen, int aeroPuertoDestino, int distancia)
    {
        var aeropuertos = await _repoAeropuertos.GetAeropuertosAsync();
        var errores = new List<FormError>();

        if (aeropuertoOrigen <= 0)
            errores.Add(new FormError { Field = "aeropuertoOrigen", Message = "Seleccione un aeropuerto de origen." });
        if (aeroPuertoDestino <= 0)
            errores.Add(new FormError { Field = "aeroPuertoDestino", Message = "Seleccione un aeropuerto de destino." });
        if (aeropuertoOrigen == aeroPuertoDestino)
            errores.Add(new FormError { Field = "aeroPuertoDestino", Message = "El origen y destino no pueden ser iguales." });
        if (distancia <= 0)
            errores.Add(new FormError { Field = "distancia", Message = "La distancia debe ser mayor que cero." });

        if (errores.Any())
        {
            ViewData["ERRORES"] = errores;
            return View(aeropuertos);
        }

        var result = await _repoRutas.CreateRutaAsync(aeropuertoOrigen, aeroPuertoDestino, distancia);
        if (!result.Success)
        {
            errores.Add(new FormError { Field = "", Message = result.Message });
            ViewData["ERRORES"] = errores;
            return View(aeropuertos);
        }

        TempData["SUCCESS"] = result.Message;
        return RedirectToAction("Rutas", "PanelAdmin");
    }

    [HttpPost]
    public async Task<IActionResult> Actualizar(int idRuta, decimal? precioBase, int? frecuenciaSemanal)
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoRutas.UpdateRutaAerolineaAsync(idRuta, idAerolinea, precioBase, frecuenciaSemanal);
        return Json(new { success = result.Success, message = result.Message });
    }
}