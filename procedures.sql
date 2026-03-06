create table dbo.usuario
(
    id           int identity
        primary key,
    nombre       nvarchar(50)  not null,
    apellidos    nvarchar(50)  not null,
    email        nvarchar(100) not null
        unique,
    password     nvarchar(100) not null
        unique,
    aerolinea_id int           not null
        references dbo.aerolinea,
    activo       bit default 1 not null
)
go

create     view V_AVIONES
AS
SELECT a.ID,
       ae.id as idAerolinea,
       ae.nombre aerolinea,
       a.MATRICULA,
       m.nombre_modelo modelo,
       e.nombre estado,
       ap.nombre aeropuerto_actual,
       a.horas_vuelo_totales,
       a.ciclos_totales

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

CREATE   VIEW V_DATOS_USUARIO AS
select u.id,u.aerolinea_id,u.email,u.password,us.salt,us.pass from usuario u
                                                                       inner join users_security us on  u.id=us.id_usuario
go

CREATE      VIEW V_FLOTA_ESTADO AS
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

CREATE   VIEW V_LOGED_USER
AS
select
    u.id as idUsuario,
    u.aerolinea_id as idAerolinea,
    u.nombre,
    ur.rol_id

from usuario u
         inner join usuario_rol ur on u.id= ur.usuario_id
go

CREATE    VIEW V_MANTENIMIENTOS AS
select m.*,
       av.aerolinea_id         AS AEROLINEA_ID,
       mt.nombre as tipo,
       av.matricula,
       mod.nombre_modelo
from mantenimiento as m
         inner join avion as av on m.avion_id = av.id
         inner join modelo_avion as mod on av.modelo_id = mod.id
         inner join mantenimiento_tipo as mt on m.mantenimiento_tipo_id=mt.id
go

create      view V_PRUEBA_AVION
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

CREATE   VIEW V_RETRASOS_DETALLADOS AS
SELECT
    rv.id AS retraso_id,
    v.id AS id_vuelo,
    v.numero_vuelo,
    v.fecha_salida,
    ao.codigo_iata AS origen,
    ad.codigo_iata AS destino,
    cr.codigo AS codigo_retraso,
    cr.descripcion AS motivo_retraso,
    rv.minutos AS minutos_retraso,
    CASE
        WHEN rv.minutos <= 15 THEN 'Menor'
        WHEN rv.minutos <= 60 THEN 'Moderado'
        WHEN rv.minutos <= 180 THEN 'Significativo'
        ELSE 'Severo'
        END AS categoria_retraso
FROM retraso_vuelo rv
         INNER JOIN vuelo v ON rv.vuelo_id = v.id
         INNER JOIN codigo_retraso_iata cr ON rv.codigo_retraso_id = cr.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
go

CREATE        VIEW V_RUTAS_AVION
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

CREATE    or alter   VIEW V_TRIPULACION_ROLES AS
SELECT
    t.id                            AS tripulante_id,
    t.id_aerolinea                            AS aerolinea_id,
    t.nombre + ' ' + t.apellido     AS nombre_completo,
    t.rol,
    t.activo
FROM tripulante t
go

CREATE        VIEW V_TRIPULACION_VUELOS AS
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

CREATE        VIEW V_VUELOS AS
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

