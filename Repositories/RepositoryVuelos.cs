using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;

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
//         IF @nuevo_estado_id = 1 AND @estado_actual != 1
//          BEGIN
//              
//              UPDATE avion
//              SET estado_id = 1
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
//                 SET estado_id = 1,
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

// CREATE OR ALTER PROCEDURE SP_VALIDADICION_CREACION_VUELO
//         @avion_id INT,
//         @ruta_id INT,
//         @fecha_salida DATETIME,
//         @fecha_llegada DATETIME
//     AS
//     BEGIN
//         SET DATEFORMAT dmy;
//         SET NOCOUNT ON;
//
//         DECLARE @aeropuerto_origen_id INT;
//         DECLARE @aeropuerto_actual_id INT;
//         DECLARE @estado_avion NVARCHAR(50);
//
//         -- Obtener aeropuerto de origen
//         SELECT @aeropuerto_origen_id = aeropuerto_origen_id
//         FROM ruta
//         WHERE id = @ruta_id;
//
//         -- Obtener estado y ubicación del avión
//         SELECT
//             @aeropuerto_actual_id = aeropuerto_actual_id,
//             @estado_avion = ea.nombre
//         FROM avion av
//                  INNER JOIN estado_avion ea ON av.estado_id = ea.id
//         WHERE av.id = @avion_id;
//
//         -- Validaciones
//         IF @aeropuerto_actual_id <> @aeropuerto_origen_id
//             BEGIN
//                 RAISERROR('El avión no se encuentra en el aeropuerto de origen.', 16, 1);
//                 RETURN;
//             END
//
//         IF EXISTS (
//             SELECT 1
//             FROM mantenimiento_programado
//             WHERE avion_id = @avion_id
//               AND estado = 'Programado'
//               AND @fecha_salida BETWEEN fecha_programada AND DATEADD(HOUR, 4, fecha_programada)
//         )
//             BEGIN
//                 RAISERROR('El avión tiene mantenimiento programado en ese horario.', 16, 1);
//                 RETURN;
//             END
//
//         IF EXISTS (
//             SELECT 1
//             FROM vuelo
//             WHERE avion_id = @avion_id
//               AND estado_id IN (1, 2, 3)
//               AND (
//                 (@fecha_salida BETWEEN fecha_salida AND fecha_llegada)
//                     OR (@fecha_llegada BETWEEN fecha_salida AND fecha_llegada)
//                     OR (fecha_salida BETWEEN @fecha_salida AND @fecha_llegada)
//                 )
//         )
//             BEGIN
//                 RAISERROR('El avión tiene otro vuelo en ese rango horario.', 16, 1);
//                 RETURN;
//             END
//
//         PRINT 'Validación correcta';
//     END;
// GO
//
//CREATE OR ALTER PROCEDURE SP_CREATE_VUELO
// (
//     @numero_vuelo NVARCHAR(10),
//     @aerolinea_id INT,
//     @ruta_id INT,
//     @avion_id INT,
//     @fecha_salida DATETIME
// )
// AS
// BEGIN
//     SET DATEFORMAT dmy;
//     SET NOCOUNT ON;
//
//     DECLARE @fecha_llegada DATETIME;
//     DECLARE @duracion_minutos INT;
//     
//     BEGIN TRY
//         BEGIN TRANSACTION;
//         --------------------------------------------------
//         -- Obtener duración de la ruta
//         --------------------------------------------------
//         SELECT @duracion_minutos = duracion_minutos
//         FROM V_RUTAS_AVION 
//         WHERE ruta_id = @ruta_id;
//
//         IF @duracion_minutos IS NULL
//             BEGIN
//                 RAISERROR('La ruta no existe.',16,1);
//                 RETURN;
//             END
//
//         --------------------------------------------------
//         -- Calcular fecha llegada automáticamente
//         --------------------------------------------------
//         SET @fecha_llegada = DATEADD(MINUTE, @duracion_minutos, @fecha_salida);
//         --Validar datos
//         EXEC SP_VALIDADICION_CREACION_VUELO
//              @avion_id,
//              @ruta_id,
//              @fecha_salida,
//              @fecha_llegada;
//
//         -- Insertar vuelo
//         INSERT INTO vuelo (
//             numero_vuelo,
//             aerolinea_id,
//             ruta_id,
//             avion_id,
//             fecha_salida,
//             fecha_llegada,
//             estado_id,
//             puerta,
//             capacidad_total,
//             pasajeros_confirmados,
//             pasajeros_embarcados
//         )
//         SELECT
//             @numero_vuelo,
//             @aerolinea_id,
//             @ruta_id,
//             @avion_id,
//             @fecha_salida,
//             @fecha_llegada,
//             1, -- Programado
//             '',
//             ma.capacidad_total,
//             0,
//             0
//         FROM avion av
//                  INNER JOIN modelo_avion ma ON av.modelo_id = ma.id
//         WHERE av.id = @avion_id;
//
//         SELECT 'Vuelo creado correctamente' AS Mensaje, SCOPE_IDENTITY() AS VueloId;
//
//         COMMIT TRANSACTION;
//
//     END TRY
//     BEGIN CATCH
//         IF @@TRANCOUNT > 0
//             ROLLBACK TRANSACTION;
//
//         DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
//         RAISERROR(@ErrorMessage, 16, 1);
//     END CATCH
// END;
// GO

