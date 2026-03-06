using System.Data;
using Microsoft.Data.SqlClient;
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
// ea.id as idestado,
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
// (SELECT MIN(mp.fecha_programada)
// FROM mantenimiento_programado mp
//     WHERE mp.avion_id = av.id AND mp.estado = 'Programado'
//     ) AS proximo_mantenimiento,
//
// (SELECT TOP 1 v.numero_vuelo
//     FROM vuelo v
// WHERE v.avion_id = av.id
// AND v.estado_id = 3
// AND v.fecha_salida <= GETDATE()
// AND (v.fecha_llegada IS NULL OR v.fecha_llegada >= GETDATE())
// ORDER BY v.fecha_salida DESC) AS vuelo_actual
// FROM avion av
//     INNER JOIN modelo_avion m ON av.modelo_id = m.id
// INNER JOIN estado_avion ea ON av.estado_id = ea.id
// INNER JOIN aerolinea al ON av.aerolinea_id = al.id
// LEFT JOIN aeropuerto aer ON av.aeropuerto_actual_id = aer.id;
// GO

#endregion
public class RepositoryFlotas 
{
    
    private DataContext _context;
    
    public RepositoryFlotas(DataContext context)
    {
        _context = context;
    }



    public async Task<FlotaResumen> GetFlotasByAerolineaAsync(string aerolinea)
    {

        var consultaFlota = from datos in _context.Flotas
            where datos.Aerolinea==aerolinea
            
            select datos;
        
    
         var consultaVuelo = from datos in _context.Vuelos
             where datos.Aerolinea.Nombre==aerolinea
             select datos;
        
        
        FlotaResumen flota = new FlotaResumen();

        flota.NumeroFlota = await consultaFlota.CountAsync();
        
        flota.AvionesMantenimiento = await consultaFlota
            .Where(a => a.Estado == "En Mantenimiento")
            .CountAsync();

        flota.AvionesOperativos = await consultaFlota
            .Where(a => a.Estado == "Operativo")
            .CountAsync();

        flota.VuelosActivos = await consultaVuelo
            .Where(a => a.Estado.NombreEstado == "En Vuelo")
            .CountAsync();

        flota.Flota = await consultaFlota.ToListAsync();
        
        return flota;

    }


    
    public async Task<(List<VistaFlota> Flotas, int TotalRegistros)> GetFlotasPaginadoAsync(
        int numPag,
        int numFilas,
        int? idEstado,
        int? idAerolinea,
        string? busqueda)
    {
        string sql = "EXEC SP_FLOTAS_PAGINADO @PageNumber, @PageSize, @EstadoId, @AerolineaId, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);

        var pamEstado = new SqlParameter("@EstadoId", idEstado.HasValue ? idEstado.Value : DBNull.Value);
        var pamAerolinea = new SqlParameter("@AerolineaId", idAerolinea.HasValue ? idAerolinea.Value : DBNull.Value);
        
        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda!.Trim());

        var pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int);

        pamTotal.Direction = ParameterDirection.Output;
        

        var lista = await _context.Flotas
            .FromSqlRaw(sql, pamNumPagina, pamNumFilas, pamEstado, pamAerolinea , pamBusqueda, pamTotal)
            .ToListAsync();

        int total = 0;
        if (pamTotal.Value != DBNull.Value && pamTotal.Value != null)
        {
            total = (int)pamTotal.Value;
        }

        return (lista, total);
    }
    

}