CREATE   VIEW V_VUELOS_TRACKING AS
WITH VuelosConProgreso AS (
    SELECT
        v.id AS vuelo_id,
        v.numero_vuelo,
        v.estado_id,
        al.nombre AS aerolinea,
        av.matricula,
        m.fabricante,
        m.nombre_modelo,
        ao.codigo_iata AS codigo_origen,
        ao.ciudad AS ciudad_origen,
        ao.latitud AS lat_origen,
        ao.longitud AS lng_origen,
        ad.codigo_iata AS codigo_destino,
        ad.ciudad AS ciudad_destino,
        ad.latitud AS lat_destino,
        ad.longitud AS lng_destino,
        v.fecha_salida,
        v.fecha_llegada,
        ev.nombre AS estado_vuelo,
        r.distancia_km,

        -- ✅ Calcular progreso una sola vez
        CASE
            WHEN v.estado_id = 3 AND GETDATE() BETWEEN v.fecha_salida AND v.fecha_llegada THEN
                CAST(DATEDIFF(MINUTE, v.fecha_salida, GETDATE()) AS FLOAT) /
                NULLIF(DATEDIFF(MINUTE, v.fecha_salida, v.fecha_llegada), 0)
            ELSE NULL
            END AS progreso_calculado

    FROM vuelo v
             INNER JOIN aerolinea al ON v.aerolinea_id = al.id
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
             INNER JOIN avion av ON v.avion_id = av.id
             INNER JOIN modelo_avion m ON av.modelo_id = m.id
             INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
)
SELECT
    vuelo_id,
    numero_vuelo,
    estado_id,
    aerolinea,
    matricula,
    fabricante,
    nombre_modelo,
    codigo_origen,
    ciudad_origen,
    lat_origen,
    lng_origen,
    codigo_destino,
    ciudad_destino,
    lat_destino,
    lng_destino,
    fecha_salida,
    fecha_llegada,
    estado_vuelo,
    distancia_km,
    progreso_calculado AS progreso,

    -- ✅ Latitud actual
    CASE
        WHEN estado_id = 3 AND progreso_calculado IS NOT NULL THEN
            lat_origen + (lat_destino - lat_origen) * progreso_calculado
        WHEN estado_id IN (1, 2) THEN lat_origen
        ELSE lat_destino
        END AS latitud_actual,

    -- ✅ Longitud actual
    CASE
        WHEN estado_id = 3 AND progreso_calculado IS NOT NULL THEN
            lng_origen + (lng_destino - lng_origen) * progreso_calculado
        WHEN estado_id IN (1, 2) THEN lng_origen
        ELSE lng_destino
        END AS longitud_actual,

    -- ✅ Altitud (ahora puede usar progreso_calculado)
    CASE
        WHEN estado_id = 3 AND progreso_calculado IS NOT NULL THEN
            CASE
                WHEN progreso_calculado < 0.1 THEN progreso_calculado * 10 * 35000
                WHEN progreso_calculado > 0.9 THEN (1 - progreso_calculado) * 10 * 35000
                ELSE 35000
                END
        ELSE 0
        END AS altitud_pies

FROM VuelosConProgreso
go

CREATE      VIEW v_dashboard_operacional AS
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

CREATE      VIEW v_vuelos_completos AS
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
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
go

CREATE   PROCEDURE SP_ACTUALIZAR_ESTADO_MANTENIMIENTO
    @mantenimiento_id INT,
    @nuevo_estado NVARCHAR(50) -- 'Programado', 'En Curso', 'Completado', 'Cancelado'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @avion_id INT;
    DECLARE @estado_actual NVARCHAR(50);
    DECLARE @fecha_actual DATETIME = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Obtener datos actuales del mantenimiento
        SELECT @avion_id = avion_id, @estado_actual = estado
        FROM mantenimiento
        WHERE id = @mantenimiento_id;

        IF @avion_id IS NULL
            BEGIN
                RAISERROR('El registro de mantenimiento no existe.', 16, 1);
                RETURN;
            END

        IF @estado_actual = @nuevo_estado
            BEGIN
                RAISERROR('El mantenimiento ya se encuentra en ese estado.', 16, 1);
                RETURN;
            END

        -- 2. Transición a "En Curso"
        IF @nuevo_estado = 'En Curso'
            BEGIN
                UPDATE mantenimiento
                SET estado = 'En Curso',
                    fecha_inicio = @fecha_actual
                WHERE id = @mantenimiento_id;

                -- Bloquear el avión (estado_id = 2 es 'En Mantenimiento' según tus INSERTS)
                UPDATE avion SET estado_id = 2 WHERE id = @avion_id;
            END

            -- 3. Transición a "Completado"
        ELSE IF @nuevo_estado = 'Completado'
            BEGIN
                UPDATE mantenimiento
                SET estado = 'Completado',
                    fecha_fin = @fecha_actual
                WHERE id = @mantenimiento_id;

                -- Liberar el avión (estado_id = 1 es 'Operativo')
                UPDATE avion SET estado_id = 1 WHERE id = @avion_id;
            END

            -- 4. Transición a "Cancelado"
        ELSE IF @nuevo_estado = 'Cancelado'
            BEGIN
                UPDATE mantenimiento
                SET estado = 'Cancelado',
                    fecha_fin = @fecha_actual -- Marcamos el fin aunque sea por cancelación
                WHERE id = @mantenimiento_id;

                -- Si se cancela mientras estaba "En Curso", devolvemos el avión a Operativo
                IF @estado_actual = 'En Curso'
                    BEGIN
                        UPDATE avion SET estado_id = 1 WHERE id = @avion_id;
                    END
            END
        ELSE
            BEGIN
                RAISERROR('Estado no válido. Use: En Curso, Completado o Cancelado.', 16, 1);
                RETURN;
            END

        COMMIT TRANSACTION;
        SELECT 'Estado actualizado correctamente' AS Mensaje;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Error NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Error, 16, 1);
    END CATCH
