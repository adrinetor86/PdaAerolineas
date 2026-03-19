using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using PdaAerolineas.Extensions;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

[Authorize("AdminOrGestor")]
public class VuelosController : Controller
{
    private RepositoryVuelos _repoVuelos;
    private RepositoryTripulantes _repoTripulantes;
    private RepositoryRetrasos _repoRetrasos;
    private RepositoryAviones _repoAviones;
    private IMemoryCache _memoryCache;
    private readonly RepositoryCombustible _repoCombustible;

    public VuelosController(RepositoryVuelos repoVuelos, RepositoryTripulantes repoTripulantes,
        RepositoryRetrasos repoRetrasos,IMemoryCache memoryCache,RepositoryAviones repoAviones,
        RepositoryCombustible repoCombustible)
    {
        _repoVuelos = repoVuelos;
        _repoTripulantes = repoTripulantes;
        _repoRetrasos = repoRetrasos;
        _repoAviones = repoAviones;
        _memoryCache = memoryCache;
        _repoCombustible = repoCombustible;
    }
    
    public async Task<IActionResult> Index(
        int numPag = 1,
        int numFilas = 10,
        int? idEstado = null,
        int? idAerolinea = -1,
        DateTime? fechaSalida = null,
        string? busqueda = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;
        
        int idAero= ClaimsExtensions.GetAerolineaId(User);

        
        var (vuelos, total) = await _repoVuelos.GetVuelosPaginadosConTotalAsync(numPag, numFilas, idEstado, idAero, fechaSalida, busqueda);
        ViewData["TOTAL_REGISTROS"] = total;

        ViewData["ESTADOS"] = await _repoVuelos.GetEstadosVuelosAync();
        
        ViewData["AVIONES"] = await _repoVuelos.GetAvionesConRutasDisponiblesAsync(idAero);
        ViewData["NUMEROVUELOS"] = await _repoVuelos.GetNumeroVueloByAerolineaAsync(idAero);

        return View(vuelos);
    }

    [HttpPost]
    [ActionName("Index")]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOrGestor")]
    public IActionResult IndexPost(int numPag, int numFilas, int? idEstado, int? idAerolinea, DateTime? fechaSalida, string? busqueda)
    {
        return RedirectToAction("Index", new { numPag, numFilas, idEstado, idAerolinea, fechaSalida, busqueda });
    }

