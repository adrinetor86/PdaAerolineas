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

    [HttpGet("TrackingBootstrap")]
    public async Task<IActionResult> TrackingBootstrap(int idVuelo)
    {
        try
        {
            var t = await _context.VuelosTracking
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.VueloId == idVuelo);

            if (t == null)
                return NotFound(new { success = false, error = "Vuelo no encontrado en V_VUELOS_TRACKING", idVuelo });

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
                error = "Error leyendo V_VUELOS_TRACKING",
                idVuelo,
                detail = _env.IsDevelopment() ? ex.ToString() : null
            });
        }
    }
}