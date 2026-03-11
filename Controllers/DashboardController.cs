using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

// [SessionCheck]
[Authorize]
public class DashboardController : Controller
{

    private RepositoryFlotas _repoFlotas;
    private RepositoryAerolineas _repoAerolineas;
    private readonly RepositoryDashboard _repoDashboard;

    public DashboardController(RepositoryFlotas repoFlotas,RepositoryAerolineas repoAerolineas,RepositoryDashboard repoDashboard)
    {
        _repoFlotas = repoFlotas;
        _repoAerolineas = repoAerolineas;
        _repoDashboard = repoDashboard;

    }
    
    public async Task<IActionResult> Index()
    {
        // int idAerolinea = HttpContext.Session.GetObject<int>("AEROLINEA");
        int idAaerolinea= ClaimsExtensions.GetAerolineaId(User);
        var dashboard = await _repoDashboard.GetDashboardDataAsync(idAaerolinea);
            
        return View(dashboard);
    }
    
}