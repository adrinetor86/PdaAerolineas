CREATE or alter  VIEW V_FLOTA_ESTADO AS
SELECT
    av.id               AS avion_id,
    av.matricula,
    al.nombre           AS aerolinea,
    m.fabricante,
    m.nombre_modelo,
    m.capacidad_total,
    ea.id               AS idestado,
    ea.nombre           AS estado,
    CASE
        WHEN aer.id IS NOT NULL THEN aer.nombre
        ELSE 'En Vuelo'
        END AS ubicacion,
    CASE
        WHEN aer.id IS NOT NULL THEN aer.codigo_iata
        ELSE 'N/A'
        END AS codigo_aeropuerto,
    av.horas_vuelo_totales,
    av.ciclos_totales,

    (
        SELECT MIN(mp.fecha_programada)
        FROM mantenimiento mp
        WHERE mp.avion_id = av.id
          AND mp.estado = 'Programado'
    ) AS proximo_mantenimiento,

    (
        SELECT TOP 1 v.numero_vuelo
        FROM vuelo v
        WHERE v.avion_id = av.id
          AND v.estado_id = 3
          AND v.fecha_salida <= GETDATE()
          AND (v.fecha_llegada IS NULL OR v.fecha_llegada >= GETDATE())
        ORDER BY v.fecha_salida DESC
    ) AS vuelo_actual

FROM avion av
         INNER JOIN modelo_avion m  ON av.modelo_id          = m.id
         INNER JOIN estado_avion ea ON av.estado_id           = ea.id
         INNER JOIN aerolinea al    ON av.aerolinea_id        = al.id
         LEFT  JOIN aeropuerto aer  ON av.aeropuerto_actual_id = aer.id
go

CREATE  or alter  VIEW V_MANTENIMIENTOS AS
select m.*,av.matricula,mod.nombre_modelo from mantenimiento as m

                                                   inner join avion as av on
    m.avion_id=av.id
                                                   inner join modelo_avion as mod on
    av.modelo_id=mod.id
go

create or alter  view V_PRUEBA_AVION
AS
SELECT a.ID,ae.nombre aerolinea,a.MATRICULA,m.nombre_modelo modelo,
       e.nombre estado, ap.nombre aeropuerto_actual,a.horas_vuelo_totales,a.ciclos_totales
FROM AVION as a
         inner join modelo_avion m
                    on a.modelo_id = m.id
         inner join aerolinea ae
                    on a.aerolinea_id = ae.id
         inner join estado_avion e on
    a.estado_id = e.id
         inner join aeropuerto ap on
    a.aeropuerto_actual_id = ap.id
go

CREATE or alter    VIEW V_RUTAS_AVION
AS
SELECT r.id AS ruta_id,
       r.distancia_km,
       ao.id AS id_origen,
       ao.codigo_iata AS codigo_origen,
       ao.nombre AS nombre_origen,
       ao.ciudad AS ciudad_origen,
       ao.latitud      AS latitud_origen,
       ao.longitud     AS longitud_origen,
       ad.id AS id_destino,
       ad.codigo_iata AS codigo_destino,
       ad.nombre AS nombre_destino,
       ad.ciudad AS ciudad_destino,
       ad.latitud      AS latitud_destino,
       ad.longitud     AS longitud_destino,

       CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) AS duracion_minutos,

       -- 2. Usamos ese valor para el formato (Horas y Minutos)
       CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) / 60 AS VARCHAR) + 'h ' +
       CAST(CAST(ROUND((r.distancia_km / 800.0) * 60, 0) AS INT) % 60 AS VARCHAR) + 'min'
           AS duracion_formateada
FROM ruta r
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
go

CREATE or alter   VIEW V_TRIPULACION_ROLES AS
SELECT
    t.id                            AS tripulante_id,
    t.nombre + ' ' + t.apellido     AS nombre_completo,
    t.rol,
    t.activo
FROM tripulante t
go

CREATE or alter    VIEW V_TRIPULACION_VUELOS AS
SELECT
    v.id                            AS vuelo_id,
    v.numero_vuelo,
    v.fecha_salida,
    ao.codigo_iata                  AS origen,
    ad.codigo_iata                  AS destino,
    t.id                            AS tripulante_id,
    t.nombre + ' ' + t.apellido     AS nombre_completo,
    t.rol
