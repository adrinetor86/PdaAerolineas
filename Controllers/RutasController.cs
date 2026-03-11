using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models.FormViews;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

[Authorize(Roles="Administrador, Gerente")]
public class RutasController : Controller
{
    private RepositoryRutas _repoRutas;

    public RutasController(RepositoryRutas repoRutas)
    {
        _repoRutas = repoRutas;
    }

    public async Task<IActionResult> Index()
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
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
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        if (idRuta <= 0)
            return Json(new { success = false, errors = new[] { new FormError { Field = "idRuta", Message = "Debe seleccionar una ruta." } } });

        var result = await _repoRutas.AsignarRutaAsync(idRuta, idAerolinea, precioBase, frecuenciaSemanal);
        return Json(new { success = result.Success, message = result.Message });
    }

    [HttpPost]
    public async Task<IActionResult> Desactivar(int idRuta)
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoRutas.DesactivarRutaAsync(idRuta, idAerolinea);
        return Json(new { success = result.Success, message = result.Message });
    }

    [HttpPost]
    public async Task<IActionResult> Reactivar(int idRuta)
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoRutas.ReactivarRutaAsync(idRuta, idAerolinea);
        return Json(new { success = result.Success, message = result.Message });
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