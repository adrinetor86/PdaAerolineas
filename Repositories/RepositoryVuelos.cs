using System.Data;
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

// ALTER PROCEDURE SP_UPDATE_ESTADO_VUELO
// (
//     @vuelo_id INT,
//     @nuevo_estado_id INT,
//     @fecha_actualizacion DATETIME = NULL
// )
// AS
// BEGIN
//     SET NOCOUNT ON;
//
//     IF @fecha_actualizacion IS NULL
//         SET @fecha_actualizacion = GETDATE();
//
//     BEGIN TRY
//         BEGIN TRANSACTION;
//
//         -- Validar que el vuelo existe
//         IF NOT EXISTS (SELECT 1 FROM vuelo WHERE id = @vuelo_id)
//             BEGIN
//                 RAISERROR('El vuelo no existe', 16, 1);
//                 RETURN;
//             END
//
//         DECLARE @avion_id INT;
//         DECLARE @estado_actual INT;
//
//         SELECT @avion_id = avion_id, @estado_actual = estado_id
//         FROM vuelo
//         WHERE id = @vuelo_id;
//
//         -- Actualizar estado del vuelo
//         UPDATE vuelo
//         SET estado_id = @nuevo_estado_id
//         WHERE id = @vuelo_id;
//
//         -- Si el vuelo despega (estado 3 - En Vuelo)
//         IF @nuevo_estado_id = 3 AND @estado_actual != 3
//             BEGIN
//                 UPDATE avion
//                 SET estado_id = 3,
//                     aeropuerto_actual_id = 1
//                 WHERE id = @avion_id;
//
//                 UPDATE avion
//                 SET ciclos_totales = ciclos_totales + 1
//                 WHERE id = @avion_id;
//             END
//             
//         IF @nuevo_estado_id = 5 AND @estado_actual != 5
//          BEGIN
//              
//              UPDATE avion
//              SET estado_id = 5
//              WHERE id = @avion_id;
//          END   
//         -- Si el vuelo aterriza (estado 4 - Aterrizado)
//         IF @nuevo_estado_id = 4 AND @estado_actual = 3
//             BEGIN
//                 DECLARE @aeropuerto_destino_id INT;
//                 DECLARE @duracion_vuelo_horas DECIMAL(10,2);
//                 DECLARE @latitud DECIMAL(9,6);
//                 DECLARE @longitud DECIMAL(9,6);
//
//                 -- Obtener aeropuerto destino y duración
//                 SELECT @aeropuerto_destino_id = r.aeropuerto_destino_id
//                 FROM vuelo v
//                          INNER JOIN ruta r ON v.ruta_id = r.id
//                 WHERE v.id = @vuelo_id;
//
//                 SELECT @duracion_vuelo_horas = DATEDIFF(MINUTE, fecha_salida, @fecha_actualizacion) / 60.0
//                 FROM vuelo
//                 WHERE id = @vuelo_id;
//
//                 -- Obtener coordenadas del aeropuerto
//                 SELECT @latitud = latitud, @longitud = longitud
//                 FROM aeropuerto
//                 WHERE id = @aeropuerto_destino_id;
//
//                 -- Actualizar avión
//                 UPDATE avion
//                 SET estado_id = 5,
//                     aeropuerto_actual_id = @aeropuerto_destino_id,
//                     horas_vuelo_totales = horas_vuelo_totales + CEILING(@duracion_vuelo_horas)
//                 WHERE id = @avion_id;
//
//                 -- Registrar posición
//                 INSERT INTO registro_estado_avion (avion_id, aeropuerto_id, latitud, longitud, fecha_hora)
//                 VALUES (@avion_id, @aeropuerto_destino_id, @latitud, @longitud, @fecha_actualizacion);
//             END
//
//         COMMIT TRANSACTION;
//
//     END TRY
//     BEGIN CATCH
//         IF @@TRANCOUNT > 0
//             ROLLBACK TRANSACTION;
//     END CATCH
// END;
// GO

