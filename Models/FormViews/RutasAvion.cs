namespace PdaAerolineas.Models.FormViews;

public class RutasAvion
{
    public int Id { get; set; }
    public int Distancia { get; set; }
    public string CodOrigen { get; set; }
    public string NombreOrigen { get; set; }
    public string CiudadOrigen { get; set; } 
    public string CodDestino { get; set; }
    public string NombreDestino { get; set; }
    public string CiudadDestino {get; set; }
    public decimal Duracion { get; set; }
    public string DuracionFomateada { get; set; }
}






//
// r.id AS ruta_id,
// r.distancia_km,
//
// ao.codigo_iata AS codigo_origen,
// ao.nombre AS nombre_origen,
// ao.ciudad AS ciudad_origen,
//
// ad.codigo_iata AS codigo_destino,
// ad.nombre AS nombre_destino,
// ad.ciudad AS ciudad_destino,
//
// -- Duración estimada simple (800 km/h)
// ROUND((r.distancia_km / 800.0) * 60, 0) AS duracion_minutos,
//
// CAST(ROUND((r.distancia_km / 800.0) * 60, 0) / 60 AS VARCHAR)
// + 'h ' +
// CAST(ROUND((r.distancia_km / 800.0) * 60, 0) % 60 AS VARCHAR)
// + 'min' AS duracion_formateada