END;
go

CREATE      PROCEDURE SP_ASIGNAR_TRIPULACION
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

CREATE      PROCEDURE SP_CREATE_AVION
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

CREATE or alter    PROCEDURE SP_CREATE_VUELO
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
        --SET @fecha_llegada = DATEADD(MINUTE, @duracion_minutos, @fecha_salida);
        SET @fecha_llegada = DATEADD(MINUTE, @duracion_minutos, CAST(@fecha_salida AS DATETIME));
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

CREATE     PROCEDURE SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA
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
go

CREATE       PROCEDURE SP_GET_RUTAS_POR_AVION
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

CREATE or alter      PROCEDURE SP_GET_TRIPULANTES_DISPONIBLES
    @vuelo_id INT,
    @aerolinea_id INT,
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
        AND t.id_aerolinea=@aerolinea_id

      -- Filtro por rol si se envía
      AND (@rol IS NULL OR t.rol = @rol)

      -- No asignado ya a este vuelo
      AND t.id NOT IN (
        SELECT tripulante_id
        FROM asignacion_tripulacion
        WHERE vuelo_id = @vuelo_id
          AND t.id_aerolinea=@aerolinea_id
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
          AND t.id_aerolinea=@aerolinea_id
    )

    ORDER BY t.rol, nombre_completo;
END;
go

