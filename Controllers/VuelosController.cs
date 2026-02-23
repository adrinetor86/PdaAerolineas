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
        ViewData["ESTADOS"]=  await _repoVuelos.GetEstadosVuelosAync();
        
        //HARDCODEADO PARA SIMULAR LA AEROLINEA 1
        ViewData["AVIONES"]=  await _repoVuelos.GetAvionesByAerolineaAsync(1);
        ViewData["NUMEROVUELOS"]=  await _repoVuelos.GetNumeroVueloByAerolineaAsync(1);
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
    public async Task<IActionResult> Create(string numeroVuelo,int idRuta,int avion,DateTime fechaSalida,string puerta)
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
       VistaVuelo vuelo= await _repoVuelos.GetDatosVueloByIdAsync(idVuelo);
       
       var tripulantes = await _repoTripulantes.GetTripulantesDisponiblesAsync(idVuelo);
       ViewData["TRIPULANTES"] = tripulantes;

       return View(vuelo);
    }  
    
    [HttpPost]
    public async Task<IActionResult> Update
        (int idVuelo,string numerovuelo,int aerolinea,int ruta,int avion,
        DateTime salida,DateTime llegada,int estado,string puerta,int capacidad,int confirmados,int embarcados)
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
        Console.WriteLine("=============================");

       await _repoVuelos.UpdateDatosVuelo
           (idVuelo,numerovuelo, 1, ruta, avion, salida, llegada, estado, puerta, capacidad, embarcados, embarcados);
        
       return RedirectToAction("Index");
    }
}