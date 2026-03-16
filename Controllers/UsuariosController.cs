using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
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
    
    [AllowAnonymous]
    public async Task<IActionResult> LogIn()
    {
        
        if (User.Identity.IsAuthenticated)
        {
            return RedirectToAction("Index","Dashboard"); 
        }
        
        return View();
    }    
    
    [HttpPost]
    [AllowAnonymous]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> LogIn(string email,string password)
    {
        
        VistaLoggedUser user=  await _repoUsuarios.LogInUserAsync(email, password);
      
      if (user != null)
      {
          
          ClaimsPrincipal userPrincipal= await CargarClaims(user);
          await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, userPrincipal);
          await CargarSession(user.IdUsuario);
          
          if (user.Rol == "Mecanico")
          {
              return RedirectToAction("Index", "Mantenimientos");
          }
          else 
          {
              return RedirectToAction("Index", "Dashboard");
          }
      }
         ModelState.AddModelError("", "Credenciales incorrectas. Revise su email y contraseña.");
          return View();      
          
    }


    private async Task<ClaimsPrincipal> CargarClaims(VistaLoggedUser user)
    {
        
        ClaimsIdentity identity = new ClaimsIdentity(
            CookieAuthenticationDefaults.AuthenticationScheme,
            ClaimTypes.Email, ClaimTypes.Role);

        Claim claimEmail = new Claim(ClaimTypes.Email, user.Email);
        identity.AddClaim(claimEmail);
          
        Claim claimId = new Claim(ClaimTypes.NameIdentifier, user.IdUsuario.ToString()); 
        identity.AddClaim(claimId);       
          
        Claim claimNombre = new Claim(ClaimTypes.Name, user.Nombre); 
        identity.AddClaim(claimNombre);         
          
        Claim claimAerolinea= new Claim("Aerolinea", user.IdAerolinea.ToString()); 
        identity.AddClaim(claimAerolinea);  
          
        Claim claimRole= new Claim(ClaimTypes.Role, user.Rol); 
        identity.AddClaim(claimRole);
          
        ClaimsPrincipal userPrincipal= new ClaimsPrincipal(identity);
        return userPrincipal;
    }
    
    [Authorize]
    [HttpGet]
    public async Task<IActionResult> Logout()
    {
        
        await BorrarSession();
        await HttpContext.SignOutAsync
            (CookieAuthenticationDefaults.AuthenticationScheme);
        return RedirectToAction("LogIn");
    }
    
    [AllowAnonymous]
    public IActionResult AccessDenied()
    {
        return View();
    }
    
    private async Task CargarSession(int idUsuario)
    {
        VistaLoggedUser loggedUser= await _repoUsuarios.GetLoggedUserData(idUsuario);

        await BorrarSession();
        HttpContext.Session.SetObject("LOGGED",idUsuario);
        HttpContext.Session.SetObject("ROL",loggedUser.IdRol);
        HttpContext.Session.SetObject("AEROLINEA",loggedUser.IdAerolinea);
        
    }

    private async Task BorrarSession()
    {
       // HttpContext.Session.Clear();

        HttpContext.Session.Remove("LOGGED");
        HttpContext.Session.Remove("ROL");
        HttpContext.Session.Remove("AEROLINEA");
    }

    private async Task ResetSession(int idUsuario)
    {
        VistaLoggedUser user=  await _repoUsuarios.GetLoggedUserData(idUsuario);
        
      ClaimsPrincipal userPrincipal= await CargarClaims(user);
      
      await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, userPrincipal);
      
        VistaLoggedUser loggedUser= await _repoUsuarios.GetLoggedUserData(idUsuario);

        HttpContext.Session.Remove("ROL");
        HttpContext.Session.Remove("AEROLINEA");
        HttpContext.Session.SetObject("ROL",loggedUser.IdRol);
        HttpContext.Session.SetObject("AEROLINEA",loggedUser.IdAerolinea);
    }
    
    
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Register()
    {
        List<Aerolinea> aerolineas = await _repoAerolineas.GetAerolineasAsync();
        List<RolUsuario> roles = await _repoUsuarios.GetRolesUsuariosAsync();

        ViewData["ROLES"] = roles;
        return View(aerolineas);
    }   
    [HttpPost]
   [Authorize("AdminOnly")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(string nombre,string apellidos,string email,int idAerolinea,string password,int idRol)
    {
        if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(apellidos) 
            || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            ModelState.AddModelError("", "Todos los campos son obligatorios.");
            return await CargarVistaRegister();
        }
        
        try
        {
            await _repoUsuarios.RegisterUserAsync(nombre, apellidos, email, idAerolinea, password, idRol);
            return RedirectToAction("Usuarios", "PanelAdmin");
        }
        catch (SqlException ex)
        {
            if (ex.Message.Contains("email") || ex.Message.Contains("UNIQUE") || ex.Message.Contains("duplicate"))
            {
                ModelState.AddModelError("Email", "Ya existe un usuario con ese email.");
            }
            else
            {
                ModelState.AddModelError("", "Error: " + ex.Message);
            }
            
            return await CargarVistaRegister();
        }
    }

    private async Task<IActionResult> CargarVistaRegister()
    {
        List<Aerolinea> aerolineas = await _repoAerolineas.GetAerolineasAsync();
        List<RolUsuario> roles = await _repoUsuarios.GetRolesUsuariosAsync();
        ViewData["ROLES"] = roles;
        return View("Register", aerolineas);
    }
    
    [HttpGet]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> Update(int idUsuario)
    {
        await CargarSelects();
        VistaAdministracionUsuarios usario = await _repoUsuarios.FindUsuarioAsync(idUsuario);
        return View(usario);
    }   
    
    
    [HttpPost]
    [Authorize("AdminOnly")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Update(VistaAdministracionUsuarios usuario)
    {
     
        if (!ModelState.IsValid)
        {
          await CargarSelects();
            return View(usuario);
        }
        
        await _repoUsuarios.UpdateUsuarioAsync(usuario.Id, usuario.Nombre, usuario.Apellidos, usuario.Rol, usuario.Aerolinea,usuario.Activo);
        
        return RedirectToAction("Usuarios","PanelAdmin");
    }
    
    [Authorize]
    public async Task<IActionResult> Configuracion(int idUsuario)
    {
        var usuario = await _repoUsuarios.FindUsuarioAsync(idUsuario);
        if (usuario == null)
            return RedirectToAction("Index", "Dashboard");
        return View(usuario); 
    }  
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ResetearSession(int idUsuario)
    {
            await ResetSession(idUsuario);
            
       return RedirectToAction("Index","Dashboard"); 
    }

    private async Task CargarSelects()
    {
        var aerolineas = await _repoAerolineas.GetAerolineasAsync();
        ViewBag.Aerolineas = new SelectList(aerolineas, "Nombre", "Nombre");
        
        var roles = await _repoUsuarios.GetRolesUsuariosAsync();
        ViewBag.Roles = new SelectList(roles, "Nombre", "Nombre");
        
    }
    
    
    
  
}