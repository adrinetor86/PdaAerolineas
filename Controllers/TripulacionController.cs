using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;
using Microsoft.AspNetCore.Mvc.Rendering;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;

namespace PdaAerolineas.Controllers;

// TODO PASAR LOS ROLES TAMBIEN COMO AEROLINEAS
[Authorize("AdminOrGestor")]
public class TripulacionController : Controller
{
    private RepositoryTripulantes _repoTripulantes;
    private RepositoryAerolineas _repoAerolineas;

    public TripulacionController(RepositoryTripulantes repositoryTripulantes,RepositoryAerolineas repoAerolineas)
    {
        _repoTripulantes = repositoryTripulantes;
        _repoAerolineas = repoAerolineas;
    }
    
    [HttpGet]
    public async Task<IActionResult> Index(
        [FromQuery] int numPag = 1,
        [FromQuery] int numFilas = 10,
        [FromQuery] string? rol = null,
        [FromQuery] bool? activo = null,
        [FromQuery] string? busqueda = null)
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAerolinea= ClaimsExtensions.GetAerolineaId(User);

        var resultado = await _repoTripulantes.GetTripulantesPaginadosAsync(numPag, numFilas, rol, idAerolinea, activo, busqueda);

        ViewBag.Roles = await _repoTripulantes.GetRolesAsync();
        
        var aerolineas = await _repoAerolineas.GetAerolineasAsync();
        ViewBag.Aerolineas = aerolineas;
        
        ViewData["TOTAL_REGISTROS"] = resultado.TotalRegistros;

        return View(resultado.Tripulantes);
    }
    
    
    public async Task<IActionResult> Update(int idTripulante)
    {
      Tripulante tripulante = await _repoTripulantes.FindTripulanteAsync(idTripulante);
      
      if (tripulante == null)
      {
          return NotFound();
      }

      var aerolineas = await _repoAerolineas.GetAerolineasAsync(); 
      
      ViewBag.Roles = await _repoTripulantes.GetRolesAsync();

      ViewBag.Aerolineas = aerolineas.Select(a => new SelectListItem
      {
          Value = a.IdAerolinea.ToString(), 
          Text = a.Nombre,                  
          Selected = (a.IdAerolinea == tripulante.IdAerolinea)
      }).ToList();

        return View(tripulante);
    }   
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Update(Tripulante tripulante)
    {
        
        if (!ModelState.IsValid)
        {
            return View(tripulante);
        }
        
        await _repoTripulantes.UpdateTripulantesAsync
            (tripulante.IdTripulante,tripulante.IdAerolinea,tripulante.Nombre,
             tripulante.Apellido,tripulante.Rol,tripulante.Activo);
        
        return RedirectToAction("Index");
    }


    [Authorize(Roles="Administrador,Gerente")]
    public async Task<IActionResult> Create()
    {
        ViewBag.Roles = await _repoTripulantes.GetRolesAsync();

        var aerolineas = await _repoAerolineas.GetAerolineasAsync(); 
        ViewBag.Aerolineas = aerolineas.Select(a => new SelectListItem
        {
            Value = a.IdAerolinea.ToString(), 
            Text = a.Nombre 
        }).ToList();
        
        return View();
    }   
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles="Administrador,Gerente")]
    public async Task<IActionResult> Create(int idAerolinea,string nombre,string apellido,string rol,bool activo)
    {
        
        if (!ModelState.IsValid)
        {
            var aerolineas = await _repoAerolineas.GetAerolineasAsync(); 
            ViewBag.Aerolineas = aerolineas.Select(a => new SelectListItem
            {
                Value = a.IdAerolinea.ToString(), 
                Text = a.Nombre,
                Selected = (a.IdAerolinea == idAerolinea)
            }).ToList();
        
            return View();
        }
        await _repoTripulantes.CreateTripulantesAsync(idAerolinea, nombre, apellido, rol, activo);
    
        return RedirectToAction("Index");
        
    }
    
 
}