// CREATE OR ALTER PROCEDURE SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA
//     @avion_id INT,
//     @fecha_salida_deseada DATETIME
// AS
// BEGIN
//     SET NOCOUNT ON;
//
//     DECLARE @aeropuerto_actual_id INT;
//     DECLARE @estado_avion NVARCHAR(50);
//
//     -----------------------------------------------------
//     -- Obtener ubicación y estado del avión
//     -----------------------------------------------------
//     SELECT
//         @aeropuerto_actual_id = av.aeropuerto_actual_id,
//         @estado_avion = ea.nombre
//     FROM avion av
//              INNER JOIN estado_avion ea ON av.estado_id = ea.id
//     WHERE av.id = @avion_id;
//
//     IF @aeropuerto_actual_id IS NULL
//         BEGIN
//             RAISERROR('El avión no existe.', 16, 1);
//             RETURN;
//         END
//
//     -----------------------------------------------------
//     -- Validar solapamiento de vuelos
//     -----------------------------------------------------
//     IF EXISTS (
//         SELECT 1
//         FROM vuelo v
//         WHERE v.avion_id = @avion_id
//           AND v.estado_id IN (1,2,3)
//           AND (
//             @fecha_salida_deseada BETWEEN v.fecha_salida AND v.fecha_llegada
//             )
//     )
//         BEGIN
//             SELECT
//                 'ERROR' AS Tipo,
//                 'El avión tiene vuelos programados en ese horario.' AS Mensaje;
//             RETURN;
//         END
//
//     -----------------------------------------------------
//     -- Validar mantenimiento
//     -----------------------------------------------------
//     IF EXISTS (
//         SELECT 1
//         FROM mantenimiento_programado mp
//         WHERE mp.avion_id = @avion_id
//           AND mp.estado = 'Programado'
//           AND @fecha_salida_deseada BETWEEN mp.fecha_programada
//             AND DATEADD(HOUR, 4, mp.fecha_programada)
//     )
//         BEGIN
//             SELECT
//                 'ERROR' AS Tipo,
//                 'El avión tiene mantenimiento programado en ese horario.' AS Mensaje;
//             RETURN;
//         END
//
//     -----------------------------------------------------
//     -- Obtener rutas disponibles con duración REAL
//     -----------------------------------------------------
//     SELECT
//         r.id AS ruta_id,
//         r.distancia_km,
//
//         ao.id AS aeropuerto_origen_id,
//         ao.codigo_iata AS codigo_origen,
//         ao.nombre AS nombre_origen,
//         ao.ciudad AS ciudad_origen,
//
//         ad.id AS aeropuerto_destino_id,
//         ad.codigo_iata AS codigo_destino,
//         ad.nombre AS nombre_destino,
//         ad.ciudad AS ciudad_destino,
//
//         -- Minutos totales estimados (velocidad media 800 km/h)
//         ROUND((r.distancia_km / 800.0) * 60, 0) AS duracion_minutos_totales,
//
//         -- Duración formateada tipo 4h 30min
//         CAST(ROUND((r.distancia_km / 800.0) * 60, 0) / 60 AS VARCHAR)
//             + 'h ' +
//         CAST(ROUND((r.distancia_km / 800.0) * 60, 0) % 60 AS VARCHAR)
//             + 'min' AS duracion_formateada,
//
//         -- Duración formato reloj HH:mm
//         FORMAT(
//                 DATEADD(
//                         MINUTE,
//                         ROUND((r.distancia_km / 800.0) * 60, 0),
//                         '19000101'
//                 ),
//                 'HH:mm'
//         ) AS duracion_HHMM,
//
//         -- Fecha llegada estimada correcta
//         DATEADD(
//                 MINUTE,
//                 ROUND((r.distancia_km / 800.0) * 60, 0),
//                 @fecha_salida_deseada
//         ) AS fecha_llegada_estimada,
//
//         ao.codigo_iata + ' → ' + ad.codigo_iata AS ruta_codigo,
//         ao.ciudad + ' (' + ao.codigo_iata + ') → ' +
//         ad.ciudad + ' (' + ad.codigo_iata + ')' AS ruta_descripcion
//
//     FROM ruta r
//              INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
//              INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
//     WHERE r.aeropuerto_origen_id = @aeropuerto_actual_id
//     ORDER BY r.distancia_km ASC;
//
// END;
// GO

