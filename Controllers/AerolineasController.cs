using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class AerolineasController : Controller
{

    private RepositoryAerolineas _repoAerolineas;


    public AerolineasController(RepositoryAerolineas repoAerolineas)
    {
        _repoAerolineas = repoAerolineas;
    }
    
    // GET
    public IActionResult Index()
    {
        return View();
    }

    [Authorize("AdminOnly")]
    public async Task<IActionResult> Register()
    {
        return View();
    }   
    
    [Authorize("AdminOnly")]
    [HttpPost]
    [ValidateAntiForgeryToken]
      public async Task<IActionResult> Register(string nombre,IFormFile? logo,string codIata)
      {

          if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(codIata))
          {
              ModelState.AddModelError("", "Nombre y Código IATA son obligatorios.");
              return View();
          }
          
          if (logo != null)
          {
              var extensionesPermitidas = new[] { ".jpg", ".jpeg", ".png", ".svg", ".webp" };
              var extension = Path.GetExtension(logo.FileName).ToLower();
              if (!extensionesPermitidas.Contains(extension))
              {
                  ModelState.AddModelError("Logo", "Formato de imagen no válido.");
                  return View();
              }
          }
          
          try {
              await _repoAerolineas.CreateAerolineaAsync(nombre, logo, codIata);
              return RedirectToAction("Aerolineas","PanelAdmin");
          }
          catch (SqlException ex) {
       
              if (ex.Message.Contains("existe la aerolinea")) {
                  ModelState.AddModelError("Nombre", ex.Message);
              }
              else if (ex.Message.Contains("codigo IATA")) {
                  ModelState.AddModelError("Cod_Iata", ex.Message);
              }
              else {
                  ModelState.AddModelError("", "Error: " + ex.Message);
              }
              return View();
          }
          
    }

    [Authorize("AdminOnly")]
    public async Task<IActionResult> Update(int idAerolinea)
    {
        Aerolinea aerolinea = await _repoAerolineas.FindAerolineaAsync(idAerolinea);

        return View(aerolinea);
    }  
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Update(int idAerolinea,string nombre,IFormFile? logo, string Cod_Iata)
    {
        if (logo != null)
        {
            var extensionesPermitidas = new[] { ".jpg", ".jpeg", ".png", ".svg", ".webp" };
            var extension = Path.GetExtension(logo.FileName).ToLower();
            if (!extensionesPermitidas.Contains(extension))
            {
                ModelState.AddModelError("Logo", "Formato de imagen no válido.");
                return View();
            }
        }
          
        try {
            await _repoAerolineas.UpdateAerolineaAsync(idAerolinea, nombre, logo, Cod_Iata);
            return RedirectToAction("Aerolineas","PanelAdmin");
        }
        catch (SqlException ex) {
       
            if (ex.Message.Contains("existe la aerolinea")) {
                ModelState.AddModelError("Nombre", ex.Message);
            }
            else if (ex.Message.Contains("codigo IATA")) {
                ModelState.AddModelError("Cod_Iata", ex.Message);
            }
            else {
                ModelState.AddModelError("", "Error: " + ex.Message);
            }
            return View();
        }
        
    }
}