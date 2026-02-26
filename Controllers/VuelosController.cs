using Microsoft.AspNetCore.Mvc;
using PdaAerolineas.Models;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Controllers;

public class VuelosController : Controller
{
    private RepositoryVuelos _repoVuelos;
    private RepositoryTripulantes _repoTripulantes;

    public VuelosController(RepositoryVuelos repoVuelos, RepositoryTripulantes repoTripulantes)
    {
        _repoVuelos = repoVuelos;
        _repoTripulantes = repoTripulantes;
    }


    public async Task<IActionResult> Index()
    {
        List<VistaVuelo> vuelo = await _repoVuelos.GetVuelosAsync();
        ViewData["ESTADOS"] = await _repoVuelos.GetEstadosVuelosAync();

        //HARDCODEADO PARA SIMULAR LA AEROLINEA 1
        ViewData["AVIONES"] = await _repoVuelos.GetAvionesByAerolineaAsync(1);
        ViewData["NUMEROVUELOS"] = await _repoVuelos.GetNumeroVueloByAerolineaAsync(1);
        return View(vuelo);
    }


    [HttpPost]
    public async Task<IActionResult> GetRutasPorAvion(int idAvion)
    {

        var rutas = await _repoVuelos.GetRutasDisponibles(idAvion);
        Console.WriteLine(":_____________________________________________________________________________");
        Console.WriteLine(rutas);

        return Json(rutas);
    }

    [HttpPost]
    public async Task<IActionResult> Index(int idVuelo, int idEstado)
    {

        await _repoVuelos.UpdateEstadoVueloAsync(idVuelo, idEstado);
        return RedirectToAction("Index");
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
    public async Task<IActionResult> GestionVuelo(int idVuelo, string numerovuelo, int aerolinea, int ruta, int avion,
        DateTime salida, DateTime llegada, int estado, string puerta, int capacidad,
        int confirmados, int embarcados,
        int idCapitan, int idCopiloto, int[] idsTcp)
    {
        try
        {
            // 1. Combinar todos los IDs de tripulantes en un solo array para el Repo
            int[] idsTripulantes = new[] { idCapitan, idCopiloto }
                .Where(id => id > 0)
                .Concat(idsTcp ?? Array.Empty<int>())
                .ToArray();
            int estadoReal = await _repoVuelos.GetEstadoVueloByIdAsync(idVuelo);
            // 2. Llamada al repositorio (Descomenta cuando tu repo esté listo)
            // await _repoVuelos.UpdateDatosVuelo(idVuelo, numerovuelo, 1, ruta, avion, ...);
            await _repoVuelos.UpdateDatosVuelo
            (idVuelo, numerovuelo, 1, ruta, avion, salida, llegada, estado, puerta,
                capacidad, confirmados, embarcados, idsTripulantes);
            // Simulación de log para debug
            Console.WriteLine($"Guardando Vuelo {idVuelo} - Estado: {estado} - Tripulantes: {idsTripulantes.Length}");

            return Json(new
            {
                success = true,
                message = "Datos guardados correctamente",
                nuevoEstado = estadoReal
            });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = "Error en el servidor: " + ex.Message });
        }
    }
}
// }
    //
    // [HttpPost]
    // public async Task<IActionResult> GestionVuelo()
    // {
    //     try
    //     {
    //         foreach (var key in Request.Form.Keys)
    //         {
    //             Console.WriteLine($"{key}: {Request.Form[key]}");
    //         }
    //
    //         return Json(new { success = true });
    //     }
    //     catch (Exception ex)
    //     {
    //         return Json(new { success = false, message = ex.ToString() });
    //     }
    // }
    //
    
// }