FROM vuelo v
         INNER JOIN asignacion_tripulacion at2 ON v.id   = at2.vuelo_id
         INNER JOIN tripulante t               ON at2.tripulante_id = t.id
         INNER JOIN ruta r                     ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao              ON r.aeropuerto_origen_id  = ao.id
         INNER JOIN aeropuerto ad              ON r.aeropuerto_destino_id = ad.id
go

CREATE  or alter   VIEW V_VUELOS AS
SELECT
    v.id AS vuelo_id,
    v.numero_vuelo,
    v.estado_id as id_estado,
    v.ruta_id as ruta,
    al.id as id_aerolinea,
    al.nombre AS aerolinea,

    -- Aeropuertos
    ao.nombre AS aeropuerto_origen,
    ao.codigo_iata AS codigo_origen,
    ao.ciudad AS ciudad_origen,
    ad.nombre AS aeropuerto_destino,
    ad.codigo_iata AS codigo_destino,
    ad.ciudad AS ciudad_destino,

    -- Avión
    av.id as avion,
    av.matricula,
    m.fabricante,
    m.nombre_modelo,

    -- Fechas y estado
    v.fecha_salida,
    v.fecha_llegada,
    ev.nombre AS estado_vuelo,
    CASE
        WHEN v.puerta IS NOT NULL THEN v.puerta
        ELSE 'Por Asignar'
        END AS PUERTA,

    -- Pasajeros
    v.capacidad_total,
    v.pasajeros_confirmados,
    v.pasajeros_embarcados,
    CAST(ROUND((v.pasajeros_confirmados * 100.0 / NULLIF(v.capacidad_total, 0)), 2)
        AS DECIMAL(5,2)) AS porcentaje_ocupacion,


    -- Ruta
    r.distancia_km
FROM vuelo v
         INNER JOIN aerolinea al ON v.aerolinea_id = al.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
         INNER JOIN avion av ON v.avion_id = av.id
         INNER JOIN modelo_avion m ON av.modelo_id = m.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
go

