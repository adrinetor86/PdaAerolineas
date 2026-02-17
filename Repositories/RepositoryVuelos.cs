using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

#region PROCEDURES AND VIEWS 

// CREATE VIEW V_VUELOS AS
// SELECT
// v.id AS vuelo_id,
//     v.numero_vuelo,
// al.nombre AS aerolinea,
//
// -- Aeropuertos
// ao.nombre AS aeropuerto_origen,
//     ao.codigo_iata AS codigo_origen,
//     ao.ciudad AS ciudad_origen,
//     ad.nombre AS aeropuerto_destino,
//     ad.codigo_iata AS codigo_destino,
//     ad.ciudad AS ciudad_destino,
//
// -- Avión
// av.matricula,
// m.fabricante,
// m.nombre_modelo,
//
// -- Fechas y estado
// v.fecha_salida,
// v.fecha_llegada,
// ev.nombre AS estado_vuelo,
//     CASE
// WHEN v.puerta IS NOT NULL THEN v.puerta
//     ELSE 'Por Asignar'
// END AS PUERTA,    
//
// -- Pasajeros
// v.capacidad_total,
// v.pasajeros_confirmados,
// v.pasajeros_embarcados,
// CAST(ROUND((v.pasajeros_confirmados * 100.0 / v.capacidad_total), 2) AS DECIMAL(5,2)) AS porcentaje_ocupacion,
//
// -- Ruta
// r.distancia_km
//     FROM vuelo v
// INNER JOIN aerolinea al ON v.aerolinea_id = al.id
// INNER JOIN ruta r ON v.ruta_id = r.id
// INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
// INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
// INNER JOIN avion av ON v.avion_id = av.id
// INNER JOIN modelo_avion m ON av.modelo_id = m.id
// INNER JOIN estado_vuelo ev ON v.estado_id = ev.id;
// GO

// CREATE PROCEDURE SP_UPDATE_VUELO
// (@idvuelo int,@numerovuelo int, @idaerolinea int,
//     @idruta int,@idavion int, @fechasalida datetime,
//     @fechallegada datetime, @idestado int,@puerta nvarchar(10),
//     @capacidadtotal int,@confirmados int,@embarcados int)
// AS
//     
//     UPDATE VUELO SET numero_vuelo=@numerovuelo,aerolinea_id=@idaerolinea,
//     ruta_id=@idruta,avion_id=@idavion,fecha_salida=@fechasalida,
//     fecha_llegada=@fechallegada,estado_id=@idestado,puerta=@puerta,
//     capacidad_total=@capacidadtotal,pasajeros_confirmados=@confirmados,
//     pasajeros_embarcados=@embarcados
// WHERE id=@idvuelo; 
// GO
//     

// CREATE PROCEDURE SP_UPDATE_ESTADOVUELO
//     (@idvuelo int, @idestado int)
// AS
//     UPDATE VUELO SET estado_id=@idestado
// WHERE id=@idvuelo
// GO    

#endregion

public class RepositoryVuelos
{

    private DataContext _context;


    public RepositoryVuelos(DataContext context)
    {
        _context = context;
    }


    public async Task<List<VistaVuelo>> GetVuelosAsync()
    {
        var consulta = from datos in _context.VistaVuelos
            select datos;

        return await consulta.ToListAsync();
    }
    public async Task<Vuelo> FindVueloByIdAsync(int idVuelo)
    {
        var consulta =from datos in _context.Vuelos
            where datos.IdVuelo==idVuelo
            select datos;

        Vuelo vuelo =await consulta.FirstOrDefaultAsync();
        return vuelo;
    }
    
    public async Task<List<EstadoVuelo>> GetEstadosVuelosAync()
    {
        var consulta = from datos in _context.EstadoVuelos
            select datos;

        return await consulta.ToListAsync();

    }


    public async Task UpdateEstadoVueloAsync(int idVuelo,int idEstado)
    {
        // string sql = "SP_UPDATE_ESTADOVUELO @idvuelo,@idestado";
        //
        //
        //
        // SqlParameter pamVuelo = new SqlParameter("@idvuelo", idVuelo);
        // SqlParameter pamEstado = new SqlParameter("@idestado", idEstado);
        //
        // await _context.Database.ExecuteSqlRawAsync(sql, pamVuelo, pamEstado);
        //
        var vuelo = await _context.Vuelos.FindAsync(idVuelo);
        vuelo.IdEstado = idEstado;
        await _context.SaveChangesAsync();

    }

}