CREATE    PROCEDURE SP_GET_TRIPULANTES_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Comandantes (Ensure column names match the C# Mapper)
    SELECT
        t.id       AS ID,
        t.nombre   AS NOMBRE,
        t.apellido AS APELLIDO,
        t.rol      AS ROL,
        1          AS ACTIVO -- Adding a dummy 'Activo' if needed by your model
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id AND t.rol = 'Comandante';

    -- 2️⃣ Primeros Oficiales
    SELECT t.id AS ID, t.nombre AS NOMBRE, t.apellido AS APELLIDO, t.rol AS ROL, 1 AS ACTIVO
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id AND t.rol = 'Primer Oficial';

    -- 3️⃣ Tripulantes de Cabina
    SELECT t.id AS ID, t.nombre AS NOMBRE, t.apellido AS APELLIDO, t.rol AS ROL, 1 AS ACTIVO
    FROM asignacion_tripulacion at2
             INNER JOIN tripulante t ON at2.tripulante_id = t.id
    WHERE at2.vuelo_id = @vuelo_id AND t.rol = 'Tripulante de Cabina';
END;
go

CREATE   PROCEDURE SP_GUARDAR_POSICION_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @latitud DECIMAL(9,6);
    DECLARE @longitud DECIMAL(9,6);
    DECLARE @altitud INT;
    DECLARE @progreso DECIMAL(5,4);
    DECLARE @tracking_actual NVARCHAR(MAX);
    DECLARE @nueva_posicion NVARCHAR(500);

    -- Obtener posición actual desde la vista
    SELECT
        @latitud = latitud_actual,
        @longitud = longitud_actual,
        @altitud = altitud_pies,
        @progreso = progreso
    FROM V_VUELOS_TRACKING
    WHERE vuelo_id = @vuelo_id;

    IF @latitud IS NULL
        RETURN; -- El vuelo no está en vuelo

    -- Obtener tracking actual
    SELECT @tracking_actual = telemetria
    FROM vuelo
    WHERE id = @vuelo_id;

    -- Crear nueva posición como JSON
    SET @nueva_posicion = JSON_OBJECT(
            'timestamp': FORMAT(GETDATE(), 'yyyy-MM-ddTHH:mm:ss'),
            'lat': @latitud,
            'lng': @longitud,
            'altitud': @altitud,
            'progreso': @progreso
                          );

    -- Si no existe tracking, crear array nuevo
    IF @tracking_actual IS NULL
        BEGIN
            SET @tracking_actual = JSON_ARRAY(@nueva_posicion);
        END
    ELSE
        BEGIN
            -- Añadir nueva posición al array existente
            SET @tracking_actual = JSON_MODIFY(@tracking_actual, 'append $', JSON_QUERY(@nueva_posicion));
        END

    -- Guardar en la tabla
    UPDATE vuelo
    SET telemetria = @tracking_actual
    WHERE id = @vuelo_id;
END;
go

CREATE   PROCEDURE SP_MANTENIMIENTOS_PAGINADO
    @PageNumber     INT            = 1,
    @PageSize       INT            = 10,
    @AerolineaId    INT            =1,
    @Estado         NVARCHAR(50)   = NULL,   -- NULL = todos
    @FechaProgramada DATETIME          = NULL,   -- NULL = cualquier fecha
    @Busqueda       NVARCHAR(100)  = NULL,   -- matrícula, tipo, modelo
    @TotalRegistros INT = 0            OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1  SET @PageNumber = 1;
    IF @PageSize   < 1  SET @PageSize   = 10;
    IF @PageSize   > 100 SET @PageSize  = 100;

    -- Total para paginación
    SELECT @TotalRegistros = COUNT(*)
    FROM V_MANTENIMIENTOS
    WHERE
        (AEROLINEA_ID     = @AerolineaId)
      AND (@Estado          IS NULL OR ESTADO           = @Estado)
      AND (@FechaProgramada IS NULL OR CAST(FECHA_PROGRAMADA AS DATE) = @FechaProgramada)
      AND (@Busqueda        IS NULL OR
           MATRICULA    LIKE '%' + @Busqueda + '%' OR
           TIPO         LIKE '%' + @Busqueda + '%' OR
           NOMBRE_MODELO LIKE '%' + @Busqueda + '%'
        );

    -- Página de datos
    SELECT
        ID,
        AVION_ID,
        AEROLINEA_ID,
        MANTENIMIENTO_TIPO_ID,
        ESTADO,
        FECHA_PROGRAMADA,
        FECHA_INICIO,
        FECHA_FIN,
        DESCRIPCION,
        TIPO,
        MATRICULA,
        NOMBRE_MODELO,
        @TotalRegistros                                          AS TOTAL_REGISTROS,
        @PageNumber                                              AS PAGINA_ACTUAL,
        @PageSize                                                AS REGISTROS_POR_PAGINA,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize)     AS TOTAL_PAGINAS
    FROM V_MANTENIMIENTOS
    WHERE
        (AEROLINEA_ID     = @AerolineaId)
      AND (@Estado          IS NULL OR ESTADO           = @Estado)
      AND (@FechaProgramada IS NULL OR CAST(FECHA_PROGRAMADA AS DATE) = @FechaProgramada)
      AND (@Busqueda        IS NULL OR
           MATRICULA    LIKE '%' + @Busqueda + '%' OR
           TIPO         LIKE '%' + @Busqueda + '%' OR
           NOMBRE_MODELO LIKE '%' + @Busqueda + '%'
        )
    ORDER BY FECHA_PROGRAMADA DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;
go

-- =====================================================
--  SP: SP_MANTENIMIENTO_CANCELAR
--  Cancela el mantenimiento y restaura el avión.
-- =====================================================
CREATE   PROCEDURE SP_MANTENIMIENTO_CANCELAR
    @IdMantenimiento INT,
    @Motivo          NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AvionId      INT;
    DECLARE @EstadoActual NVARCHAR(50);

    SELECT @AvionId      = avion_id,
           @EstadoActual = estado
    FROM   mantenimiento
    WHERE  id = @IdMantenimiento;

    IF @AvionId IS NULL
        BEGIN
            SELECT 0 AS ok, 'Mantenimiento no encontrado' AS mensaje;
            RETURN;
        END

    IF @EstadoActual = 'Completado'
        BEGIN
            SELECT 0 AS ok, 'No se puede cancelar un mantenimiento ya Completado' AS mensaje;
            RETURN;
        END

    UPDATE mantenimiento
    SET    estado      = 'Cancelado',
           fecha_fin   = GETDATE(),
           descripcion = CASE
                             WHEN @Motivo IS NOT NULL
                                 THEN ISNULL(descripcion + ' | ', '') + 'CANCELADO: ' + @Motivo
                             ELSE descripcion
               END
    WHERE  id = @IdMantenimiento;

    -- Si estaba En Curso devolver a Operativo, si era Programado no cambia estado del avión
    IF @EstadoActual = 'En Curso'
        UPDATE avion SET estado_id = 1 WHERE id = @AvionId;

    SELECT 1 AS ok, 'Mantenimiento cancelado' AS mensaje;
