using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class UsuariosController : Controller
{

    private RepositoryUsuarios _repoUsuarios;
    private RepositoryAerolineas _repoAerolineas;


    public UsuariosController(RepositoryUsuarios repositoryUsuarios,RepositoryAerolineas repoAerolineas)
    {
        _repoUsuarios = repositoryUsuarios;
        _repoAerolineas = repoAerolineas;
    }

    
    public async Task<IActionResult> LogIn()
    {

        if (HttpContext.Session.GetString("LOGGED") != null)
        {
            return RedirectToAction("Index","Dashboard"); 
        }
        return View();
    }    
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> LogIn(string email,string password)
    {
        HttpContext.Session.Clear();
        Usuario user=  await _repoUsuarios.LogInUserAsync(email, password);
      
      if (user != null)
      {
          VistaLogedUser loggedUser= await _repoUsuarios.GetLoggedUserData(user.IdUsusario);
          
              HttpContext.Session.SetInt32("LOGGED",user.IdUsusario);
              HttpContext.Session.SetInt32("ROL",loggedUser.IdRol);
              
              return RedirectToAction("Index","Dashboard"); 
      }
      
      return View();
    }  
    
    
    public async Task<IActionResult> Register()
    {
        List<Aerolinea> aerolineas = await _repoAerolineas.GetAerolineasAsync();
        return View(aerolineas);
    }   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(string nombre,string apellidos,string email,int idAerolinea,string password,int idRol)
    {
        await _repoUsuarios.RegisterUserAsync(nombre,apellidos,email, idAerolinea, password);
        return RedirectToAction("LogIn");
    }


    public async Task<IActionResult> LogOut()
    {
        if (HttpContext.Session.GetString("LOGGED") == null)
        {
            return RedirectToAction("Index","Dashboard"); 
        }

            HttpContext.Session.Remove("LOGGED");
            return RedirectToAction("Index","Dashboard");             
        

    }
}