CREATE or alter  VIEW v_dashboard_operacional AS
SELECT
    (SELECT COUNT(*) FROM vuelo WHERE estado_id = 1 AND fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_programados_hoy,
    (SELECT COUNT(*) FROM vuelo WHERE estado_id = 3) AS vuelos_en_curso,
    (SELECT COUNT(*) FROM vuelo WHERE estado_id = 4 AND fecha_llegada >= CAST(GETDATE() AS DATE)) AS vuelos_aterrizados_hoy,
    (SELECT COUNT(*) FROM vuelo WHERE estado_id = 5 AND fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_cancelados_hoy,
    (SELECT COUNT(*) FROM vuelo WHERE estado_id = 6 AND fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_retrasados_hoy,
    (SELECT COUNT(*) FROM avion WHERE estado_id = 1) AS aviones_operativos,
    (SELECT COUNT(*) FROM avion WHERE estado_id = 2) AS aviones_en_mantenimiento,
    (SELECT COUNT(*) FROM avion WHERE estado_id = 3) AS aviones_en_vuelo,
    (SELECT AVG(CAST(pasajeros_confirmados AS FLOAT) / capacidad_total * 100)
     FROM vuelo
     WHERE fecha_salida >= CAST(GETDATE() AS DATE)) AS ocupacion_promedio_hoy
go

CREATE or alter  VIEW v_vuelos_completos AS
SELECT
    v.id AS vuelo_id,
    v.numero_vuelo,
    al.nombre AS aerolinea,
    al.codigo_iata AS codigo_aerolinea,

    -- Aeropuertos
    ao.nombre AS aeropuerto_origen,
    ao.codigo_iata AS codigo_origen,
    ao.ciudad AS ciudad_origen,
    ad.nombre AS aeropuerto_destino,
    ad.codigo_iata AS codigo_destino,
    ad.ciudad AS ciudad_destino,

    -- Avión
    av.matricula,
    m.fabricante,
    m.nombre_modelo,

    -- Fechas y estado
    v.fecha_salida,
    v.fecha_llegada,
    ev.nombre AS estado_vuelo,
    v.puerta,

    -- Pasajeros
    v.capacidad_total,
    v.pasajeros_confirmados,
    v.pasajeros_embarcados,
    CAST(ROUND((v.pasajeros_confirmados * 100.0 / v.capacidad_total), 2) AS DECIMAL(5,2)) AS porcentaje_ocupacion,

    -- Ruta
    r.distancia_km
FROM vuelo v
         INNER JOIN aerolinea al ON v.aerolinea_id = al.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
         INNER JOIN avion av ON v.avion_id = av.id
         INNER JOIN modelo_avion m ON av.modelo_id = m.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id;
go

CREATE  or alter  PROCEDURE SP_ASIGNAR_TRIPULACION
    @vuelo_id      INT,
    @tripulante_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM tripulante WHERE id = @tripulante_id AND activo = 1)
            BEGIN
                RAISERROR('El tripulante no está activo.', 16, 1);
                RETURN;
            END

        IF EXISTS (
            SELECT 1
            FROM asignacion_tripulacion at2
                     INNER JOIN vuelo v1 ON at2.vuelo_id = v1.id
                     INNER JOIN vuelo v2 ON v2.id = @vuelo_id
            WHERE
                at2.tripulante_id = @tripulante_id
              AND v1.estado_id IN (1, 2, 3)
              AND v2.fecha_salida  < v1.fecha_llegada
              AND v2.fecha_llegada > v1.fecha_salida
        )
            BEGIN
                RAISERROR('El tripulante ya está asignado a otro vuelo en ese horario.', 16, 1);
                RETURN;
            END

        INSERT INTO asignacion_tripulacion (tripulante_id, vuelo_id)
        VALUES (@tripulante_id, @vuelo_id);

        COMMIT TRANSACTION;

        SELECT 'Tripulación asignada exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@err, 16, 1);
    END CATCH
END;
go

CREATE or alter  PROCEDURE SP_CREATE_AVION
(@matricula nvarchar(20),@modelo int,@aerolinea int,@estado int,@aeropuertoactual int,@horasvuelo int,@ciclos int)
AS
INSERT INTO AVION (matricula, modelo_id, aerolinea_id, estado_id, aeropuerto_actual_id, horas_vuelo_totales, ciclos_totales) VALUES
    (@matricula,
     @modelo,
     @aerolinea,
     @estado,
     @aeropuertoactual,
     @horasvuelo,
     @ciclos)
go

CREATE   PROCEDURE SP_CREATE_VUELO
(
    @numero_vuelo NVARCHAR(10),
    @aerolinea_id INT,
    @ruta_id INT,
    @avion_id INT,
    @fecha_salida DATETIME
)
AS
BEGIN
    SET DATEFORMAT dmy;
    SET NOCOUNT ON;

    DECLARE @fecha_llegada DATETIME;
    DECLARE @duracion_minutos INT;

    BEGIN TRY
        BEGIN TRANSACTION;
        --------------------------------------------------
        -- Obtener duración de la ruta
        --------------------------------------------------
        SELECT @duracion_minutos = duracion_minutos
        FROM V_RUTAS_AVION
        WHERE ruta_id = @ruta_id;

        IF @duracion_minutos IS NULL
            BEGIN
                RAISERROR('La ruta no existe.',16,1);
                RETURN;
            END

        --------------------------------------------------
        -- Calcular fecha llegada automáticamente
        --------------------------------------------------
        SET @fecha_llegada = DATEADD(MINUTE, @duracion_minutos, @fecha_salida);
        --Validar datos
        EXEC SP_VALIDADICION_CREACION_VUELO
             @avion_id,
             @ruta_id,
             @fecha_salida,
             @fecha_llegada;

        -- Insertar vuelo
        INSERT INTO vuelo (
            numero_vuelo,
            aerolinea_id,
            ruta_id,
            avion_id,
            fecha_salida,
            fecha_llegada,
            estado_id,
            puerta,
            capacidad_total,
            pasajeros_confirmados,
            pasajeros_embarcados
        )
        SELECT
            @numero_vuelo,
            @aerolinea_id,
            @ruta_id,
            @avion_id,
            @fecha_salida,
            @fecha_llegada,
            1, -- Programado
            '',
            ma.capacidad_total,
            0,
            0
        FROM avion av
                 INNER JOIN modelo_avion ma ON av.modelo_id = ma.id
        WHERE av.id = @avion_id;

        SELECT 'Vuelo creado correctamente' AS Mensaje, SCOPE_IDENTITY() AS VueloId;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
go

CREATE OR ALTER PROCEDURE SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA
    @avion_id            INT,
    @fecha_salida_deseada DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @aeropuerto_actual_id INT;
    DECLARE @estado_avion         NVARCHAR(50);

    SELECT
        @aeropuerto_actual_id = av.aeropuerto_actual_id,
        @estado_avion         = ea.nombre
    FROM avion av
             INNER JOIN estado_avion ea ON av.estado_id = ea.id
    WHERE av.id = @avion_id;

    IF @aeropuerto_actual_id IS NULL
        BEGIN
            RAISERROR('El avión no existe.', 16, 1);
            RETURN;
        END

    IF EXISTS (
        SELECT 1 FROM vuelo v
        WHERE v.avion_id = @avion_id
          AND v.estado_id IN (1, 2, 3)
          AND @fecha_salida_deseada BETWEEN v.fecha_salida AND v.fecha_llegada
    )
        BEGIN
            SELECT 'ERROR' AS Tipo, 'El avión tiene vuelos programados en ese horario.' AS Mensaje;
            RETURN;
        END

    IF EXISTS (
        SELECT 1 FROM mantenimiento mp
        WHERE mp.avion_id = @avion_id
          AND mp.estado = 'Programado'
          AND @fecha_salida_deseada BETWEEN mp.fecha_programada
            AND DATEADD(HOUR, 4, mp.fecha_programada)
    )
        BEGIN
            SELECT 'ERROR' AS Tipo, 'El avión tiene mantenimiento programado en ese horario.' AS Mensaje;
            RETURN;
        END

    SELECT
        r.id            AS ruta_id,
        r.distancia_km,
        ao.id           AS aeropuerto_origen_id,
        ao.codigo_iata  AS codigo_origen,
        ao.nombre       AS nombre_origen,
        ao.ciudad       AS ciudad_origen,
        ao.latitud      AS latitud_origen,
        ao.longitud     AS longitud_origen,
        ad.id           AS aeropuerto_destino_id,
        ad.codigo_iata  AS codigo_destino,
        ad.nombre       AS nombre_destino,
        ad.ciudad       AS ciudad_destino,
        ad.latitud      AS latitud_destino,
        ad.longitud     AS longitud_destino,
        ROUND((r.distancia_km / 800.0) * 60, 0)                          AS duracion_minutos_totales,
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) / 60 AS VARCHAR)
            + 'h ' +
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) % 60 AS VARCHAR)
            + 'min'                                                        AS duracion_formateada,
        FORMAT(DATEADD(MINUTE, ROUND((r.distancia_km / 800.0) * 60, 0), '19000101'), 'HH:mm') AS duracion_HHMM,
        DATEADD(MINUTE, ROUND((r.distancia_km / 800.0) * 60, 0), @fecha_salida_deseada)       AS fecha_llegada_estimada,
        ao.codigo_iata + ' → ' + ad.codigo_iata                           AS ruta_codigo,
        ao.ciudad + ' (' + ao.codigo_iata + ') → ' +
        ad.ciudad + ' (' + ad.codigo_iata + ')'                           AS ruta_descripcion
    FROM ruta r
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id  = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE r.aeropuerto_origen_id = @aeropuerto_actual_id
    ORDER BY r.distancia_km ASC;