END;
go

-- =====================================================
--  SP: SP_MANTENIMIENTO_COMPLETAR
--  Cierra el mantenimiento y deja el avión "Operativo".
-- =====================================================
CREATE   PROCEDURE SP_MANTENIMIENTO_COMPLETAR
    @IdMantenimiento INT,
    @Descripcion     NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AvionId      INT;
    DECLARE @EstadoActual NVARCHAR(50);

    SELECT @AvionId      = avion_id,
           @EstadoActual = estado
    FROM   mantenimiento
    WHERE  id = @IdMantenimiento;

    IF @AvionId IS NULL
        BEGIN
            SELECT 0 AS ok, 'Mantenimiento no encontrado' AS mensaje;
            RETURN;
        END

    IF @EstadoActual <> 'En Curso'
        BEGIN
            SELECT 0 AS ok, 'Solo se puede completar un mantenimiento En Curso' AS mensaje;
            RETURN;
        END

    UPDATE mantenimiento
    SET    estado      = 'Completado',
           fecha_fin   = GETDATE(),
           descripcion = ISNULL(@Descripcion, descripcion)
    WHERE  id = @IdMantenimiento;

    -- Devolver avión a "Operativo"
    UPDATE avion
    SET    estado_id = 1          -- 1 = Operativo
    WHERE  id = @AvionId;

    SELECT 1 AS ok, 'Mantenimiento completado. Avión devuelto a estado Operativo' AS mensaje;
END;
go

CREATE   PROCEDURE SP_MANTENIMIENTO_INICIAR
@IdMantenimiento INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AvionId      INT;
    DECLARE @EstadoActual NVARCHAR(50);
    DECLARE @EstadoAvion  NVARCHAR(50);
    DECLARE @NumVuelo     NVARCHAR(10);

    -- 1. Obtener datos del mantenimiento
    SELECT @AvionId      = avion_id,
           @EstadoActual = estado
    FROM   mantenimiento
    WHERE  id = @IdMantenimiento;

    IF @AvionId IS NULL
        BEGIN
            SELECT 0 AS ok, 'Mantenimiento no encontrado' AS mensaje;
            RETURN;
        END

    -- 2. Comprobar que el mantenimiento está en estado Programado
    IF @EstadoActual <> 'Programado'
        BEGIN
            SELECT 0 AS ok, 'Solo se puede iniciar un mantenimiento en estado Programado' AS mensaje;
            RETURN;
        END

    -- 3. Comprobar que el avión no está actualmente en vuelo
    --    Un avión está "en vuelo" si tiene algún vuelo con estado_id = 3 (En Vuelo)
    SELECT TOP 1
        @EstadoAvion = ea.nombre,
        @NumVuelo    = v.numero_vuelo
    FROM   avion av
               INNER JOIN estado_avion ea ON av.estado_id = ea.id
               LEFT JOIN vuelo v
                         ON v.avion_id  = av.id
                             AND v.estado_id = 3   -- 3 = En Vuelo
    WHERE  av.id = @AvionId;

    -- Bloqueo por estado directo del avión
    IF @EstadoAvion = 'En Vuelo'
        BEGIN
            SELECT 0 AS ok,
                   CONCAT('El avión está operando el vuelo ', ISNULL(@NumVuelo, ''), '. No se puede iniciar el mantenimiento mientras esté en vuelo.') AS mensaje;
            RETURN;
        END

    -- Bloqueo adicional: vuelo activo en tabla vuelo aunque el estado del avión no esté sincronizado
    IF EXISTS (
        SELECT 1
        FROM   vuelo
        WHERE  avion_id  = @AvionId
          AND  estado_id = 3   -- En Vuelo
    )
        BEGIN
            SELECT TOP 1
                0         AS ok,
                CONCAT('El avión tiene el vuelo ', numero_vuelo, ' en curso. Espera a que aterrice antes de iniciar el mantenimiento.') AS mensaje
            FROM   vuelo
            WHERE  avion_id  = @AvionId
              AND  estado_id = 3;
            RETURN;
        END

    -- 4. Comprobar que el avión no tiene ya otro mantenimiento En Curso
    IF EXISTS (
        SELECT 1
        FROM   mantenimiento
        WHERE  avion_id = @AvionId
          AND  estado   = 'En Curso'
          AND  id       <> @IdMantenimiento
    )
        BEGIN
            SELECT 0 AS ok, 'El avión ya tiene otro mantenimiento en curso.' AS mensaje;
            RETURN;
        END

    -- ── Todo OK: iniciar ─────────────────────────────────────────

    UPDATE mantenimiento
    SET    estado       = 'En Curso',
           fecha_inicio = GETDATE()
    WHERE  id = @IdMantenimiento;

    UPDATE avion
    SET    estado_id = 2   -- 2 = En Mantenimiento
    WHERE  id = @AvionId;

    SELECT 1 AS ok, 'Mantenimiento iniciado correctamente' AS mensaje;
