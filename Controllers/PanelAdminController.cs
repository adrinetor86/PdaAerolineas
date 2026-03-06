using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;



public class PanelAdminController : Controller
{
    
    
    private RepositoryUsuarios _repoUsuarios;


    
    public PanelAdminController(RepositoryUsuarios repositoryUsuarios)
    {
        _repoUsuarios = repositoryUsuarios;

    }
    [OnlyAdmin]
    public IActionResult Index()
    {
        return View();
    }
    
    [OnlyAdmin]
    public async Task<IActionResult> Usuarios()
    {
        List<VistaAdministracionUsuarios> usuarios = await _repoUsuarios.GetUsuariosAsync();

        return View(usuarios);
    }
}