END;
GO

CREATE or alter   PROCEDURE SP_GET_RUTAS_POR_AVION
@avion_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @aeropuerto_actual_id INT;

    SELECT @aeropuerto_actual_id = aeropuerto_actual_id
    FROM avion WHERE id = @avion_id;

    IF @aeropuerto_actual_id IS NULL
        BEGIN
            RAISERROR('El avión no existe.', 16, 1);
            RETURN;
        END

    SELECT
        r.id            AS ruta_id,
        r.distancia_km,
        ao.codigo_iata  AS codigo_origen,
        ao.nombre       AS nombre_origen,
        ao.ciudad       AS ciudad_origen,
        ao.latitud      AS latitud_origen,
        ao.longitud     AS longitud_origen,
        ad.codigo_iata  AS codigo_destino,
        ad.nombre       AS nombre_destino,
        ad.ciudad       AS ciudad_destino,
        ad.latitud      AS latitud_destino,
        ad.longitud     AS longitud_destino,
        ROUND((r.distancia_km / 800.0) * 60, 0) AS duracion_minutos,
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) / 60 AS VARCHAR)
            + 'h ' +
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) % 60 AS VARCHAR)
            + 'min' AS duracion_formateada
    FROM ruta r
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id  = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE r.aeropuerto_origen_id = @aeropuerto_actual_id
    ORDER BY r.distancia_km ASC;
