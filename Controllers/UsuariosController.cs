using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
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


    public async Task<IActionResult> Index()
    {
        return View();
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
          
              HttpContext.Session.SetObject("LOGGED",user.IdUsusario);
              HttpContext.Session.SetObject("ROL",loggedUser.IdRol);
              HttpContext.Session.SetObject("AEROLINEA",loggedUser.IdAerolinea);
              return RedirectToAction("Index","Dashboard"); 
      }
      
      return View();
    }  
    
    
    public async Task<IActionResult> Register()
    {
        List<Aerolinea> aerolineas = await _repoAerolineas.GetAerolineasAsync();
        List<RolUsuario> roles = await _repoUsuarios.GetRolesUsuariosAsync();

        ViewData["ROLES"] = roles;
        return View(aerolineas);
    }   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(string nombre,string apellidos,string email,int idAerolinea,string password,int idRol)
    {
        await _repoUsuarios.RegisterUserAsync(nombre,apellidos,email, idAerolinea, password,idRol);
        return RedirectToAction("LogIn");
    }

    
    [SessionCheck]
    public async Task<IActionResult> LogOut()
    {

            HttpContext.Session.Remove("LOGGED");
            HttpContext.Session.Remove("ROL");
            HttpContext.Session.Remove("AEROLINEA");
            return RedirectToAction("LogIn","Usuarios");             
    }

    [HttpGet]
    public async Task<IActionResult> Update(int idUsuario)
    {

        VistaAdministracionUsuarios usario = await _repoUsuarios.FindUsuarioAsync(idUsuario);
        return View(usario);
    }   
    [HttpPost]
    public async Task<IActionResult> Update(int idUsuario,string nombre,string apellidos,string rol, bool activo)
    {

        await _repoUsuarios.UpdateUsuarioAsync(idUsuario, nombre, apellidos, rol, activo);
        return RedirectToAction("Usuarios","PanelAdmin");
    }
    
  
}