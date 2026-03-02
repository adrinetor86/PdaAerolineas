using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using PdaAerolineas.Extensions;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class VuelosController : Controller
{
    private RepositoryVuelos _repoVuelos;
    private RepositoryTripulantes _repoTripulantes;
    private RepositoryRetrasos _repoRetrasos;
    private IMemoryCache _memoryCache;

    public VuelosController(RepositoryVuelos repoVuelos, RepositoryTripulantes repoTripulantes,
        RepositoryRetrasos repoRetrasos,IMemoryCache memoryCache)
    {
        _repoVuelos = repoVuelos;
        _repoTripulantes = repoTripulantes;
        _repoRetrasos = repoRetrasos;
        _memoryCache = memoryCache;
    }


    [SessionCheck]
    public async Task<IActionResult> Index(
        int numPag = 1,
        int numFilas = 10,
        int? idEstado = null,
        int? idAerolinea = 1,
        DateTime? fechaSalida = null,
        string? busqueda = null)
    {
        if (numPag < 1) numPag = 1;
        if (numFilas < 1) numFilas = 10;

        var (vuelos, total) = await _repoVuelos.GetVuelosPaginadosConTotalAsync(numPag, numFilas, idEstado, idAerolinea, fechaSalida, busqueda);
        ViewData["TOTAL_REGISTROS"] = total;

        ViewData["ESTADOS"] = await _repoVuelos.GetEstadosVuelosAync();

        // HARDCODEADO PARA SIMULAR LA AEROLINEA 1
        ViewData["AVIONES"] = await _repoVuelos.GetAvionesByAerolineaAsync(1);
        ViewData["NUMEROVUELOS"] = await _repoVuelos.GetNumeroVueloByAerolineaAsync(1);

        return View(vuelos);
    }

    [HttpPost]
    [ActionName("Index")]
    public IActionResult IndexPost(int numPag, int numFilas, int? idEstado, int? idAerolinea, DateTime? fechaSalida, string? busqueda)
    {
        // Compatibilidad: si alguien aún postea, redirigimos al GET con querystring
        return RedirectToAction("Index", new { numPag, numFilas, idEstado, idAerolinea, fechaSalida, busqueda });
    }

    [HttpPost]
    public async Task<IActionResult> GetRutasPorAvion(int idAvion)
    {

        var rutas = await _repoVuelos.GetRutasDisponibles(idAvion);
        Console.WriteLine(":_____________________________________________________________________________");
        Console.WriteLine(rutas);

        return Json(rutas);
    }


    // [ValidateAntiForgeryToken]
    [HttpPost]
    public async Task<IActionResult> Create(string numeroVuelo, int idRuta, int avion, DateTime fechaSalida,
        string puerta)
    {

        Console.WriteLine(":_____________________________________________________________________________");
        Console.WriteLine(numeroVuelo);
        Console.WriteLine(idRuta);
        Console.WriteLine(avion);
        Console.WriteLine(fechaSalida);
        //TODO QUITAR HARD AEROLINEA
        await _repoVuelos.CreateVueloAsync(numeroVuelo, 1, idRuta,
            avion, fechaSalida, puerta);

        return RedirectToAction("Index");
    }


    public async Task<IActionResult> Update(int idVuelo)
    {
        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);

        var comandantes = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Comandante");
        var copilotos = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Primer Oficial");
        var tcps = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Tripulante de Cabina");

        // List<Tripulante> tripulantesAsignados = await _repoTripulantes.GetTripulantesVueloAsync(idVuelo);
        ViewData["COMANDANTES"] = comandantes;
        ViewData["COPILOTOS"] = copilotos;
        ViewData["TCPS"] = tcps;
        // ViewData["TRIPULANTES"] = tripulantesAsignados;

        return View(vuelo);
    }



    [HttpPost]
    public async Task<IActionResult> Update
    (int idVuelo, string numerovuelo, int aerolinea, int ruta, int avion,
        DateTime salida, DateTime llegada, int estado, string puerta, int capacidad,
        int confirmados, int embarcados,
        int idCapitan, int idCopiloto, int[] idsTcp)
    {
        Console.WriteLine("=============================");
        Console.WriteLine($"idVuelo    = {idVuelo}");
        Console.WriteLine($"numerovuelo= {numerovuelo}");
        Console.WriteLine($"aerolinea  = {aerolinea}");
        Console.WriteLine($"ruta       = {ruta}");
        Console.WriteLine($"avion      = {avion}");
        Console.WriteLine($"salida     = {salida}");
        Console.WriteLine($"llegada    = {llegada}");
        Console.WriteLine($"estado     = {estado}");
        Console.WriteLine($"puerta     = {puerta}");
        Console.WriteLine($"capacidad  = {capacidad}");
        Console.WriteLine($"confirmados= {confirmados}");
        Console.WriteLine($"embarcados = {embarcados}");
        Console.WriteLine($"capitan = {idCapitan}");
        Console.WriteLine($"copi = {idCopiloto}");
        Console.WriteLine($"tcps = {idsTcp}");
        Console.WriteLine("=============================");

        int[] idsTripulantes = new[] { idCapitan, idCopiloto }
            .Where(id => id > 0) // filtrar los que no se asignaron
            .Concat(idsTcp ?? Array.Empty<int>()) // añadir los TCPs
            .ToArray();

        await _repoVuelos.UpdateDatosVuelo
        (idVuelo, numerovuelo, 1, ruta, avion, salida, llegada, estado, puerta,
            capacidad, embarcados, embarcados, idsTripulantes);

        return RedirectToAction("Index");
    }


    public async Task<IActionResult> GestionVuelo(int idVuelo)
    {
        var comandantes = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Comandante");
        var copilotos = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Primer Oficial");
        var tcps = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Tripulante de Cabina");

        var (valido, errores) = await _repoTripulantes.ValidarTripulacionAsync(idVuelo);

        if (!valido)
        {
            ViewData["ErroresTripulacion"] = errores; // List<string>
        }


        ViewData["COMANDANTES"] = comandantes;
        ViewData["COPILOTOS"] = copilotos;
        ViewData["TCPS"] = tcps;
        TripulanteAsignado tripulanteAsignado = await _repoTripulantes.GetTripulantesVueloAsync(idVuelo);
        ViewData["TRIPULACION"] = tripulanteAsignado;

        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);
        return View(vuelo);
    }
    
    [HttpPost]
    public async Task<IActionResult> GestionVuelo(int idVuelo, int estado, string puerta,
        int confirmados, int embarcados, int idCapitan, int idCopiloto, int[] idsTcp)
    {
        var result = await _repoVuelos.UpdateGestionVueloAsync(idVuelo, estado, puerta, confirmados, embarcados, idCapitan, idCopiloto, idsTcp);

        if (result.Success)
        {
            return Json(new { success = true, nuevoEstado = estado, message = result.Message });
        }
    
        return Json(new { success = false, message = result.Message });
    }
    

    public IActionResult GestionCache(int idVuelo)
    {
        string cacheKey = $"VUELO_{idVuelo}";
        
        // Intentamos obtener el vuelo de la cache
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
    

    
    public async Task<IActionResult> GestionarVuelo(int idVuelo)
    {
        // Obtener el vuelo original
        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);

        // Obtener cache
        VueloCache cache = _repoVuelos.GetVueloCache(idVuelo);

        if (cache == null)
        {
            // Si no hay cache, inicializarlo desde la DB
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

        // Listas base (solo disponibles)
        var comandantes = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Comandante");
        var copilotos = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Primer Oficial");
        var tcps = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo, "Tripulante de Cabina");
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
    public IActionResult ActualizarBorrador([FromBody] VueloCache datos)
    {
        if (datos == null) return BadRequest();
        Console.WriteLine("CAPITAN2: " + datos.IdCapitan);
        Console.WriteLine("COPILOTO2: " + datos.IdCopiloto);
        Console.WriteLine("TCPS2: " + string.Join(",", datos.IdsTcp ?? new List<int>()));
        // Guardar el cache con los datos actualizados
        _repoVuelos.SaveVueloCache(datos);
        return Json(new { success = true });
    }
    [HttpPost]
    public async Task<IActionResult> ConfirmarVueloFinal(int idVuelo)
    {
        var result = await _repoVuelos.CommitVueloAsync(idVuelo);

        if (result.Success)
        {
            VistaVuelo vueloActual = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);

            const int estadoCancelado = 5;
            const int estadoCompletado = 7;
            const int estadoAterrizado = 4;
            const int estadoEnVuelo = 3;

            // Estados terminales
            if (vueloActual.IdEstado == estadoCancelado || vueloActual.IdEstado == estadoCompletado)
            {
                _memoryCache.Remove($"VUELO_{idVuelo}");
                return Json(new { success = true, message = "Estado confirmado." });
            }

            int nuevoEstado;

            // Nuevo flujo: En vuelo (3) -> Completado (7)
            if (vueloActual.IdEstado == estadoEnVuelo)
            {
                nuevoEstado = estadoCompletado;
            }
            // Compatibilidad: si por cualquier motivo quedó en Aterrizado (4), también pasamos a 7
            else if (vueloActual.IdEstado == estadoAterrizado)
            {
                nuevoEstado = estadoCompletado;
            }
            else
            {
                nuevoEstado = vueloActual.IdEstado + 1;
            }

            await _repoVuelos.UpdateEstadoVueloAsync(idVuelo, nuevoEstado);

            _memoryCache.Remove($"VUELO_{idVuelo}");

            return Json(new { success = true, message = "Paso confirmado correctamente." });
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
        return Json(new { success = result.Success, message = result.Message });
    }

    public async Task<IActionResult> Tracking(int idVuelo)
    {
        VistaVuelo vuelo = await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);
        return View(vuelo);
    }
}
