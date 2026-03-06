using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

[SessionCheck]
public class DashboardController : Controller
{

    private RepositoryFlotas _repoFlotas;
    private RepositoryAerolineas _repoAerolineas;

    public DashboardController(RepositoryFlotas repoFlotas,RepositoryAerolineas repoAerolineas)
    {
        _repoFlotas = repoFlotas;
        _repoAerolineas = repoAerolineas;
    }

    public async Task<IActionResult> Index()
    {
        
        int idAerolinea = HttpContext.Session.GetInt32("AEROLINEA") ?? 1;

        VistaDashboard data = await _repoAerolineas.GetDatosDashboardAsync(idAerolinea);
        
        return View(data);
    }
    
    
}