// CREATE PROCEDURE SP_CREATE_VUELO(
//     @numero_vuelo NVARCHAR(10),
//     @aerolinea_id INT,
//     @ruta_id INT,
//     @avion_id INT,
//     @fecha_salida DATETIME,
//     @fecha_llegada DATETIME,
//     @puerta NVARCHAR(10) = NULL,
//     @vuelo_id INT OUT)
// AS
//     BEGIN
// SET NOCOUNT ON;
//     
// BEGIN TRY
// BEGIN TRANSACTION;
//         
// -- Validar que el avión esté disponible
//     IF EXISTS (
//     SELECT 1 FROM vuelo 
// WHERE avion_id = @avion_id 
// AND estado_id IN (1, 2, 3) -- Programado, Embarcando, En Vuelo
// AND (
//     (@fecha_salida BETWEEN fecha_salida AND fecha_llegada)
// OR (@fecha_llegada BETWEEN fecha_salida AND fecha_llegada)
//     )
//     )
// BEGIN
// RAISERROR('El avión no está disponible en ese horario', 16, 1);
// RETURN;
// END
//         
//     -- Obtener capacidad del avión
// DECLARE @capacidad INT;
// SELECT @capacidad = m.capacidad_total
// FROM avion av
//     INNER JOIN modelo_avion m ON av.modelo_id = m.id
// WHERE av.id = @avion_id;
//         
// -- Obtener nuevo ID
// DECLARE @nuevo_id INT;
//         
// -- Insertar vuelo
//     INSERT INTO vuelo (
//     numero_vuelo, aerolinea_id, ruta_id, avion_id,
//     fecha_salida, fecha_llegada, estado_id, puerta,
//     capacidad_total, pasajeros_confirmados, pasajeros_embarcados
// )
// VALUES (
//     @numero_vuelo, @aerolinea_id, @ruta_id, @avion_id,
//     @fecha_salida, @fecha_llegada, 1, @puerta,
//     @capacidad, 0, 0
// );
//         
// SET @vuelo_id = @nuevo_id;
//         
// COMMIT TRANSACTION;
//
// END TRY
// BEGIN CATCH
// IF @@TRANCOUNT > 0
// ROLLBACK TRANSACTION;
// END CATCH
//     END;
// go



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

        return await consulta.FirstOrDefaultAsync();
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
        
        string sql = "SP_UPDATE_ESTADO_VUELO @vuelo_id,@nuevo_estado_id";
        
        SqlParameter pamVuelo = new SqlParameter("@vuelo_id", idVuelo);
        SqlParameter pamEstado = new SqlParameter("@nuevo_estado_id", idEstado);
        
        await _context.Database.ExecuteSqlRawAsync(sql, pamVuelo, pamEstado);
    }


    public async Task CreateVueloAsync(string numeroVuelo, int idAerolinea, int idRuta,
        int idAvion, DateTime fechaSalida, DateTime fechaLlegada, string puerta)
    {

        string sql = "SP_CREATE_VUELO @numero_vuelo,@aerolinea_id,@ruta_id,@avion_id,@fecha_salida,@fecha_llegada,@puerta,@vuelo_id out";


        SqlParameter pamNumVuelo = new SqlParameter("@numero_vuelo", numeroVuelo);
        SqlParameter pamAerolinea = new SqlParameter("@aerolinea_id", idAerolinea);
        SqlParameter pamRuta = new SqlParameter("@ruta_id", idRuta);
        SqlParameter pamAvion = new SqlParameter("@avion_id", idAvion);
        SqlParameter pamSalida = new SqlParameter("@fecha_salida", fechaSalida);
        SqlParameter pamLlegada = new SqlParameter("@fecha_llegada", fechaLlegada);
        SqlParameter pamPuerta = new SqlParameter("@puerta", puerta);
        SqlParameter pamIdVuelo = new SqlParameter("@vuelo_id", numeroVuelo);
        pamIdVuelo.Direction = ParameterDirection.Output;

        await _context.Database.ExecuteSqlRawAsync(sql, pamNumVuelo, pamAerolinea, pamRuta,
            pamAvion, pamSalida, pamLlegada, pamPuerta);
        
    }
}