END;
go

CREATE    PROCEDURE SP_PROGRAMAR_MANTENIMIENTO
    @avion_id INT,
    @mantenimiento_tipo_id INT,
    @fecha_programada DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar Avión
        IF NOT EXISTS (SELECT 1 FROM avion WHERE id = @avion_id)
            BEGIN
                RAISERROR('El avión especificado no existe.', 16, 1);
                RETURN;
            END

        -- Validar Tipo de Mantenimiento
        IF NOT EXISTS (SELECT 1 FROM mantenimiento_tipo WHERE id = @mantenimiento_tipo_id)
            BEGIN
                RAISERROR('El tipo de mantenimiento no existe.', 16, 1);
                RETURN;
            END

        -- Insertar el registro (El default del estado es 'Programado')
        INSERT INTO mantenimiento (avion_id, mantenimiento_tipo_id, fecha_programada)
        VALUES (@avion_id, @mantenimiento_tipo_id, @fecha_programada);

        SELECT 'Mantenimiento programado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
go

CREATE   PROCEDURE SP_REGISTRAR_RETRASO
    @vuelo_id INT,
    @codigo_retraso_id INT,
    @minutos INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar que el vuelo existe
        IF NOT EXISTS (SELECT 1 FROM vuelo WHERE id = @vuelo_id)
            BEGIN
                RAISERROR('El vuelo no existe', 16, 1);
                RETURN;
            END

        -- 2. Intentamos sumar los minutos directamente
        UPDATE retraso_vuelo
        SET codigo_retraso_id = @codigo_retraso_id,
            minutos += @minutos
        WHERE vuelo_id = @vuelo_id;

        -- 3. Si el UPDATE no afectó a ninguna fila (es decir, no existía el retraso previo)
        IF @@ROWCOUNT = 0
            BEGIN
                -- Insertamos el primer retraso
                INSERT INTO retraso_vuelo (vuelo_id, codigo_retraso_id, minutos)
                VALUES (@vuelo_id, @codigo_retraso_id, @minutos);
            END

        -- Actualizar estado del vuelo a retrasado
        UPDATE vuelo
        SET estado_id = 6 -- Retrasado
        WHERE id = @vuelo_id;

        COMMIT TRANSACTION;


        SELECT 'Retraso registrado exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
go

CREATE   PROCEDURE SP_REGISTRAR_USUARIO
    @Nombre       NVARCHAR(50),
    @Apellidos    NVARCHAR(50),
    @Email        NVARCHAR(100),
    @Password     NVARCHAR(100),
    @IdAerolinea  INT,
    @Salt       NVARCHAR(50),
    @Pass      VARBINARY(MAX),
    @IdRol      INT = 2
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insertamos en la tabla usuario
        -- Guardamos la pass en texto plano aquí como pediste para tus pruebas
        INSERT INTO usuario (nombre, apellidos, email, password, aerolinea_id, activo)
        VALUES (@Nombre, @Apellidos, @Email, @Password, @IdAerolinea, 1);

        -- Obtener el ID generado
        DECLARE @UserId INT = SCOPE_IDENTITY();

        -- 3. Insertar en users_security con el Hash
        INSERT INTO users_security (id_usuario, salt, pass)
        VALUES (
                   @UserId,
                   @Salt,
                   @Pass
               );

        COMMIT TRANSACTION;

        INSERT INTO usuario_rol(usuario_id, rol_id)
        VALUES (@UserId, @IdRol)

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- Devolver el error detallado
        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END