// ALTER PROCEDURE SP_GET_RUTAS_POR_AVION @avion_id INT 
//     AS 
// BEGIN
//     SET NOCOUNT ON;
// DECLARE @aeropuerto_actual_id INT;
// ----------------------------------------------------- 
//     -- Obtener aeropuerto actual del avión
// -- ----------------------------------------------------- 
//     SELECT @aeropuerto_actual_id = aeropuerto_actual_id FROM avion WHERE id = @avion_id; 
// IF @aeropuerto_actual_id IS NULL 
// BEGIN 
// RAISERROR('El avión no existe.', 16, 1);
// RETURN;
// END
//     ----------------------------------------------------- -- 
//     -- Devolver rutas disponibles desde su ubicación
//         -- ----------------------------------------------------- 
//     SELECT r.id AS ruta_id, 
//     r.distancia_km,
// ao.codigo_iata AS codigo_origen,
//     ao.nombre AS nombre_origen, 
//     ao.ciudad AS ciudad_origen, 
//     ad.codigo_iata AS codigo_destino,
//     ad.nombre AS nombre_destino, 
//     ad.ciudad AS ciudad_destino,
//
//     CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) AS duracion_minutos,
//
// -- 2. Usamos ese valor para el formato (Horas y Minutos)
// CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) / 60 AS VARCHAR) + 'h ' +
//     CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) % 60 AS VARCHAR) + 'min'
// AS duracion_formateada
// FROM ruta r 
//     INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id 
// INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
// WHERE r.aeropuerto_origen_id = @aeropuerto_actual_id
// ORDER BY r.distancia_km ASC;
// END;
// GO

// CREATE OR ALTER VIEW V_RUTAS_AVION
// AS
// SELECT r.id AS ruta_id,
// r.distancia_km,
// ao.id AS id_origen,
// ao.codigo_iata AS codigo_origen,
// ao.nombre AS nombre_origen,
// ao.ciudad AS ciudad_origen,
// ad.id AS id_destino,
// ad.codigo_iata AS codigo_destino,
// ad.nombre AS nombre_destino,
// ad.ciudad AS ciudad_destino,
//
// CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) AS duracion_minutos,
//
// -- 2. Usamos ese valor para el formato (Horas y Minutos)
// CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) / 60 AS VARCHAR) + 'h ' +
// CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) % 60 AS VARCHAR) + 'min'
// AS duracion_formateada
// FROM ruta r
// INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
// INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
// GO

#endregion

public class RepositoryVuelos
{
    private readonly DataContext _context;
    private readonly IMemoryCache _memoryCache;

    public RepositoryVuelos(DataContext context, IMemoryCache memoryCache)
    {
        _context = context;
        _memoryCache = memoryCache;
    }


    public async Task<List<VistaVuelo>> GetVuelosAsync()
    {
        var consulta = from datos in _context.VistaVuelos
            select datos;

        return await consulta.ToListAsync();
    }   
    

