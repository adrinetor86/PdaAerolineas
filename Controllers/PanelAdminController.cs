using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;


[OnlyAdmin]
public class PanelAdminController : Controller
{
    
    private RepositoryUsuarios _repoUsuarios;
    private RepositoryAerolineas _repoAerolineas;
    
    public PanelAdminController(RepositoryUsuarios repositoryUsuarios,RepositoryAerolineas repoAerolineas)
    {
        _repoUsuarios = repositoryUsuarios;
        _repoAerolineas = repoAerolineas;
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
    
}