go

CREATE    PROCEDURE SP_UPDATE_ESTADOVUELO
(@idvuelo int, @idestado int)
AS
UPDATE VUELO SET estado_id=@idestado
WHERE id=@idvuelo
go

CREATE      PROCEDURE SP_UPDATE_ESTADO_VUELO
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

        IF @nuevo_estado_id = 1 AND @estado_actual != 1
            BEGIN
                UPDATE avion
                SET estado_id = 1
                WHERE id = @avion_id;
            END

        -- Si el vuelo aterriza o se completa (estado 4 - Aterrizado / 7 - Completado)
        IF (@nuevo_estado_id IN (4, 7)) AND @estado_actual = 3
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
                SET estado_id = 1,
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

CREATE   PROCEDURE SP_UPDATE_GESTION_VUELO
(
    @idvuelo INT,
    @nuevo_estado_id INT = NULL,
    @puerta NVARCHAR(10) = NULL,
    @confirmados INT = NULL,
    @embarcados INT = NULL,
    @capacidad_total INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @avion_id INT;
    DECLARE @ruta_id INT;
    DECLARE @aeropuerto_destino_id INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @avion_id = avion_id, @ruta_id = ruta_id FROM VUELO WHERE id = @idvuelo;
        SELECT @aeropuerto_destino_id = aeropuerto_destino_id FROM RUTA WHERE id = @ruta_id;

        -- Actualización de datos del vuelo
        UPDATE VUELO SET
                         estado_id = ISNULL(@nuevo_estado_id, estado_id),
                         puerta = ISNULL(@puerta, puerta),
                         pasajeros_confirmados = ISNULL(@confirmados, pasajeros_confirmados),
                         pasajeros_embarcados = ISNULL(@embarcados, pasajeros_embarcados)
        WHERE id = @idvuelo;

        -- Lógica de Avión (Evitando el NULL que hace fallar tu BD)
        IF @nuevo_estado_id = 3 -- EN VUELO
            BEGIN
                UPDATE AVION SET
                                 estado_id = 3,
                                 -- aeropuerto_actual_id = NULL, <-- ELIMINADO para evitar error NOT NULL
                                 ciclos_totales = ciclos_totales + 1
                WHERE id = @avion_id;
            END

        IF @nuevo_estado_id = 4 -- ATERRIZADO
            BEGIN
                UPDATE AVION SET
                                 estado_id = 1, -- Operativo
                                 aeropuerto_actual_id = @aeropuerto_destino_id -- Aquí sí cambiamos al destino
                WHERE id = @avion_id;
            END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
go

CREATE       PROCEDURE SP_UPDATE_VUELO
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

CREATE     PROCEDURE SP_VALIDADICION_CREACION_VUELO
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

CREATE     PROCEDURE SP_VALIDAR_TRIPULACION_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

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

    -- Tabla temporal para acumular errores
    DECLARE @errores TABLE (
                               codigo  NVARCHAR(50),
                               mensaje NVARCHAR(255)
                           );

    -- Sin tripulación
    IF @total = 0
        INSERT INTO @errores VALUES ('SIN_TRIPULACION', 'El vuelo no tiene tripulación asignada.');

    -- Comandante
    IF @comandantes = 0
        INSERT INTO @errores VALUES ('FALTA_COMANDANTE', 'El vuelo debe tener un Comandante.');
    ELSE IF @comandantes > 1
        INSERT INTO @errores VALUES ('EXCESO_COMANDANTES',
                                     'Solo puede haber 1 Comandante. Hay ' + CAST(@comandantes AS VARCHAR) + '.');

    -- Primer Oficial
    IF @oficiales = 0
        INSERT INTO @errores VALUES ('FALTA_OFICIAL', 'El vuelo debe tener un Primer Oficial.');
    ELSE IF @oficiales > 1
        INSERT INTO @errores VALUES ('EXCESO_OFICIALES',
                                     'Solo puede haber 1 Primer Oficial. Hay ' + CAST(@oficiales AS VARCHAR) + '.');

    -- TCPs
    IF @tcps < 4
        INSERT INTO @errores VALUES ('POCOS_TCPS',
                                     'Se necesitan al menos 4 TCPs. Hay ' + CAST(@tcps AS VARCHAR) + '.');

    -- Devolver resultado
    IF EXISTS (SELECT 1 FROM @errores)
        SELECT 0 AS valido, codigo, mensaje FROM @errores;
    ELSE
        SELECT 1 AS valido, 'OK' AS codigo,
               'Tripulación completa: 1 Comandante, 1 Primer Oficial, '
                   + CAST(@tcps AS VARCHAR) + ' TCPs.' AS mensaje;
END;
go

CREATE    PROCEDURE SP_VUELOS_PAGINADO
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @EstadoId       INT           = NULL,      -- NULL = todos los estados
    @AerolineaId    INT           = NULL,      -- NULL = todas las aerolíneas
    @FechaSalida    DATE          = NULL,      -- NULL = cualquier fecha
    @Busqueda       NVARCHAR(100) = NULL,      -- número vuelo, ciudad, IATA
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- ══════════════════════════════════════════════
    --  VALIDACIONES
    -- ══════════════════════════════════════════════
    IF @PageNumber < 1  SET @PageNumber = 1;
    IF @PageSize   < 1  SET @PageSize   = 10;
    IF @PageSize   > 100 SET @PageSize  = 100;   -- límite de seguridad

    -- ══════════════════════════════════════════════
    --  TOTAL DE REGISTROS (para el front)
    -- ══════════════════════════════════════════════
    SELECT @TotalRegistros = COUNT(*)
    FROM V_VUELOS
    WHERE
        (@EstadoId    IS NULL OR id_estado    = @EstadoId)
      AND (@AerolineaId IS NULL OR id_aerolinea = @AerolineaId)
      AND (@FechaSalida IS NULL OR CAST(fecha_salida AS DATE) = @FechaSalida)
      AND (@Busqueda    IS NULL OR
           numero_vuelo    LIKE '%' + @Busqueda + '%' OR
           ciudad_origen   LIKE '%' + @Busqueda + '%' OR
           ciudad_destino  LIKE '%' + @Busqueda + '%' OR
           codigo_origen   LIKE '%' + @Busqueda + '%' OR
           codigo_destino  LIKE '%' + @Busqueda + '%' OR
           aerolinea       LIKE '%' + @Busqueda + '%'
        );

    -- ══════════════════════════════════════════════
    --  PÁGINA DE DATOS
    -- ══════════════════════════════════════════════
    SELECT
        vuelo_id,
        numero_vuelo,
        id_estado,
        estado_vuelo,
        id_aerolinea,
        ruta,
        aerolinea,
        aeropuerto_origen,
        codigo_origen,
        ciudad_origen,
        aeropuerto_destino,
        codigo_destino,
        ciudad_destino,
        avion,
        matricula,
        fabricante,
        nombre_modelo,
        fecha_salida,
        fecha_llegada,
        puerta,
        capacidad_total,
        pasajeros_confirmados,
        pasajeros_embarcados,
        porcentaje_ocupacion,
        distancia_km,
        -- Metadatos de paginación incluidos en el resultado
        @TotalRegistros                                              AS total_registros,
        @PageNumber                                                  AS pagina_actual,
        @PageSize                                                    AS registros_por_pagina,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize)         AS total_paginas
    FROM V_VUELOS
    WHERE
        (@EstadoId    IS NULL OR id_estado    = @EstadoId)
      AND (@AerolineaId IS NULL OR id_aerolinea = @AerolineaId)
      AND (@FechaSalida IS NULL OR CAST(fecha_salida AS DATE) = @FechaSalida)
      AND (@Busqueda    IS NULL OR
           numero_vuelo    LIKE '%' + @Busqueda + '%' OR
           ciudad_origen   LIKE '%' + @Busqueda + '%' OR
           ciudad_destino  LIKE '%' + @Busqueda + '%' OR
           codigo_origen   LIKE '%' + @Busqueda + '%' OR
           codigo_destino  LIKE '%' + @Busqueda + '%' OR
           aerolinea       LIKE '%' + @Busqueda + '%'
        )
    ORDER BY fecha_salida DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;

END;
go

