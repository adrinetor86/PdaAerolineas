using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Resumenes;

namespace PdaAerolineas.Repositories;


#region PROCEDURES AND VIEWS

// ALTER VIEW V_FLOTA_ESTADO
//     AS
// SELECT
// av.id AS avion_id,
//     av.matricula,
// al.nombre as aerolinea,
// m.fabricante,
// m.nombre_modelo,
// m.capacidad_total,
// ea.nombre AS estado,
//     CASE
// WHEN aer.id IS NOT NULL THEN aer.nombre
//     ELSE 'En Vuelo'
// END AS ubicacion,
//     CASE
// WHEN aer.id IS NOT NULL THEN aer.codigo_iata
//     ELSE 'N/A'
// END AS codigo_aeropuerto,
//     av.horas_vuelo_totales,
// av.ciclos_totales,
//
// -- Próximo mantenimiento (retorna 'N/A' si es NULL)
// ISNULL(CONVERT(NVARCHAR(10),
//     (SELECT MIN(mp.fecha_programada)
// FROM mantenimiento_programado mp
//     WHERE mp.avion_id = av.id AND mp.estado = 'Programado'
//     ), 103), 'N/A') AS proximo_mantenimiento,
//
// -- Vuelo actual si está en vuelo (retorna 'N/A' si es NULL)
// ISNULL(
//     (SELECT TOP 1 v.numero_vuelo
// FROM vuelo v
//     WHERE v.avion_id = av.id
// AND v.estado_id = 3
// AND v.fecha_salida <= GETDATE()
// AND (v.fecha_llegada IS NULL OR v.fecha_llegada >= GETDATE())
// ORDER BY v.fecha_salida DESC
//     ), 'N/A') AS vuelo_actual
// FROM avion av
//     INNER JOIN modelo_avion m ON av.modelo_id = m.id
// INNER JOIN estado_avion ea ON av.estado_id = ea.id
// INNER JOIN aerolinea al ON av.aerolinea_id = al.id
// LEFT JOIN aeropuerto aer ON av.aeropuerto_actual_id = aer.id;
// GO

#endregion
public class RepositoryFlota 
{
    
    private DataContext _context;
    
    public RepositoryFlota(DataContext context)
    {
        _context = context;
    }



    public async Task<FlotaResumen> GetFlotasByAerolineaAsync(string aerolinea)
    {

        var consulta = from datos in _context.Flotas
            where datos.Aerolinea == aerolinea
            select datos;

        FlotaResumen flota = new FlotaResumen();

        flota.NumeroFlota = await consulta.CountAsync();
        
        flota.AvionesMantenimiento = await consulta
            .Where(a => a.Estado == "En Mantenimiento")
            .CountAsync();

        flota.AvionesOperativos = await consulta
            .Where(a => a.Estado == "Operativo")
            .CountAsync();

        flota.VuelosActivos = await consulta
            .Where(a => a.Estado == "En Vuelo")
            .CountAsync();

        flota.Flota = await consulta.ToListAsync();
        
        return flota;

    }
}