    public async Task<(List<VistaVuelo> Vuelos, int TotalRegistros)> GetVuelosPaginadosConTotalAsync(
        int numPag,
        int numFilas,
        int? idEstado,
        int? idAerolinea,
        DateTime? fechaSalida,
        string? busqueda)
    {
        string sql = "EXEC SP_VUELOS_PAGINADO @PageNumber, @PageSize, @EstadoId, @AerolineaId, @FechaSalida, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);

        var pamEstado = new SqlParameter("@EstadoId", idEstado.HasValue ? idEstado.Value : DBNull.Value);
        var pamAerolinea = new SqlParameter("@AerolineaId", idAerolinea.HasValue ? idAerolinea.Value : DBNull.Value);

        // El SP espera DATE. Mandamos DateTime.Date (o DBNull)
        var pamSalida = new SqlParameter("@FechaSalida", fechaSalida.HasValue ? fechaSalida.Value.Date : DBNull.Value);

        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda!.Trim());

        var pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int);

        pamTotal.Direction = System.Data.ParameterDirection.Output;
        

        var lista = await _context.VistaVuelos
            .FromSqlRaw(sql, pamNumPagina, pamNumFilas, pamEstado, pamAerolinea, pamSalida, pamBusqueda, pamTotal)
            .ToListAsync();

        int total = 0;
        if (pamTotal.Value != DBNull.Value && pamTotal.Value != null)
        {
            total = (int)pamTotal.Value;
        }

        return (lista, total);
    }

    // Mantenemos el método antiguo por compatibilidad interna.
    public async Task<List<VistaVuelo>> GetVuelosAvanzadoAsync(int numPag, int numFilas, int? idEstado, int? idAerolinea,
        DateTime? fechaSalida, string? busqueda)
    {
        var (vuelos, _) = await GetVuelosPaginadosConTotalAsync(numPag, numFilas, idEstado, idAerolinea, fechaSalida, busqueda);
        return vuelos;
    }

    
    
    public async Task<Vuelo> FindVueloByIdAsync(int idVuelo)
    {
        var consulta = from datos in _context.Vuelos
            where datos.IdVuelo == idVuelo
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }

    public async Task<VistaVuelo> GetDatosVueloByIdAsync(int idVuelo)
    {
        var consulta = from datos in _context.VistaVuelos
            where datos.IdVuelo == idVuelo
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }

    public async Task<List<EstadoVuelo>> GetEstadosVuelosAync()
    {
        var consulta = from datos in _context.EstadoVuelos
            select datos;

        return await consulta.ToListAsync();
    }

    public async Task<int> GetEstadoVueloByIdAsync(int idVuelo)
    {
        var consulta = _context.Vuelos
            .Where(v => v.IdVuelo == idVuelo)
            .Select(v => v.IdEstado)
            .FirstOrDefaultAsync();
        return await consulta;
    }

    public async Task UpdateEstadoVueloAsync(int idVuelo, int idEstado)
    {
        // string sql = "SP_UPDATE_ESTADOVUELO @idvuelo,@idestado";

        var sql = "SP_UPDATE_ESTADO_VUELO @vuelo_id,@nuevo_estado_id";

        var pamVuelo = new SqlParameter("@vuelo_id", idVuelo);
        var pamEstado = new SqlParameter("@nuevo_estado_id", idEstado);

        await _context.Database.ExecuteSqlRawAsync(sql, pamVuelo, pamEstado);
    }


    public async Task CreateVueloAsync(string numeroVuelo, int idAerolinea, int idRuta,
        int idAvion, DateTime fechaSalida, string puerta)
    {
        var sql = "SP_CREATE_VUELO @numero_vuelo,@aerolinea_id,@ruta_id,@avion_id,@fecha_salida";


        var pamNumVuelo = new SqlParameter("@numero_vuelo", numeroVuelo);
        var pamAerolinea = new SqlParameter("@aerolinea_id", idAerolinea);
        var pamRuta = new SqlParameter("@ruta_id", idRuta);
        var pamAvion = new SqlParameter("@avion_id", idAvion);
        var pamSalida = new SqlParameter("@fecha_salida", fechaSalida);

        await _context.Database.ExecuteSqlRawAsync(sql, pamNumVuelo, pamAerolinea, pamRuta,
            pamAvion, pamSalida);
    }

    public async Task<List<Avion>> GetAvionesByAerolineaAsync(int idAerolinea)
    {
        var consulta = from datos in _context.Aviones
            where datos.IdAerolinea == idAerolinea
            select datos;

        return await consulta.ToListAsync();
    }

    public async Task<List<string>> GetNumeroVueloByAerolineaAsync(int idAerolinea)
    {
        var consulta = (from datos in _context.Vuelos
            where datos.IdAerolinea == idAerolinea
            select datos.NumeroVuelo).Distinct();

        return await consulta.ToListAsync();
    }


    public async Task<List<VistaRuta>> GetRutasDisponibles(int idAvion)
    {
        var idAeropuertoOrigen = await _context.Aviones
            .Where(a => a.IdAvion == idAvion)
            .Select(a => a.IdAeropuertoActual)
            .FirstOrDefaultAsync();


        if (idAeropuertoOrigen == 0)
            return new List<VistaRuta>();

        var rutas = await _context.VistaRutas
            .Where(r => r.IdOrigen == idAeropuertoOrigen)
            .ToListAsync();

        return rutas;
    }

    public async Task<List<VistaRuta>> GetRutasAerolinea()
    {
        var consulta = from datos in _context.VistaRutas
            select datos;


        return await consulta.ToListAsync();
    }


    public async Task UpdateDatosVuelo(int idVuelo, string numerovuelo, int aerolinea, int ruta, int avion,
        DateTime salida, DateTime llegada, int estado, string puerta, int capacidad, int confirmados, int embarcados,
        int[] idsTripulantes)
    {
        var sql = @"SP_UPDATE_VUELO @idvuelo, @numerovuelo, @idaerolinea,
                   @idruta, @idavion, @fechasalida, @fechallegada,
                   @idestado, @puerta, @capacidadtotal, @confirmados, @embarcados";

        var parametros = new[]
        {
            new SqlParameter("@idvuelo", idVuelo),
            new SqlParameter("@numerovuelo", numerovuelo),
            new SqlParameter("@idaerolinea", aerolinea),
            new SqlParameter("@idruta", ruta),
            new SqlParameter("@idavion", avion),
            new SqlParameter("@fechasalida", salida),
            new SqlParameter("@fechallegada", llegada),
            new SqlParameter("@idestado", estado),
            new SqlParameter("@puerta", puerta),
            new SqlParameter("@capacidadtotal", capacidad),
            new SqlParameter("@confirmados", confirmados),
            new SqlParameter("@embarcados", embarcados)
        };

        await _context.Database.ExecuteSqlRawAsync(sql, parametros);

        var sqlTripulantes = "SP_ASIGNAR_TRIPULACION @vuelo_id,@tripulante_id";

        foreach (var idTripulante in idsTripulantes)
        {
            var pamVuelo = new SqlParameter("@vuelo_id", idVuelo);
            var pamTripulante = new SqlParameter("@tripulante_id", idTripulante);
            await _context.Database.ExecuteSqlRawAsync(sqlTripulantes, pamVuelo, pamTripulante);
        }


        // Console.WriteLine();
    }

    public VueloCache GetVueloCache(int idVuelo)
    {
        var key = $"VUELO_{idVuelo}";
        _memoryCache.TryGetValue(key, out VueloCache vuelo);
        return vuelo;
    }
    
    public async Task<VueloCache> GetOrCreateVueloCacheAsync(int idVuelo, VistaVuelo vueloDb, TripulanteAsignado tripDb)
    {
        string key = $"VUELO_{idVuelo}";
        if (!_memoryCache.TryGetValue(key, out VueloCache cache))
        {
            cache = new VueloCache {
                IdVuelo = idVuelo,
                IdEstado = vueloDb.IdEstado,
                Puerta = vueloDb.Puerta,
                PasajerosConfirmados = vueloDb.PasajerosConfirmados,
                PasajerosEmbarcados = vueloDb.PasajerosEmbarcados,
                IdCapitan = tripDb.Comandante?.IdTripulante ?? 0,
                IdCopiloto = tripDb.Oficial?.IdTripulante ?? 0,
                IdsTcp = tripDb.Tcps?.Select(t => t.IdTripulante).ToList() ?? new List<int>()
            };
            SaveVueloCache(cache);
        }
        return cache;
    }

    public void SaveVueloCache(VueloCache datos)
    {
        // Nota: no forzamos cambios de estado aquí. La validación del paso se hace en ConfirmarVueloFinal/Commit.
        // Hacer "downgrade" de estado (2->1) provoca que el avance se pierda al recargar.

        string key = $"VUELO_{datos.IdVuelo}";
        _memoryCache.Set(key, datos, new MemoryCacheEntryOptions()
            .SetSlidingExpiration(TimeSpan.FromMinutes(20)));
    }

    private List<FormError> ValidarGestionVuelo(VueloCache datos)
    {
        var errores = new List<FormError>();
        if (datos.IdVuelo <= 0) errores.Add(new FormError { Field = "IdVuelo", Message = "Vuelo inválido." });

        // Reglas por estado (alineadas al UI)
        if (datos.IdEstado == 1)
        {
            if (datos.IdCapitan <= 0) errores.Add(new FormError { Field = "IdCapitan", Message = "Debe asignar un Comandante." });
            if (datos.IdCopiloto <= 0) errores.Add(new FormError { Field = "IdCopiloto", Message = "Debe asignar un Primer Oficial." });
            if (datos.IdsTcp == null || datos.IdsTcp.Count < 4)
                errores.Add(new FormError { Field = "IdsTcp", Message = "Se requiere un mínimo de 4 tripulantes de cabina (TCP)." });
        }

        if (datos.IdEstado == 2)
        {
            if (string.IsNullOrWhiteSpace(datos.Puerta))
                errores.Add(new FormError { Field = "Puerta", Message = "Debe asignar una puerta de embarque." });
            if (datos.PasajerosConfirmados <= 0)
                errores.Add(new FormError { Field = "PasajerosConfirmados", Message = "Los pasajeros confirmados deben ser mayor a 0." });
            if (datos.PasajerosEmbarcados < 0)
                errores.Add(new FormError { Field = "PasajerosEmbarcados", Message = "Los pasajeros embarcados no pueden ser negativos." });
            if (datos.PasajerosEmbarcados > datos.PasajerosConfirmados)
                errores.Add(new FormError { Field = "PasajerosEmbarcados", Message = "Los pasajeros embarcados no pueden superar a los confirmados." });
        }

        return errores;
    }