END;
go

CREATE or alter   PROCEDURE SP_GET_TRIPULANTES_DISPONIBLES
    @vuelo_id INT,
    @rol      NVARCHAR(50) = NULL  -- 'Comandante' | 'Primer Oficial' | 'Tripulante de Cabina' | NULL = todos
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_salida  DATETIME;
    DECLARE @fecha_llegada DATETIME;

    SELECT
        @fecha_salida  = fecha_salida,
        @fecha_llegada = fecha_llegada
    FROM vuelo
    WHERE id = @vuelo_id;

    IF @fecha_salida IS NULL
        BEGIN
            RAISERROR('El vuelo no existe.', 16, 1);
            RETURN;
        END

    SELECT
        t.id                            AS tripulante_id,
        t.nombre + ' ' + t.apellido     AS nombre_completo,
        t.rol
    FROM tripulante t
    WHERE
        t.activo = 1

      -- Filtro por rol si se envía
      AND (@rol IS NULL OR t.rol = @rol)

      -- No asignado ya a este vuelo
      AND t.id NOT IN (
        SELECT tripulante_id
        FROM asignacion_tripulacion
        WHERE vuelo_id = @vuelo_id
    )

      -- Sin solapamiento horario
      AND t.id NOT IN (
        SELECT at2.tripulante_id
        FROM asignacion_tripulacion at2
                 INNER JOIN vuelo v ON at2.vuelo_id = v.id
        WHERE
            at2.vuelo_id    <> @vuelo_id
          AND v.estado_id NOT IN (4, 5)
          AND @fecha_salida  < v.fecha_llegada
          AND @fecha_llegada > v.fecha_salida
    )

    ORDER BY t.rol, nombre_completo;
END;
go

CREATE  or alter   PROCEDURE SP_GET_TRIPULANTES_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM vuelo WHERE id = @vuelo_id)
        BEGIN
            RAISERROR('El vuelo no existe.', 16, 1);
            RETURN;
        END

    -- 1️⃣ Comandantes
    SELECT
        t.id,
        t.nombre ,
        t.apellido,
        t.rol,
        t.activo
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id
      AND t.rol = 'Comandante'
    UNION
-- 2️⃣ Primeros Oficiales
    SELECT
        t.id                    ,
        t.nombre ,
        t.apellido,
        t.rol,
        t.activo
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id
      AND t.rol = 'Primer Oficial'

    UNION

    SELECT
        t.id                        ,
        t.nombre ,
        t.apellido,
        t.rol,
        t.activo
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id
      AND t.rol = 'Tripulante de Cabina';

END;
go

CREATE PROCEDURE SP_UPDATE_ESTADOVUELO
(@idvuelo int, @idestado int)
AS
UPDATE VUELO SET estado_id=@idestado
WHERE id=@idvuelo
go