    [HttpPost]
    public async Task<IActionResult> GetRutasPorAvion(int idAvion)
    {
        //CONTROL ERRORES
        var rutas = await _repoVuelos.GetRutasDisponibles(idAvion);
        return Json(rutas);
    }


    
    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize("AdminOrGestor")]
    public async Task<IActionResult> Create(string? numeroVuelo, string? numeroVueloNuevo, int idRuta, int avion, DateTime fechaSalida,
        string puerta)
    {
        var errores = new List<FormError>();
        
        string finalNumeroVuelo = !string.IsNullOrWhiteSpace(numeroVueloNuevo) 
            ? numeroVueloNuevo 
            : numeroVuelo;

        if (string.IsNullOrWhiteSpace(finalNumeroVuelo))
            errores.Add(new FormError { Field = "numeroVuelo", Message = "El número de vuelo es obligatorio." });
        if (avion <= 0)
            errores.Add(new FormError { Field = "avion", Message = "Debe seleccionar una aeronave." });
        if (idRuta <= 0)
            errores.Add(new FormError { Field = "idRuta", Message = "Debe seleccionar una ruta de destino." });
        if (fechaSalida == default)
            errores.Add(new FormError { Field = "FechaSalida", Message = "La fecha de salida es obligatoria." });

        if (errores.Count > 0)
            return Json(new { success = false, errors = errores });
        
        
        int idAerolinea = ClaimsExtensions.GetAerolineaId(User);    

        try
        {
            await _repoVuelos.CreateVueloAsync(finalNumeroVuelo, idAerolinea, idRuta,
                avion, fechaSalida, puerta);

            return Json(new { success = true, message = "Vuelo creado correctamente." });
        }
        catch (Microsoft.Data.SqlClient.SqlException ex)
        {
            if (ex.Message.Contains("numero") || ex.Message.Contains("vuelo"))
                errores.Add(new FormError { Field = "numeroVuelo", Message = ex.Message });
            else if (ex.Message.Contains("avion") || ex.Message.Contains("aeronave"))
                errores.Add(new FormError { Field = "avion", Message = ex.Message });
            else if (ex.Message.Contains("ruta"))
                errores.Add(new FormError { Field = "idRuta", Message = ex.Message });
            else
                errores.Add(new FormError { Field = "", Message = "Error: " + ex.Message });

            return Json(new { success = false, errors = errores });
        }
        catch (Exception ex)
        {
            errores.Add(new FormError { Field = "", Message = "Error inesperado: " + ex.Message });
            return Json(new { success = false, errors = errores });
        }
    }
    
    public IActionResult GestionCache(int idVuelo)
    {
        string cacheKey = $"VUELO_{idVuelo}";

       
    if (!_memoryCache.TryGetValue(cacheKey, out VueloCache vuelo))
        {
             vuelo = new VueloCache
            {
                IdVuelo = idVuelo,
                IdEstado = 1
            };
            var cacheOptions = new MemoryCacheEntryOptions()
                //TODO TOCAR LOS MIN
                .SetSlidingExpiration(TimeSpan.FromMinutes(30)); 
            
            _memoryCache.Set(cacheKey, vuelo, cacheOptions);
        }

        return Json(vuelo);
    }
    

    [Authorize("AdminOrGestor")]
    public async Task<IActionResult> GestionarVuelo(int idVuelo)
    {
        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);
        
        if (vuelo.IdEstado == 7)
        {
            return RedirectToAction("Index");
        }
        
        VueloCache cache = _repoVuelos.GetVueloCache(idVuelo);
     
        if (cache == null)
        { 
            var tripulacion = await _repoTripulantes.GetTripulantesVueloAsync(idVuelo);
            cache = new VueloCache
            {
                IdVuelo = idVuelo,
                IdEstado = vuelo.IdEstado,
                Puerta = vuelo.Puerta,
                PasajerosConfirmados = vuelo.PasajerosConfirmados,
                PasajerosEmbarcados = vuelo.PasajerosEmbarcados,
                IdCapitan = tripulacion.Comandante?.IdTripulante ?? 0,
                IdCopiloto = tripulacion.Oficial?.IdTripulante ?? 0,
                IdsTcp = tripulacion.Tcps?.Select(t => t.IdTripulante).ToList() ?? new List<int>()
            };
            _repoVuelos.SaveVueloCache(cache);
        }
        
        int idAerolinea = ClaimsExtensions.GetAerolineaId(User);    

        var comandantes = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, idAerolinea,"Comandante");
        var copilotos = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, idAerolinea,"Primer Oficial");
        var tcps = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, idAerolinea,"Tripulante de Cabina");
 
        List<CodigoRetrasoIata> codigosRetrasos = await _repoRetrasos.GetCodigosRetrasoAsync();
        
        var retrasoDetalle = await _repoRetrasos.GetDetalleRetrasoAsync(idVuelo);
        
        
        if (cache.IdCapitan > 0 && !comandantes.Any(c => c.IdTripulante == cache.IdCapitan))
        {
            var t = await _repoTripulantes.FindTripulanteAsync(cache.IdCapitan);
            if (t != null) comandantes.Add(t);
        }

        if (cache.IdCopiloto > 0 && !copilotos.Any(c => c.IdTripulante == cache.IdCopiloto))
        {
            var t = await _repoTripulantes.FindTripulanteAsync(cache.IdCopiloto);
            if (t != null) copilotos.Add(t);
        }

        foreach (var id in cache.IdsTcp)
        {
            if (!tcps.Any(t => t.IdTripulante == id))
            {
                var trip = await _repoTripulantes.FindTripulanteAsync(id);
                if (trip != null) tcps.Add(trip);
            }
        }
        
        ViewData["TRIPULACION_CACHE"] = cache;
        ViewData["COMANDANTES"] = comandantes;
        ViewData["COPILOTOS"] = copilotos;
        ViewData["TCPS"] = tcps;
        ViewData["CODRETRASOS"] = codigosRetrasos;
        ViewData["RETRASO_ACTUAL"] = retrasoDetalle;
        return View(vuelo);
        
    }
    [HttpPost]
    // [ValidateAntiForgeryToken]
    [Authorize("AdminOrGestor")]
    public IActionResult ActualizarBorrador([FromBody] VueloCache datos)
    {
        if (datos == null) return BadRequest();
        Console.WriteLine("CAPITAN2: " + datos.IdCapitan);
        Console.WriteLine("COPILOTO2: " + datos.IdCopiloto);
        Console.WriteLine("TCPS2: " + string.Join(",", datos.IdsTcp ?? new List<int>()));
       
        _repoVuelos.SaveVueloCache(datos);
        return Json(new { success = true });
    }
    [HttpPost]
    [Authorize(Roles="Administrador,Gerente")]
    public async Task<IActionResult> ConfirmarVueloFinal(int idVuelo)
    {
        var result = await _repoVuelos.CommitVueloAsync(idVuelo);

        if (result.Success)
        {
            VistaVuelo vueloActual = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);

            const int estadoEnVuelo = 3;
            const int estadoAterrizado = 4;
            const int estadoCancelado = 5;
            const int estadoCompletado = 7;

            // Si el vuelo queda cancelado o completado, salimos.
            if (vueloActual.IdEstado == estadoCancelado || vueloActual.IdEstado == estadoCompletado)
            {
                _memoryCache.Remove($"VUELO_{idVuelo}");
                return Json(new { success = true, message = "Estado confirmado." });
            }

            int nuevoEstado;

            if (vueloActual.IdEstado == estadoEnVuelo)
                nuevoEstado = estadoCompletado;
            else if (vueloActual.IdEstado == estadoAterrizado)
                nuevoEstado = estadoCompletado;
            else
                nuevoEstado = vueloActual.IdEstado + 1;

            string? warning = null;

            // 1) Persistimos el nuevo estado
            await _repoVuelos.UpdateEstadoVueloAsync(idVuelo, nuevoEstado);

            // 2) Auto-registro combustible
            if (nuevoEstado == estadoEnVuelo)
            {
                try
                {
                    const decimal precioPorLitroDefault = 0.73m;
                    await _repoCombustible.AutoRegistrarCombustibleDesdeVueloAsync(
                        idVuelo,
                        precioPorLitroDefault,
                        observaciones: "Auto-registro desde gestión de vuelo"
                    );
                }
                catch (Exception ex)
                {
                    warning = $"El combustible no se pudo registrar automáticamente: {ex.Message}";
                    Console.WriteLine($"[Combustible] Auto-registro falló para vuelo {idVuelo}: {ex}");
                }
            }

            _memoryCache.Remove($"VUELO_{idVuelo}");

            return Json(new { success = true, message = "Paso confirmado correctamente.", warning });
        }

        return Json(new { success = false, message = result.Message, errors = new List<FormError>() });
    }
  

    [HttpGet]
    public IActionResult CacheAlive(int idVuelo)
    {
        var cache = _repoVuelos.GetVueloCache(idVuelo);
        return Json(new { alive = cache != null });
    }

    [HttpPost]
   
    public async Task<IActionResult> RegistrarRetraso(int? idVuelo, [FromBody] RetrasoVuelo input)
    {
        if (input == null)
        {
            return Json(new { success = false, message = "Datos inválidos" });
        }

        if (!ModelState.IsValid)
        {
            var errores = ModelState.Values
                .SelectMany(v => v.Errors)
                .Select(e => e.ErrorMessage)
                .Where(m => !string.IsNullOrWhiteSpace(m))
                .ToList();

            return Json(new { success = false, message = "Hay errores de validación", errors = errores });
        }

        var result = await _repoRetrasos.RegistrarRetrasoAsync(input.IdVuelo, input.Minutos, input.IdCodRetraso);

        // Enviamos también el estado actual y el detalle del retraso para refrescar la UI sin recargar.
        var vuelo = await _repoVuelos.GetDatosVueloByIdAsync(input.IdVuelo);
        var retrasoDetalle = await _repoRetrasos.GetDetalleRetrasoAsync(input.IdVuelo);

        return Json(new
        {
            success = result.Success,
            message = result.Message,
            idEstado = vuelo.IdEstado,
            estado = vuelo.Estado,
            retraso = retrasoDetalle
        });
    }

    public async Task<IActionResult> Tracking(int idVuelo)
    {
        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);
        if (vuelo.IdEstado != 3)
        {
            return RedirectToAction("Index");
        }
        return View(vuelo);
    }
    
    
    public async Task<IActionResult> DatosVuelo(int idVuelo)
    {
        VistaHistorialVuelo vuelo = await _repoAviones.GetHistorialVueloByVueloIdAsync(idVuelo);
            
        if (vuelo == null)
            return NotFound();
            
        return View(vuelo);
    }
    
    private static double CalcularHeading(double lat1, double lng1, double lat2, double lng2)
    {
        double toRad = Math.PI / 180;
        double dLng = (lng2 - lng1) * toRad;
        double lat1Rad = lat1 * toRad;
        double lat2Rad = lat2 * toRad;

        double y = Math.Sin(dLng) * Math.Cos(lat2Rad);
        double x = Math.Cos(lat1Rad) * Math.Sin(lat2Rad) -
                   Math.Sin(lat1Rad) * Math.Cos(lat2Rad) * Math.Cos(dLng);

        return (Math.Atan2(y, x) * 180 / Math.PI + 360) % 360;
    }

    [HttpPost]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> GenerateHardVuelos()
    {
        await _repoVuelos.InsertarHardVuelosAsync();
        return RedirectToAction("Index");
    }  
    
    [HttpPost]
    [Authorize("AdminOnly")]
    public async Task<IActionResult> BorrarHardVuelos()
    {
        await _repoVuelos.BorrarHardVuelosAsync();
        return RedirectToAction("Index");
    }
}