public async Task<(bool Success, string Message)> CommitVueloAsync(int idVuelo)
{
    // Recuperamos lo que el usuario tiene en la IMemoryCache
    var datos = GetVueloCache(idVuelo);
    if (datos == null) return (false, "No hay datos en el borrador.");

    var errores = ValidarGestionVuelo(datos);
    if (errores.Count > 0)
    {
        // Devolvemos un mensaje agregado (el controlador devolverá el detalle)
        return (false, "Hay datos inválidos. Revisa los errores del formulario.");
    }

    using (var transaction = await _context.Database.BeginTransactionAsync())
    {
        try
        {
            // 1. Actualizar el Vuelo (Estado, Puerta, Pasajeros)
            string sqlVuelo = "EXEC SP_UPDATE_GESTION_VUELO @id, @est, @ptr, @conf, @emb";
            await _context.Database.ExecuteSqlRawAsync(sqlVuelo, 
                new SqlParameter("@id", datos.IdVuelo),
                new SqlParameter("@est", datos.IdEstado),
                new SqlParameter("@ptr", (object)datos.Puerta ?? DBNull.Value),
                new SqlParameter("@conf", datos.PasajerosConfirmados),
                new SqlParameter("@emb", datos.PasajerosEmbarcados));

            // 2. Gestionar Tripulación (Solo si no ha despegado: Estado <= 1)
            if (datos.IdCapitan > 0 || 
                datos.IdCopiloto > 0 || 
                (datos.IdsTcp != null && datos.IdsTcp.Count > 0))
            {
                // LIMPIEZA DIRECTA: Borramos para que el SP de asignación no vea solapamientos
                await _context.Database.ExecuteSqlRawAsync("DELETE FROM asignacion_tripulacion WHERE vuelo_id = @id", 
                    new SqlParameter("@id", idVuelo));
                
                string sqlTrip = "EXEC SP_ASIGNAR_TRIPULACION @vuelo_id, @tripulante_id";
                
                if (datos.IdCapitan > 0)
                    await _context.Database.ExecuteSqlRawAsync(sqlTrip,
                        new SqlParameter("@vuelo_id", idVuelo),
                        new SqlParameter("@tripulante_id", datos.IdCapitan));

                if (datos.IdCopiloto > 0)
                    await _context.Database.ExecuteSqlRawAsync(sqlTrip,
                        new SqlParameter("@vuelo_id", idVuelo),
                        new SqlParameter("@tripulante_id", datos.IdCopiloto));

                foreach (var tcpId in datos.IdsTcp)
                {
                    await _context.Database.ExecuteSqlRawAsync(sqlTrip,
                        new SqlParameter("@vuelo_id", idVuelo),
                        new SqlParameter("@tripulante_id", tcpId));
                }
            }

            await transaction.CommitAsync();
            _memoryCache.Remove($"VUELO_{idVuelo}"); // Limpiar caché al terminar
            return (true, "Vuelo actualizado correctamente.");
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return (false, ex.Message);
        }
    }
}

    public async Task<(bool Success, string Message)> UpdateGestionVueloAsync(
        int idVuelo,
        int nuevoEstado,
        string puerta,
        int confirmados,
        int embarcados,
        int idCapitan,
        int idCopiloto,
        int[] idsTcp)
    {
        try
        {
            // 1. Actualizar datos básicos y estado mediante el SP dinámico
            var sqlVuelo =
                "EXEC SP_UPDATE_GESTION_VUELO @idvuelo, @nuevo_estado_id, @puerta, @confirmados, @embarcados";
            var paramVuelo = new[]
            {
                new SqlParameter("@idvuelo", idVuelo),
                new SqlParameter("@nuevo_estado_id", nuevoEstado),
                new SqlParameter("@puerta", (object)puerta ?? DBNull.Value),
                new SqlParameter("@confirmados", confirmados),
                new SqlParameter("@embarcados", embarcados)
            };
            await _context.Database.ExecuteSqlRawAsync(sqlVuelo, paramVuelo);

            // 2. Gestionar Tripulación (Solo si estamos en los primeros estados)
            // Nota: En una app real, aquí borraríamos asignaciones previas antes de re-insertar
            if (idCapitan > 0 || idCopiloto > 0 || (idsTcp != null && idsTcp.Length > 0))
            {
                var sqlTrip = "EXEC SP_ASIGNAR_TRIPULACION @vuelo_id, @tripulante_id";

                if (idCapitan > 0)
                    await _context.Database.ExecuteSqlRawAsync(sqlTrip, new SqlParameter("@vuelo_id", idVuelo),
                        new SqlParameter("@tripulante_id", idCapitan));

                if (idCopiloto > 0)
                    await _context.Database.ExecuteSqlRawAsync(sqlTrip, new SqlParameter("@vuelo_id", idVuelo),
                        new SqlParameter("@tripulante_id", idCopiloto));

                if (idsTcp != null)
                    foreach (var tcpId in idsTcp)
                        await _context.Database.ExecuteSqlRawAsync(sqlTrip, new SqlParameter("@vuelo_id", idVuelo),
                            new SqlParameter("@tripulante_id", tcpId));
            }

            return (true, "Actualización exitosa");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }

    public async Task<(bool Success, string Message)> RegistrarRetrasoAsync(int idVuelo, int minutos, int? idCodRetraso = null)
    {
        if (idVuelo <= 0) return (false, "Vuelo inválido");
        if (minutos <= 0) return (false, "Los minutos deben ser mayor que 0");

        try
        {
            // Validar que el vuelo exista
            bool existe = await _context.Vuelos.AnyAsync(v => v.IdVuelo == idVuelo);
            if (!existe) return (false, "El vuelo no existe");

            var retraso = new RetrasoVuelo
            {
                IdVuelo = idVuelo,
                Minutos = minutos,
                // Si no hay catálogo, mandamos 0 / 1 como valor por defecto
                IdCodRetraso = idCodRetraso ?? 1
            };

            _context.RetrasosVuelos.Add(retraso);
            await _context.SaveChangesAsync();

            return (true, $"Retraso registrado: +{minutos} min");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }
}