CREATE or alter  PROCEDURE SP_UPDATE_ESTADO_VUELO
(
    @vuelo_id INT,
    @nuevo_estado_id INT,
    @fecha_actualizacion DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_actualizacion IS NULL
        SET @fecha_actualizacion = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que el vuelo existe
        IF NOT EXISTS (SELECT 1 FROM vuelo WHERE id = @vuelo_id)
            BEGIN
                RAISERROR('El vuelo no existe', 16, 1);
                RETURN;
            END

        DECLARE @avion_id INT;
        DECLARE @estado_actual INT;

        SELECT @avion_id = avion_id, @estado_actual = estado_id
        FROM vuelo
        WHERE id = @vuelo_id;

-- Actualizar estado del vuelo
        UPDATE vuelo
        SET estado_id = @nuevo_estado_id
        WHERE id = @vuelo_id;

-- Si el vuelo despega (estado 3 - En Vuelo)
        IF @nuevo_estado_id = 3 AND @estado_actual != 3
            BEGIN
                UPDATE avion
                SET estado_id = 3,
                    aeropuerto_actual_id = 1
                WHERE id = @avion_id;

                UPDATE avion
                SET ciclos_totales = ciclos_totales + 1
                WHERE id = @avion_id;
            END

        IF @nuevo_estado_id = 5 AND @estado_actual != 5
            BEGIN

                UPDATE avion
                SET estado_id = 5
                WHERE id = @avion_id;
            END
        -- Si el vuelo aterriza (estado 4 - Aterrizado)
        IF @nuevo_estado_id = 4 AND @estado_actual = 3
            BEGIN
                DECLARE @aeropuerto_destino_id INT;
                DECLARE @duracion_vuelo_horas DECIMAL(10,2);
                DECLARE @latitud DECIMAL(9,6);
                DECLARE @longitud DECIMAL(9,6);

                -- Obtener aeropuerto destino y duración
                SELECT @aeropuerto_destino_id = r.aeropuerto_destino_id
                FROM vuelo v
                         INNER JOIN ruta r ON v.ruta_id = r.id
                WHERE v.id = @vuelo_id;

                SELECT @duracion_vuelo_horas = DATEDIFF(MINUTE, fecha_salida, @fecha_actualizacion) / 60.0
                FROM vuelo
                WHERE id = @vuelo_id;

-- Obtener coordenadas del aeropuerto
                SELECT @latitud = latitud, @longitud = longitud
                FROM aeropuerto
                WHERE id = @aeropuerto_destino_id;

-- Actualizar avión
                UPDATE avion
                SET estado_id = 5,
                    aeropuerto_actual_id = @aeropuerto_destino_id,
                    horas_vuelo_totales = horas_vuelo_totales + CEILING(@duracion_vuelo_horas)
                WHERE id = @avion_id;

-- Registrar posición
                INSERT INTO registro_estado_avion (avion_id, aeropuerto_id, latitud, longitud, fecha_hora)
                VALUES (@avion_id, @aeropuerto_destino_id, @latitud, @longitud, @fecha_actualizacion);
            END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END;
go

CREATE  or alter  PROCEDURE SP_UPDATE_VUELO
(@idvuelo int,@numerovuelo nvarchar(50), @idaerolinea int,
 @idruta int,@idavion int, @fechasalida datetime,
 @fechallegada datetime, @idestado int,@puerta nvarchar(10),
 @capacidadtotal int,@confirmados int,@embarcados int)
AS

UPDATE VUELO SET numero_vuelo=@numerovuelo,aerolinea_id=@idaerolinea,
                 ruta_id=@idruta,avion_id=@idavion,fecha_salida=@fechasalida,
                 fecha_llegada=@fechallegada,estado_id=@idestado,puerta=@puerta,
                 capacidad_total=@capacidadtotal,pasajeros_confirmados=@confirmados,
                 pasajeros_embarcados=@embarcados
WHERE id=@idvuelo;
go

CREATE   PROCEDURE SP_VALIDADICION_CREACION_VUELO
    @avion_id      INT,
    @ruta_id       INT,
    @fecha_salida  DATETIME,
    @fecha_llegada DATETIME
AS
BEGIN
    DECLARE @aeropuerto_origen_id INT;
    DECLARE @aeropuerto_actual_id INT;
    DECLARE @estado_avion         NVARCHAR(50);

    SELECT @aeropuerto_origen_id = aeropuerto_origen_id
    FROM ruta WHERE id = @ruta_id;

    SELECT
        @aeropuerto_actual_id = aeropuerto_actual_id,
        @estado_avion         = ea.nombre
    FROM avion av
             INNER JOIN estado_avion ea ON av.estado_id = ea.id
    WHERE av.id = @avion_id;

    IF @aeropuerto_actual_id <> @aeropuerto_origen_id
        BEGIN
            RAISERROR('El avión no se encuentra en el aeropuerto de origen.', 16, 1);
            RETURN;
        END

    IF @estado_avion <> 'Operativo'
        BEGIN
            RAISERROR('El avión no está en estado operativo.', 16, 1);
            RETURN;
        END

    IF EXISTS (
        SELECT 1 FROM mantenimiento
        WHERE avion_id = @avion_id
          AND estado = 'Programado'
          AND @fecha_salida BETWEEN fecha_programada AND DATEADD(HOUR, 4, fecha_programada)
    )
        BEGIN
            RAISERROR('El avión tiene mantenimiento programado en ese horario.', 16, 1);
            RETURN;
        END

    IF EXISTS (
        SELECT 1 FROM vuelo
        WHERE avion_id = @avion_id
          AND (
            (@fecha_salida  BETWEEN fecha_salida AND fecha_llegada)
                OR (@fecha_llegada BETWEEN fecha_salida AND fecha_llegada)
            )
    )
        BEGIN
            RAISERROR('El avión tiene otro vuelo en ese rango horario.', 16, 1);
            RETURN;
        END

    PRINT 'VALIDACIÓN CORRECTA';
END;
go

CREATE OR ALTER PROCEDURE SP_VALIDAR_TRIPULACION_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Contadores por rol
    DECLARE @comandantes INT = 0;
    DECLARE @oficiales   INT = 0;
    DECLARE @tcps        INT = 0;
    DECLARE @total       INT = 0;

    SELECT
        @comandantes = SUM(CASE WHEN t.rol = 'Comandante'           THEN 1 ELSE 0 END),
        @oficiales   = SUM(CASE WHEN t.rol = 'Primer Oficial'       THEN 1 ELSE 0 END),
        @tcps        = SUM(CASE WHEN t.rol = 'Tripulante de Cabina' THEN 1 ELSE 0 END),
        @total       = COUNT(*)
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id;

    -- Sin tripulación asignada
    IF @total = 0
        BEGIN
            SELECT
                0           AS valido,
                'SIN_TRIPULACION' AS codigo,
                'El vuelo no tiene tripulación asignada.' AS mensaje;
            RETURN;
        END

    -- Validar comandante
    IF @comandantes = 0
        BEGIN
            SELECT 0 AS valido, 'FALTA_COMANDANTE' AS codigo,
                   'El vuelo debe tener un Comandante.' AS mensaje;
            RETURN;
        END

    IF @comandantes > 1
        BEGIN
            SELECT 0 AS valido, 'EXCESO_COMANDANTES' AS codigo,
                   'El vuelo solo puede tener 1 Comandante. Hay ' + CAST(@comandantes AS VARCHAR) + '.' AS mensaje;
            RETURN;
        END

    -- Validar primer oficial
    IF @oficiales = 0
        BEGIN
            SELECT 0 AS valido, 'FALTA_OFICIAL' AS codigo,
                   'El vuelo debe tener un Primer Oficial.' AS mensaje;
            RETURN;
        END

    IF @oficiales > 1
        BEGIN
            SELECT 0 AS valido, 'EXCESO_OFICIALES' AS codigo,
                   'El vuelo solo puede tener 1 Primer Oficial. Hay ' + CAST(@oficiales AS VARCHAR) + '.' AS mensaje;
            RETURN;
        END

    -- Validar TCPs
    IF @tcps < 4
        BEGIN
            SELECT 0 AS valido, 'POCOS_TCPS' AS codigo,
                   'El vuelo debe tener al menos 4 Tripulantes de Cabina. Hay ' + CAST(@tcps AS VARCHAR) + '.' AS mensaje;
            RETURN;
        END

    -- Todo correcto
    SELECT
        1                   AS valido,
        'OK'                AS codigo,
        'Tripulación completa: 1 Comandante, 1 Primer Oficial, ' + CAST(@tcps AS VARCHAR) + ' TCPs.' AS mensaje;
END;
GO
