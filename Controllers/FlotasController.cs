using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;
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
        int? idAerolinea=-1,
        string? busqueda = null)
    {
        // int idAero = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAero= ClaimsExtensions.GetAerolineaId(User);
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;
        
        var (flotas, total)= await _repoFlotas.GetFlotasPaginadoAsync(numPag, numFilas,idEstado,idAero,busqueda);
        
        ViewData["TOTAL_REGISTROS"] = total;
        ViewData["ESTADOS"] = await _repoAviones.GetEstadosAviones();
        ViewData["MODELOS"] = await _repoAviones.GetModelosAvionAsync();
        ViewData["AEROPUERTOS"] = await _repoAviones.GetAeropuertosAsync();
        
        return View(flotas);
    }
    
    [HttpPost]
    [ActionName("Index")]
    public IActionResult IndexPost(int numPag, int numFilas, int? idEstado, int? idAerolinea, string? busqueda)
    {
        return RedirectToAction("Index", new { numPag, numFilas, idEstado, idAerolinea, busqueda });
    }

    [HttpPost]
    public async Task<IActionResult> Create(string matricula, int modeloId, int aeropuertoId)
    {
        var errores = new List<FormError>();

        if (string.IsNullOrWhiteSpace(matricula))
            errores.Add(new FormError { Field = "matricula", Message = "La matrícula es obligatoria." });
        if (modeloId <= 0)
            errores.Add(new FormError { Field = "modeloId", Message = "Debe seleccionar un modelo." });
        if (aeropuertoId <= 0)
            errores.Add(new FormError { Field = "aeropuertoId", Message = "Debe seleccionar un aeropuerto base." });

        if (errores.Count > 0)
            return Json(new { success = false, errors = errores });

        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var result = await _repoAviones.CreateAvionAsync(matricula.Trim().ToUpper(), modeloId, idAerolinea, aeropuertoId,0,0);

        if (result.Success)
            return Json(new { success = true, message = result.Message });

        errores.Add(new FormError { Field = "", Message = result.Message });
        return Json(new { success = false, errors = errores });
    }

    [HttpPost]
    public async Task<IActionResult> Update(int idAvion, int estadoId, int aeropuertoId)
    {
        if (idAvion <= 0)
            return Json(new { success = false, message = "ID de aeronave inválido." });

        var result = await _repoAviones.UpdateAvionAsync(idAvion, estadoId, aeropuertoId);
        return Json(new { success = result.Success, message = result.Message });
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int idAvion)
    {
        if (idAvion <= 0)
            return Json(new { success = false, message = "ID de aeronave inválido." });

        var result = await _repoAviones.DeleteAvionAsync(idAvion);
        return Json(new { success = result.Success, message = result.Message });
    }
}
