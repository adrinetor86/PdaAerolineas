using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class MantenimientosController : Controller
{

    private RepositoryMantenimientos _repo;

    public MantenimientosController(RepositoryMantenimientos repo)
    {
        _repo = repo;
    }
    
    
    public async Task<IActionResult> Index()
    {
        List<VistaMantenimientos> mantenimientos = await _repo.GetMantenimientosAsync();
        
        return View(mantenimientos);
    }
}