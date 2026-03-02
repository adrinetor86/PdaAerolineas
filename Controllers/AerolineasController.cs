using Microsoft.AspNetCore.Mvc;
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
}