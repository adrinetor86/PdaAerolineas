using PdaAerolineas.Data;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Models.Resumenes;
using PdaAerolineas.Services;

namespace PdaAerolineas.Repositories;

public class RepositorySimulador : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<RepositorySimulador> _logger;
    private readonly IHubContext<VueloHub> _hubContext;


    public RepositorySimulador(IServiceProvider serviceProvider, ILogger<RepositorySimulador> logger, IHubContext<VueloHub> hubContext)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
        _hubContext = hubContext;

    }

    private static string VueloGroupName(int idVuelo) => $"vuelo:{idVuelo}";

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Servicio de simulación de vuelos iniciado");
        await Task.Delay(5000, stoppingToken);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    var context = scope.ServiceProvider.GetRequiredService<DataContext>();

                    await CompletarVuelosFinalizados(context);

                    // Emitir telemetría en directo (si la vista V_VUELOS_TRACKING aporta lat/lng actuales)
                    await EmitirTrackingEnDirecto(context);

                    // Obtener vuelos activos
                    var vuelosActivos = await context.Vuelos
                        .Where(v => v.IdEstado == 3) // En Vuelo
                        .Where(v => v.FechaLlegada > DateTime.Now)
                        .ToListAsync();

                    _logger.LogInformation($"Procesando {vuelosActivos.Count} vuelos activos");

                    foreach (var vuelo in vuelosActivos)
                    {
                        // Verificar si debe aterrizar
                        if (DateTime.Now >= vuelo.FechaLlegada)
                        {
                            // Aterrizar vuelo
                            await context.Database.ExecuteSqlInterpolatedAsync(
                                $"EXEC SP_UPDATE_ESTADO_VUELO @vuelo_id={vuelo.IdVuelo}, @nuevo_estado_id=4, @fecha_actualizacion={DateTime.Now}"
                            );

                            _logger.LogInformation($"Vuelo {vuelo.NumeroVuelo} ha aterrizado");
                        }
                    }
                    //TODO POSIBILIDAD DE AUTOMATIZAR DESPEGUES

                    // // Despegar vuelos programados
                    // var vuelosDespegar = await context.Vuelos
                    //     .Where(v => v.IdVuelo == 1) // Programado
                    //     .Where(v => v.FechaSalida <= DateTime.Now)
                    //     .Where(v => v.FechaSalida >= DateTime.Now.AddMinutes(-5)) // Últimos 5 min
                    //     .ToListAsync();
                    //
                    // foreach (var vuelo in vuelosDespegar)
                    // {
                    //     await context.Database.ExecuteSqlInterpolatedAsync(
                    //         $"EXEC SP_UPDATE_ESTADO_VUELO @vuelo_id={vuelo.Id}, @nuevo_estado_id=3, @fecha_actualizacion={DateTime.Now}"
                    //     );
                    //
                    //     _logger.LogInformation($" Vuelo {vuelo.NumeroVuelo} ha despegado");
                    // }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en simulación de vuelos");
            }

            // Esperar 10 segundos antes de la próxima iteración
            await Task.Delay(TimeSpan.FromSeconds(3), stoppingToken);
        }

        _logger.LogInformation("Servicio de simulación de vuelos detenido");
    }

    private async Task EmitirTrackingEnDirecto(DataContext context)
    {
        try
        {
            // Emitimos para vuelos en estado 'En Vuelo' (3).
            // Si la vista no trae lat/lng actuales, calculamos una posición interpolada.
            var tracking = await context.VuelosTracking
                .AsNoTracking()
                .Where(t => t.EstadoId == 3)
                .ToListAsync();

            foreach (var t in tracking)
            {
                double? lat = null;
                double? lng = null;

                // 1. FORZAMOS LA SIMULACIÓN MATEMÁTICA EN TIEMPO REAL
                if (t.LatOrigen.HasValue && t.LngOrigen.HasValue && t.LatDestino.HasValue && t.LngDestino.HasValue)
                {
                    var now = DateTime.Now;
                    var total = (t.FechaLlegada - t.FechaSalida).TotalSeconds;
                    double progress = 0;

                    if (total > 0)
                    {
                        progress = (now - t.FechaSalida).TotalSeconds / total;
                        // Evitamos que se salga de los límites (0 = origen, 1 = destino)
                        progress = Math.Clamp(progress, 0, 1);
                    }

                    var oLat = (double)t.LatOrigen.Value;
                    var oLng = (double)t.LngOrigen.Value;
                    var dLat = (double)t.LatDestino.Value;
                    var dLng = (double)t.LngDestino.Value;

                    // Calculamos la posición exacta en este milisegundo
                    lat = oLat + (dLat - oLat) * progress;
                    lng = oLng + (dLng - oLng) * progress;
                }

                // Si no hay coordenadas de los aeropuertos, no podemos simular
                if (!lat.HasValue || !lng.HasValue)
                    continue;

                // 2. Guardamos este punto calculado en el historial JSON
                await GuardarPosicionJSON(context, t, lat.Value, lng.Value);

                // 3. Lo emitimos inmediatamente al navegador
                await _hubContext.Clients.Group(VueloGroupName(t.VueloId)).SendAsync("PosicionActualizada", new
                {
                    vueloId = t.VueloId,
                    timestamp = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
                    lat = lat.Value,
                    lng = lng.Value,
                    altitudPies = t.AltitudPies ?? 0,
                    progreso = t.Progreso.HasValue ? (double)t.Progreso.Value : 0
                });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error emitiendo tracking en directo");
        }
    }

    private async Task GuardarPosicionJSON(DataContext context, VueloTracking vuelo, double lat, double lng)
    {
        try
        {
            // Obtener tracking actual
            var vueloEntity = await context.Vuelos
                .Where(v => v.IdVuelo == vuelo.VueloId)
                .FirstOrDefaultAsync();

            if (vueloEntity == null) return;

            var nuevaPosicion = new
            {
                timestamp = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
                lat,
                lng,
                altitud = vuelo.AltitudPies ?? 0,
                progreso = vuelo.Progreso.HasValue ? (double)vuelo.Progreso.Value : 0
            };

            List<object> posiciones;
            if (string.IsNullOrEmpty(vueloEntity.Telemetria))
            {
                posiciones = new List<object>();
            }
            else
            {
                posiciones = System.Text.Json.JsonSerializer.Deserialize<List<object>>(
                    vueloEntity.Telemetria
                ) ?? new List<object>();
            }

            posiciones.Add(nuevaPosicion);

            if (posiciones.Count > 100)
            {
                posiciones = posiciones.Skip(posiciones.Count - 100).ToList();
            }

            vueloEntity.Telemetria = System.Text.Json.JsonSerializer.Serialize(posiciones);
            await context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error guardando posición del vuelo {vuelo.VueloId}");
        }
    }

    private async Task CompletarVuelosFinalizados(DataContext context)
    {
        var ahora = DateTime.Now;
        var vuelosParaCompletar = await context.Vuelos
            .Where(v => v.IdEstado == 3)
            .Where(v => v.FechaLlegada <= ahora)
            .ToListAsync();

        foreach (var vuelo in vuelosParaCompletar)
        {
            try
            {
                await context.Database.ExecuteSqlInterpolatedAsync(
                    $"EXEC SP_UPDATE_ESTADO_VUELO @vuelo_id={vuelo.IdVuelo}, @nuevo_estado_id=7, @fecha_actualizacion={ahora}"
                );

                _logger.LogInformation($"Vuelo {vuelo.NumeroVuelo} completado");

                await _hubContext.Clients.All.SendAsync("VueloCompletado", new
                {
                    vueloId = vuelo.IdVuelo,
                    numeroVuelo = vuelo.NumeroVuelo
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error completando vuelo {vuelo.IdVuelo}");
            }
        }
    }
}
