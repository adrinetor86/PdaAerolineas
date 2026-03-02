using Microsoft.AspNetCore.Mvc;

namespace PdaAerolineas.Controllers;

public class AeropuertosController : Controller
{
    // GET
    public IActionResult Index()
    {
        return View();
    }
}