using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models.Resumenes;

namespace PdaAerolineas.Controllers;

[Route("Telemetria")]
public class TelemetriaController : Controller
{
    private readonly DataContext _context;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<TelemetriaController> _logger;

    public TelemetriaController(DataContext context, IWebHostEnvironment env, ILogger<TelemetriaController> logger)
    {
        _context = context;
        _env = env;
        _logger = logger;
    }

    [HttpGet("HistorialVuelo")]
    public async Task<IActionResult> HistorialVuelo(int idVuelo)
    {
        var vuelo = await _context.Vuelos
            .Where(v => v.IdVuelo == idVuelo)
            .Select(v => new
            {
                v.IdVuelo,
                v.NumeroVuelo,
                v.Telemetria
            })
            .FirstOrDefaultAsync();

        if (vuelo == null)
            return NotFound();

        return Ok(vuelo);
    }

    [HttpGet("GetLiveVuelos")]
    public async Task<IActionResult> GetLiveVuelos()
    {
      
        var vuelosActivos = await _context.VuelosTracking
            .Where(v => v.EstadoId == 3) 
            .Select(v => new {
                v.NumeroVuelo,
                v.LatitudActual, 
                v.LongitudActual,
                v.CodigoOrigen,
                v.CodigoDestino,
                v.Matricula
            }).ToListAsync();

        return Json(vuelosActivos);
    }
    
    [HttpGet("TrackingBootstrap")]
    public async Task<IActionResult> TrackingBootstrap(int idVuelo)
    {
        try
        {
        
            var t = await _context.VuelosTracking
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.VueloId == idVuelo);

            if (t == null)
                return NotFound(new { success = false, error = "No se ha podido trackear el vuelo ", idVuelo });

            double? latOrigen = t.LatOrigen.HasValue ? (double?)t.LatOrigen.Value : null;
            double? lngOrigen = t.LngOrigen.HasValue ? (double?)t.LngOrigen.Value : null;
            double? latDestino = t.LatDestino.HasValue ? (double?)t.LatDestino.Value : null;
            double? lngDestino = t.LngDestino.HasValue ? (double?)t.LngDestino.Value : null;

            return Ok(new
            {
                success = true,
                vueloId = t.VueloId,
                numeroVuelo = t.NumeroVuelo,
                estadoId = t.EstadoId,
                estado = t.EstadoId,
                origen = new { codigo = t.CodigoOrigen, ciudad = t.CiudadOrigen, lat = latOrigen, lng = lngOrigen },
                destino = new { codigo = t.CodigoDestino, ciudad = t.CiudadDestino, lat = latDestino, lng = lngDestino },
                posicion = new
                {
                    lat = t.LatitudActual.HasValue ? (double?)t.LatitudActual.Value : null,
                    lng = t.LongitudActual.HasValue ? (double?)t.LongitudActual.Value : null,
                    altitudPies = t.AltitudPies,
                    progreso = t.Progreso
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error en TrackingBootstrap (idVuelo={IdVuelo})", idVuelo);

            Response.StatusCode = StatusCodes.Status500InternalServerError;
            return Json(new
            {
                success = false,
                error = "Error al trackear los datos del vuelo.",
                idVuelo,
                detail = _env.IsDevelopment() ? ex.ToString() : null
            });
        }
    }
    
    
    [HttpGet("RadarFlota")]
    public IActionResult RadarFlota()
    {
        return View();
    }
    
    [HttpGet("GetAllTracking")]
    public async Task<IActionResult> GetAllTracking()
    {

        var lista = await _context.VuelosTracking
            .AsNoTracking()
            .Where(v => v.EstadoId == 3) 
            .ToListAsync();
        
        if (lista == null)
        {
            return Ok(new { success = true, data = new List<object>() });
        }

        // Proyectamos a un JSON limpio, controlando los nulos de lat/lng
        var data = lista.Select(t => new
        {
            vueloId = t.VueloId,
            numeroVuelo = t.NumeroVuelo,
            matricula = t.Matricula,
            lat = (double?)t.LatitudActual, 
            lng = (double?)t.LongitudActual,
            info = new
            {
                origen = t.CodigoOrigen,
                destino = t.CodigoDestino,
                ciudadOrigen = t.CiudadOrigen,
                ciudadDestino = t.CiudadDestino,
                latOrigen = (double?)t.LatOrigen,
                lngOrigen = (double?)t.LngOrigen,
                latDestino = (double?)t.LatDestino,
                lngDestino = (double?)t.LngDestino,
                altitud = t.AltitudPies,
                progreso = t.Progreso ?? 0
            }
        });

        return Ok(new { success = true, data = data });
    }
}