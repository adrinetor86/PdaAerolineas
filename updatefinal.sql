CREATE OR ALTER PROCEDURE SP_RUTAS_POR_AEROLINEA
    @AerolineaId    INT,
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @Busqueda       NVARCHAR(100) = NULL,
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;


    IF @PageNumber < 1  SET @PageNumber = 1;
    IF @PageSize   < 1  SET @PageSize   = 10;
    IF @PageSize   > 200 SET @PageSize  = 200;


    SELECT @TotalRegistros = COUNT(*)
    FROM V_RUTAS_AEROLINEAS
    WHERE aerolinea_id = @AerolineaId
      AND (@Busqueda IS NULL OR
           codigo_ruta        LIKE '%' + @Busqueda + '%' OR
           codigo_origen      LIKE '%' + @Busqueda + '%' OR
           aeropuerto_origen  LIKE '%' + @Busqueda + '%' OR
           ciudad_origen      LIKE '%' + @Busqueda + '%' OR
           codigo_destino     LIKE '%' + @Busqueda + '%' OR
           aeropuerto_destino LIKE '%' + @Busqueda + '%' OR
           ciudad_destino     LIKE '%' + @Busqueda + '%');


    SELECT
        ruta_id,
        aerolinea_id,
        aerolinea,
        codigo_aerolinea,
        codigo_ruta,
        aeropuerto_origen_id,
        codigo_origen,
        aeropuerto_origen,
        ciudad_origen,
        aeropuerto_destino_id,
        codigo_destino,
        aeropuerto_destino,
        ciudad_destino,
        distancia_km,
        activa,
        precio_base,
        frecuencia_semanal,
        fecha_inicio,
        fecha_fin,
        total_vuelos,
        vuelos_completados,

        @TotalRegistros AS TotalRegistros,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize) AS TotalPaginas
    FROM V_RUTAS_AEROLINEAS
    WHERE aerolinea_id = @AerolineaId
      AND (@Busqueda IS NULL OR
           codigo_ruta        LIKE '%' + @Busqueda + '%' OR
           codigo_origen      LIKE '%' + @Busqueda + '%' OR
           aeropuerto_origen  LIKE '%' + @Busqueda + '%' OR
           ciudad_origen      LIKE '%' + @Busqueda + '%' OR
           codigo_destino     LIKE '%' + @Busqueda + '%' OR
           aeropuerto_destino LIKE '%' + @Busqueda + '%' OR
           ciudad_destino     LIKE '%' + @Busqueda + '%')
    ORDER BY codigo_ruta -- Orden por código de ruta
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO


ALTER TABLE ruta ADD precio_billete DECIMAL(10, 2) NOT NULL DEFAULT 150.00;
GO
-- ══════════════════════════════════════════
-- ASIGNAR RUTAS A RYANAIR (ID = 2)
-- ══════════════════════════════════════════
-- ==============================================================================
-- INSERCIÓN SEGURA DE RUTAS (Solo se insertan si los aeropuertos existen)
-- ==============================================================================

-- Declaramos una tabla temporal con las rutas que queremos insertar
DECLARE @NuevasRutas TABLE (origen VARCHAR(3), destino VARCHAR(3), distancia INT);

INSERT INTO @NuevasRutas (origen, destino, distancia) VALUES
                                                          ('WAW', 'BUD', 689), ('WAW', 'PRG', 517), ('WAW', 'VIE', 575), ('WAW', 'OTP', 1150),
                                                          ('WAW', 'SOF', 1245),('WAW', 'BTS', 520), ('WAW', 'ZAG', 814), ('WAW', 'RIX', 549),
                                                          ('WAW', 'TLL', 760), ('WAW', 'VNO', 430), ('BUD', 'PRG', 443), ('BUD', 'VIE', 214),
                                                          ('BUD', 'OTP', 639), ('BUD', 'SOF', 640), ('BUD', 'ZAG', 345), ('BUD', 'BTS', 163),
                                                          ('BUD', 'BEG', 316), ('BUD', 'ATH', 1280),('PRG', 'VIE', 251), ('PRG', 'BTS', 251),
                                                          ('PRG', 'ZAG', 615), ('PRG', 'SOF', 1024),('PRG', 'OTP', 1063),('PRG', 'RIX', 1074),
                                                          ('PRG', 'TLL', 1287),('PRG', 'VNO', 945), ('PRG', 'ATH', 1534),('VIE', 'BTS', 55),
                                                          ('VIE', 'ZAG', 292), ('VIE', 'OTP', 829), ('VIE', 'SOF', 806), ('VIE', 'BEG', 536),
                                                          ('VIE', 'ATH', 1291),('OTP', 'SOF', 302), ('OTP', 'BEG', 476), ('OTP', 'ZAG', 859),
                                                          ('OTP', 'ATH', 639), ('SOF', 'BEG', 390), ('SOF', 'ZAG', 750), ('SOF', 'ATH', 524),
                                                          ('ZAG', 'BEG', 372), ('ZAG', 'ATH', 1048),('ZAG', 'BTS', 332), ('RIX', 'TLL', 281),
                                                          ('RIX', 'VNO', 267), ('RIX', 'BUD', 1269),('RIX', 'VIE', 1309),('TLL', 'VNO', 541),
                                                          ('TLL', 'BUD', 1541),('TLL', 'PRG', 1287),('VNO', 'BUD', 1033),('VNO', 'VIE', 1007),
                                                          ('BTS', 'BEG', 434), ('BTS', 'OTP', 874), ('BTS', 'SOF', 850), ('BEG', 'ATH', 805);

-- Insertamos cruzando con la tabla de aeropuertos reales
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    ao.id,
    ad.id,
    nr.distancia
FROM @NuevasRutas nr
         INNER JOIN aeropuerto ao ON nr.origen = ao.codigo_iata
         INNER JOIN aeropuerto ad ON nr.destino = ad.codigo_iata
WHERE NOT EXISTS (
    -- Evitamos duplicados si la ruta ya existe
    SELECT 1 FROM ruta r
    WHERE r.aeropuerto_origen_id = ao.id
      AND r.aeropuerto_destino_id = ad.id
);

-- Insertamos también las rutas de vuelta (inversas)
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    ad.id,
    ao.id,
    nr.distancia
FROM @NuevasRutas nr
         INNER JOIN aeropuerto ao ON nr.origen = ao.codigo_iata
         INNER JOIN aeropuerto ad ON nr.destino = ad.codigo_iata
WHERE NOT EXISTS (
    SELECT 1 FROM ruta r
    WHERE r.aeropuerto_origen_id = ad.id
      AND r.aeropuerto_destino_id = ao.id
);
GO





-- =====================================================
-- PdaAerolineas - EXTENSIONES: Historial Tripulantes,
--                 Combustible y Finanzas
-- =====================================================

-- =====================================================
-- 1. MODIFICAR TABLA RUTA: añadir precio_billete
-- =====================================================


-- Actualizar precios realistas por distancia (€)
UPDATE ruta SET precio_billete = 89.99  WHERE distancia_km BETWEEN 1    AND 400;
UPDATE ruta SET precio_billete = 129.99 WHERE distancia_km BETWEEN 401  AND 800;
UPDATE ruta SET precio_billete = 179.99 WHERE distancia_km BETWEEN 801  AND 1500;
UPDATE ruta SET precio_billete = 349.99 WHERE distancia_km BETWEEN 1501 AND 3000;
UPDATE ruta SET precio_billete = 599.99 WHERE distancia_km BETWEEN 3001 AND 6000;
UPDATE ruta SET precio_billete = 849.99 WHERE distancia_km BETWEEN 6001 AND 8000;
UPDATE ruta SET precio_billete = 999.99 WHERE distancia_km > 8000;

-- =====================================================
-- 2. NUEVA TABLA: combustible_vuelo
-- =====================================================
CREATE TABLE combustible_vuelo
(
    id                INT IDENTITY PRIMARY KEY,
    vuelo_id          INT            NOT NULL,
    litros_cargados   DECIMAL(10, 2) NOT NULL,
    litros_consumidos DECIMAL(10, 2) NULL,
    precio_por_litro  DECIMAL(10, 4) NOT NULL,
    fecha_registro    DATETIME       NOT NULL DEFAULT GETDATE(),
    observaciones     NVARCHAR(500)  NULL,
    CONSTRAINT FK_Combustible_Vuelo FOREIGN KEY (vuelo_id) REFERENCES vuelo (id),
    CONSTRAINT CK_litros_cargados CHECK (litros_cargados > 0),
    CONSTRAINT CK_litros_consumidos CHECK (litros_consumidos IS NULL OR litros_consumidos >= 0)
);
GO

-- Datos de prueba de combustible
INSERT INTO combustible_vuelo (vuelo_id, litros_cargados, litros_consumidos, precio_por_litro, observaciones)
VALUES
    (1,  4200.00, 3850.00, 0.7340, 'Repostaje completo MAD-BCN'),
    (2,  4200.00, 3920.00, 0.7340, 'Repostaje completo BCN-MAD'),
    (3,  3800.00, 3650.00, 0.7340, 'Repostaje MAD-AGP'),
    (4,  3800.00, 3700.00, 0.7340, 'Repostaje MAD-AGP tarde'),
    (5,  4500.00, 4200.00, 0.7412, 'Ruta MAD-PMI'),
    (7,  9800.00, 9200.00, 0.7412, 'Largo recorrido MAD-LHR'),
    (11, 42000.00, NULL,   0.7850, 'Repostaje transatlántico MAD-JFK - vuelo activo'),
    (12, 48000.00, NULL,   0.7850, 'Repostaje transatlántico MAD-MIA - vuelo activo'),
    (16, 41000.00, 39800.00, 0.7234, 'MAD-LHR completado'),
    (17, 5200.00,  4980.00,  0.7234, 'MAD-AGP completado');
GO


-- =====================================================
-- 3. VISTAS
-- =====================================================

-- VISTA: Historial de vuelos por tripulante
CREATE OR ALTER VIEW v_historial_tripulante AS
SELECT
    t.id                                                          AS tripulante_id,
    t.nombre,
    t.apellido,
    t.nombre + ' ' + t.apellido                                   AS nombre_completo,
    t.rol,
    t.id_aerolinea,
    al.nombre                                                     AS nombre_aerolinea,
    al.codigo_iata                                                AS codigo_aerolinea,
    v.id                                                          AS vuelo_id,
    v.numero_vuelo,
    v.fecha_salida,
    v.fecha_llegada,
    DATEDIFF(MINUTE, v.fecha_salida, v.fecha_llegada)             AS duracion_minutos,
    apo.nombre                                                    AS aeropuerto_origen,
    apo.codigo_iata                                               AS iata_origen,
    apo.ciudad                                                    AS ciudad_origen,
    apd.nombre                                                    AS aeropuerto_destino,
    apd.codigo_iata                                               AS iata_destino,
    apd.ciudad                                                    AS ciudad_destino,
    r.distancia_km,
    ev.nombre                                                     AS estado_vuelo,
    v.pasajeros_embarcados,
    r.precio_billete
FROM tripulante t
         INNER JOIN asignacion_tripulacion atc ON t.id = atc.tripulante_id
         INNER JOIN vuelo v ON atc.vuelo_id = v.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto apo ON r.aeropuerto_origen_id = apo.id
         INNER JOIN aeropuerto apd ON r.aeropuerto_destino_id = apd.id
         INNER JOIN aerolinea al ON t.id_aerolinea = al.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id;
GO

-- VISTA: Ingresos por vuelo
CREATE OR ALTER VIEW v_ingresos_vuelos AS
SELECT
    v.id                                              AS vuelo_id,
    v.numero_vuelo,
    v.fecha_salida,
    v.fecha_llegada,
    v.pasajeros_confirmados,
    v.pasajeros_embarcados,
    r.precio_billete,
    CAST(v.pasajeros_embarcados AS DECIMAL) * r.precio_billete AS ingresos_totales,
    CAST(v.pasajeros_confirmados AS DECIMAL) * r.precio_billete AS ingresos_proyectados,
    al.id                                             AS aerolinea_id,
    al.nombre                                         AS aerolinea,
    al.codigo_iata                                    AS codigo_aerolinea,
    apo.codigo_iata                                   AS iata_origen,
    apo.ciudad                                        AS ciudad_origen,
    apd.codigo_iata                                   AS iata_destino,
    apd.ciudad                                        AS ciudad_destino,
    r.distancia_km,
    ev.nombre                                         AS estado_vuelo
FROM vuelo v
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aerolinea al ON v.aerolinea_id = al.id
         INNER JOIN aeropuerto apo ON r.aeropuerto_origen_id = apo.id
         INNER JOIN aeropuerto apd ON r.aeropuerto_destino_id = apd.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id;
GO

-- VISTA: Gastos de combustible por vuelo
CREATE OR ALTER VIEW v_gastos_combustible AS
SELECT
    cf.id,
    cf.vuelo_id,
    v.numero_vuelo,
    v.fecha_salida,
    al.id                                                             AS aerolinea_id,
    al.nombre                                                         AS aerolinea,
    apo.codigo_iata                                                   AS iata_origen,
    apo.ciudad                                                        AS ciudad_origen,
    apd.codigo_iata                                                   AS iata_destino,
    apd.ciudad                                                        AS ciudad_destino,
    cf.litros_cargados,
    cf.litros_consumidos,
    cf.precio_por_litro,
    CAST(cf.litros_cargados AS DECIMAL) * cf.precio_por_litro                           AS coste_carga,
    ISNULL(cf.litros_consumidos, 0) * cf.precio_por_litro             AS coste_consumo,
    CASE
        WHEN cf.litros_consumidos IS NOT NULL AND cf.litros_cargados > 0
            THEN CAST(cf.litros_consumidos AS DECIMAL) / cf.litros_cargados * 100
        ELSE NULL
        END                                                           AS pct_consumido,
    cf.fecha_registro,
    cf.observaciones,
    ev.nombre                                                         AS estado_vuelo
FROM combustible_vuelo cf
         INNER JOIN vuelo v ON cf.vuelo_id = v.id
         INNER JOIN aerolinea al ON v.aerolinea_id = al.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto apo ON r.aeropuerto_origen_id = apo.id
         INNER JOIN aeropuerto apd ON r.aeropuerto_destino_id = apd.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id;
GO

-- =====================================================
-- 4. STORED PROCEDURES
-- =====================================================

-- SP: Registrar combustible de un vuelo
CREATE OR ALTER PROCEDURE sp_registrar_combustible
    @vuelo_id        INT,
    @litros_cargados DECIMAL(10, 2),
    @precio_litro    DECIMAL(10, 4),
    @observaciones   NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM vuelo WHERE id = @vuelo_id)
        BEGIN
            RAISERROR('El vuelo especificado no existe.', 16, 1);
            RETURN;
        END

    IF EXISTS (SELECT 1 FROM combustible_vuelo WHERE vuelo_id = @vuelo_id)
        BEGIN
            RAISERROR('Ya existe un registro de combustible para este vuelo.', 16, 1);
            RETURN;
        END

    INSERT INTO combustible_vuelo (vuelo_id, litros_cargados, precio_por_litro, fecha_registro, observaciones)
    VALUES (@vuelo_id, @litros_cargados, @precio_litro, GETDATE(), @observaciones);

    SELECT SCOPE_IDENTITY() AS nuevo_id;
END;
GO

-- SP: Actualizar litros consumidos al finalizar el vuelo
CREATE OR ALTER PROCEDURE sp_actualizar_consumo
    @combustible_id  INT,
    @litros_consumidos DECIMAL(10, 2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE combustible_vuelo
    SET litros_consumidos = @litros_consumidos
    WHERE id = @combustible_id;

    IF @@ROWCOUNT = 0
        RAISERROR('Registro de combustible no encontrado.', 16, 1);
END;
GO

-- SP: Resumen financiero por aerolínea y periodo
CREATE OR ALTER PROCEDURE sp_resumen_financiero
    @aerolinea_id INT,
    @fecha_desde  DATETIME = NULL,
    @fecha_hasta  DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @fecha_desde = ISNULL(@fecha_desde, '2000-01-01');
    SET @fecha_hasta = ISNULL(@fecha_hasta, GETDATE());

    SELECT
        COUNT(v.id)                                                         AS total_vuelos,
        SUM(v.pasajeros_embarcados)                                         AS total_pasajeros,
        ISNULL(SUM(CAST(v.pasajeros_embarcados AS DECIMAL) * r.precio_billete), 0) AS ingresos_totales,
        ISNULL((
                   SELECT SUM(cf.litros_consumidos * cf.precio_por_litro)
                   FROM combustible_vuelo cf
                            INNER JOIN vuelo v2 ON cf.vuelo_id = v2.id
                   WHERE v2.aerolinea_id = @aerolinea_id
                     AND v2.fecha_salida BETWEEN @fecha_desde AND @fecha_hasta
                     AND cf.litros_consumidos IS NOT NULL
               ), 0)                                                               AS gastos_combustible,
        ISNULL(SUM(CAST(v.pasajeros_embarcados AS DECIMAL) * r.precio_billete), 0)
            - ISNULL((
                         SELECT SUM(cf.litros_consumidos * cf.precio_por_litro)
                         FROM combustible_vuelo cf
                                  INNER JOIN vuelo v2 ON cf.vuelo_id = v2.id
                         WHERE v2.aerolinea_id = @aerolinea_id
                           AND v2.fecha_salida BETWEEN @fecha_desde AND @fecha_hasta
                           AND cf.litros_consumidos IS NOT NULL
                     ), 0)                                                  AS beneficio_neto
    FROM vuelo v
             INNER JOIN ruta r ON v.ruta_id = r.id
    WHERE v.aerolinea_id = @aerolinea_id
      AND v.fecha_salida BETWEEN @fecha_desde AND @fecha_hasta;
END;
GO

-- SP: Historial completo de un tripulante
CREATE OR ALTER PROCEDURE sp_historial_tripulante
@tripulante_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM v_historial_tripulante
    WHERE tripulante_id = @tripulante_id
    ORDER BY fecha_salida DESC;
END;
GO

-- SP: Top rutas más rentables
CREATE OR ALTER PROCEDURE sp_top_rutas_rentables
    @aerolinea_id INT,
    @top          INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@top)
        apo.codigo_iata + ' → ' + apd.codigo_iata   AS ruta,
        apo.ciudad + ' - ' + apd.ciudad              AS ciudades,
        r.distancia_km,
        r.precio_billete,
        COUNT(v.id)                                  AS num_vuelos,
        SUM(v.pasajeros_embarcados)                  AS total_pasajeros,
        SUM(CAST(v.pasajeros_embarcados AS DECIMAL) * r.precio_billete) AS ingresos_totales
    FROM vuelo v
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto apo ON r.aeropuerto_origen_id = apo.id
             INNER JOIN aeropuerto apd ON r.aeropuerto_destino_id = apd.id
    WHERE v.aerolinea_id = @aerolinea_id
    GROUP BY apo.codigo_iata, apd.codigo_iata, apo.ciudad, apd.ciudad, r.distancia_km, r.precio_billete
    ORDER BY ingresos_totales DESC;
END;
GO



-- ============================================
-- STORED PROCEDURES DE AUTOMATIZACION
-- Sistema de gestion automatica de finanzas, combustible e historial de tripulantes
-- ============================================

-- ============================================
-- TABLA: historial_tripulante
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'historial_tripulante')
    BEGIN
        CREATE TABLE historial_tripulante (
                                              id INT IDENTITY(1,1) PRIMARY KEY,
                                              tripulante_id INT NOT NULL,
                                              vuelo_id INT NOT NULL,
                                              fecha_registro DATETIME DEFAULT GETDATE(),
                                              rol NVARCHAR(50) NOT NULL,
                                              horas_voladas DECIMAL(10,2) NULL,
                                              observaciones NVARCHAR(500) NULL,
                                              FOREIGN KEY (tripulante_id) REFERENCES tripulante(id),
                                              FOREIGN KEY (vuelo_id) REFERENCES vuelo(id)
        );
    END
GO

-- ============================================
-- TABLA: finanzas_vuelo
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'finanzas_vuelo')
    BEGIN
        CREATE TABLE finanzas_vuelo (
                                        id INT IDENTITY(1,1) PRIMARY KEY,
                                        vuelo_id INT NOT NULL UNIQUE,
                                        ingreso_pasajes DECIMAL(12,2) DEFAULT 0,
                                        coste_combustible DECIMAL(12,2) DEFAULT 0,
                                        coste_tripulacion DECIMAL(12,2) DEFAULT 0,
                                        coste_mantenimiento DECIMAL(12,2) DEFAULT 0,
                                        otros_costes DECIMAL(12,2) DEFAULT 0,
                                        beneficio_neto DECIMAL(12,2) DEFAULT 0,
                                        fecha_calculo DATETIME DEFAULT GETDATE(),
                                        FOREIGN KEY (vuelo_id) REFERENCES vuelo(id)
        );
    END
GO

-- ============================================
-- SP: Calcular consumo automatico de combustible
-- Se ejecuta al completar vuelo (estado 7)
-- ============================================
CREATE OR ALTER PROCEDURE SP_CALCULAR_COMBUSTIBLE_AUTOMATICO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @distancia_km INT;
        DECLARE @modelo_consumo DECIMAL(10,2);
        DECLARE @litros_estimados DECIMAL(10,2);
        DECLARE @precio_litro DECIMAL(10,2) = 0.73;

        -- Obtener distancia de la ruta
        SELECT @distancia_km = r.distancia_km
        FROM vuelo v
                 INNER JOIN ruta r ON v.ruta_id = r.id
        WHERE v.id = @vuelo_id;

        -- [CORRECCIÓN] Como no sabemos el nombre exacto de la columna de consumo, 
        -- fijamos un consumo medio estándar de 3.0 litros / 100km por pasajero.
        -- Cuando sepas el nombre de tu columna en modelo_avion, puedes cambiar esto.
        SET @modelo_consumo = 3.0;

        -- Calcular litros consumidos
        SET @litros_estimados = (@distancia_km / 100.0) * @modelo_consumo * 1.10;

        IF NOT EXISTS (SELECT 1 FROM combustible_vuelo WHERE vuelo_id = @vuelo_id)
            BEGIN
                INSERT INTO combustible_vuelo (
                    vuelo_id, litros_cargados, litros_consumidos, precio_por_litro, fecha_registro, observaciones
                )
                VALUES (
                           @vuelo_id, @litros_estimados, @litros_estimados, @precio_litro, GETDATE(), 'Calculo automatico'
                       );
            END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
-- ============================================
-- SP: Registrar historial de tripulante
-- Se ejecuta al completar vuelo (estado 7)
-- ============================================
CREATE OR ALTER PROCEDURE SP_REGISTRAR_HISTORIAL_TRIPULANTE
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @duracion_horas DECIMAL(10,2);

        SELECT @duracion_horas = DATEDIFF(MINUTE, fecha_salida, fecha_llegada) / 60.0
        FROM vuelo
        WHERE id = @vuelo_id;

        INSERT INTO historial_tripulante (
            tripulante_id, vuelo_id, fecha_registro, rol, horas_voladas, observaciones
        )
        SELECT
            at.tripulante_id,
            @vuelo_id,
            GETDATE(),
            -- [CORRECCIÓN] Quitamos la validación de 'at.rol' que daba el Error 207.
            -- Asignamos un string genérico hasta que sepas cómo se llama la columna de cargo/rol.
            'Tripulante de Vuelo',
            @duracion_horas,
            'Vuelo completado automaticamente'
        FROM asignacion_tripulacion at
        WHERE at.vuelo_id = @vuelo_id
          AND NOT EXISTS (
            SELECT 1 FROM historial_tripulante ht
            WHERE ht.vuelo_id = @vuelo_id AND ht.tripulante_id = at.tripulante_id
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- ============================================
-- SP: Calcular finanzas del vuelo
-- Se ejecuta al completar vuelo (estado 7)
-- ============================================
CREATE OR ALTER PROCEDURE SP_CALCULAR_FINANZAS_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ingreso_pasajes DECIMAL(12,2) = 0;
        DECLARE @coste_combustible DECIMAL(12,2) = 0;
        DECLARE @coste_tripulacion DECIMAL(12,2) = 0;
        DECLARE @coste_mantenimiento DECIMAL(12,2) = 500;
        DECLARE @otros_costes DECIMAL(12,2) = 0;
        DECLARE @beneficio_neto DECIMAL(12,2) = 0;

        DECLARE @pasajeros_embarcados INT;
        DECLARE @precio_base DECIMAL(10,2);
        DECLARE @duracion_horas DECIMAL(10,2);

        SELECT
            @pasajeros_embarcados = v.pasajeros_embarcados,
            @precio_base = ISNULL(ra.precio_base, 100.00),
            @duracion_horas = DATEDIFF(MINUTE, v.fecha_salida, v.fecha_llegada) / 60.0
        FROM vuelo v
                 INNER JOIN ruta_aerolinea ra ON v.ruta_id = ra.ruta_id AND v.aerolinea_id = ra.aerolinea_id
        WHERE v.id = @vuelo_id;

        SET @ingreso_pasajes = @pasajeros_embarcados * @precio_base;

        SELECT @coste_combustible = ISNULL((litros_consumidos * precio_por_litro), (litros_cargados * precio_por_litro))
        FROM combustible_vuelo
        WHERE vuelo_id = @vuelo_id;

        -- [CORRECCIÓN] Quitamos la evaluación de 'at.rol'.
        -- Calculamos un coste medio estándar de 100€/hora por cada tripulante asignado.
        SELECT @coste_tripulacion = SUM(100 * @duracion_horas)
        FROM asignacion_tripulacion at
        WHERE at.vuelo_id = @vuelo_id;

        SET @otros_costes = @ingreso_pasajes * 0.10;
        SET @beneficio_neto = @ingreso_pasajes - ISNULL(@coste_combustible,0) - ISNULL(@coste_tripulacion,0) - @coste_mantenimiento - @otros_costes;

        IF EXISTS (SELECT 1 FROM finanzas_vuelo WHERE vuelo_id = @vuelo_id)
            BEGIN
                UPDATE finanzas_vuelo
                SET ingreso_pasajes = @ingreso_pasajes, coste_combustible = ISNULL(@coste_combustible, 0),
                    coste_tripulacion = ISNULL(@coste_tripulacion, 0), coste_mantenimiento = @coste_mantenimiento,
                    otros_costes = @otros_costes, beneficio_neto = @beneficio_neto, fecha_calculo = GETDATE()
                WHERE vuelo_id = @vuelo_id;
            END
        ELSE
            BEGIN
                INSERT INTO finanzas_vuelo (vuelo_id, ingreso_pasajes, coste_combustible, coste_tripulacion, coste_mantenimiento, otros_costes, beneficio_neto, fecha_calculo)
                VALUES (@vuelo_id, @ingreso_pasajes, ISNULL(@coste_combustible, 0), ISNULL(@coste_tripulacion, 0), @coste_mantenimiento, @otros_costes, @beneficio_neto, GETDATE());
            END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- ============================================
-- SP: Proceso completo de automatizacion
-- Se ejecuta al completar vuelo (estado 7)
-- ============================================
CREATE OR ALTER PROCEDURE SP_AUTOMATIZAR_FINALIZACION_VUELO
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @estado_vuelo INT;

    -- Verificar que el vuelo esta en estado completado (7)
    SELECT @estado_vuelo = estado_id
    FROM vuelo
    WHERE id = @vuelo_id;

    IF @estado_vuelo != 7
        BEGIN
            RAISERROR('El vuelo debe estar en estado Completado (7) para ejecutar la automatizacion', 16, 1);
            RETURN;
        END

    BEGIN TRY
        -- 1. Calcular combustible automaticamente
        EXEC SP_CALCULAR_COMBUSTIBLE_AUTOMATICO @vuelo_id;

        -- 2. Registrar historial de tripulantes
        EXEC SP_REGISTRAR_HISTORIAL_TRIPULANTE @vuelo_id;

        -- 3. Calcular finanzas del vuelo
        EXEC SP_CALCULAR_FINANZAS_VUELO @vuelo_id;

        PRINT 'Automatizacion completada correctamente para el vuelo ' + CAST(@vuelo_id AS NVARCHAR(10));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- ============================================
-- MODIFICAR SP_UPDATE_ESTADO_VUELO
-- Para ejecutar automatizacion al completar vuelo
-- ============================================
CREATE OR ALTER PROCEDURE SP_UPDATE_ESTADO_VUELO
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

                -- Obtener aeropuerto destino y duracion
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

                -- Actualizar avion
                UPDATE avion
                SET estado_id = 1,
                    aeropuerto_actual_id = @aeropuerto_destino_id,
                    horas_vuelo_totales = horas_vuelo_totales + CEILING(@duracion_vuelo_horas)
                WHERE id = @avion_id;

                -- Registrar posicion
                INSERT INTO registro_estado_avion (avion_id, aeropuerto_id, latitud, longitud, fecha_hora)
                VALUES (@avion_id, @aeropuerto_destino_id, @latitud, @longitud, @fecha_actualizacion);
            END

        -- AUTOMATIZACION: Si el vuelo se completa (estado 7)
        IF @nuevo_estado_id = 7 AND @estado_actual != 7
            BEGIN
                -- Ejecutar automatizacion de finanzas, combustible e historial
                EXEC SP_AUTOMATIZAR_FINALIZACION_VUELO @vuelo_id;
            END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- ============================================
-- VISTA: Resumen de finanzas por aerolinea
-- ============================================
CREATE OR ALTER VIEW V_FINANZAS_RESUMEN AS
SELECT
    v.aerolinea_id,
    a.nombre AS aerolinea,
    COUNT(f.id) AS total_vuelos,
    SUM(f.ingreso_pasajes) AS total_ingresos,
    SUM(f.coste_combustible + f.coste_tripulacion + f.coste_mantenimiento + f.otros_costes) AS total_costes,
    SUM(f.beneficio_neto) AS beneficio_total,
    AVG(f.beneficio_neto) AS beneficio_promedio
FROM finanzas_vuelo f
         INNER JOIN vuelo v ON f.vuelo_id = v.id
         INNER JOIN aerolinea a ON v.aerolinea_id = a.id
GROUP BY v.aerolinea_id, a.nombre;
GO

-- ============================================
-- VISTA: Historial completo de tripulantes
-- ============================================
CREATE OR ALTER VIEW V_HISTORIAL_TRIPULANTES AS
SELECT
    ht.id,
    ht.tripulante_id,
    t.nombre + ' ' + t.apellido AS nombre_completo,
    ht.vuelo_id,
    v.numero_vuelo,
    ht.rol,
    ht.horas_voladas,
    v.fecha_salida,
    ao.codigo_iata + '-' + ad.codigo_iata AS ruta,
    a.nombre AS aerolinea,
    ht.fecha_registro,
    ht.observaciones
FROM historial_tripulante ht
         INNER JOIN tripulante t ON ht.tripulante_id = t.id
         INNER JOIN vuelo v ON ht.vuelo_id = v.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
         INNER JOIN aerolinea a ON v.aerolinea_id = a.id;
GO

PRINT 'Stored procedures de automatizacion creados correctamente';
GO



create or alter   view V_ADMINISTRACION_USUARIOS
AS
select
    u.id,
    u.nombre ,
    u.apellidos,
    u.email,
    rol.nombre AS rol,
    ae.nombre as aerolinea,
    u.activo

from usuario u
         inner join usuario_rol ur ON u.id = ur.usuario_id
         inner join rol ON ur.rol_id=rol.id
         inner join aerolinea ae ON u.aerolinea_id=ae.id
go


CREATE  or alter  PROCEDURE SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA
    @avion_id INT,
    @fecha_salida_deseada DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @aeropuerto_actual_id INT;
    DECLARE @estado_avion NVARCHAR(50);
    DECLARE @aerolinea_id INT;

    -- Obtener datos del avión
    SELECT
        @aeropuerto_actual_id = av.aeropuerto_actual_id,
        @estado_avion         = ea.nombre,
        @aerolinea_id = av.aerolinea_id
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
        r.id AS ruta_id,
        r.distancia_km,
        ao.id AS aeropuerto_origen_id,
        ao.id AS aeropuerto_origen_id,
        ao.codigo_iata AS codigo_origen,
        ao.nombre AS nombre_origen,
        ao.ciudad AS ciudad_origen,
        ad.id AS aeropuerto_destino_id,
        ad.id AS aeropuerto_destino_id,
        ad.codigo_iata AS codigo_destino,
        ad.nombre AS nombre_destino,
        ad.ciudad AS ciudad_destino,
        ad.latitud AS latitud_destino,
        ad.longitud AS longitud_destino,
        ROUND((r.distancia_km / 800.0) * 60, 0) AS duracion_minutos_totales,
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) / 60 AS VARCHAR) + 'h ' +
        CAST(ROUND((r.distancia_km / 800.0) * 60, 0) % 60 AS VARCHAR) + 'min' AS duracion_formateada,
        FORMAT(DATEADD(MINUTE, ROUND((r.distancia_km / 800.0) * 60, 0), '19000101'), 'HH:mm') AS duracion_HHMM,
        DATEADD(MINUTE, ROUND((r.distancia_km / 800.0) * 60, 0), @fecha_salida_deseada) AS fecha_llegada_estimada,
        ao.codigo_iata + ' → ' + ad.codigo_iata AS ruta_codigo,
        ao.ciudad + ' (' + ao.codigo_iata + ') → ' + ad.ciudad + ' (' + ad.codigo_iata + ')' AS ruta_descripcion,
        ra.precio_base,
        ra.frecuencia_semanal
    FROM ruta r
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
             INNER JOIN ruta_aerolinea ra ON ra.ruta_id = r.id
    WHERE r.aeropuerto_origen_id = @aeropuerto_actual_id
      AND ra.aerolinea_id = @aerolinea_id
      AND ra.activa = 1
    ORDER BY r.distancia_km ASC;
END;
go

-- =============================================
-- FINANZAS (PAGINADO NORMAL)
-- =============================================
CREATE OR ALTER PROCEDURE SP_FINANZAS_PAGINADO
    @AerolineaId     INT,
    @PageNumber      INT = 1,
    @PageSize        INT = 10,
    @Desde           DATE = NULL,
    @Hasta           DATE = NULL,
    @TotalRegistros  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize < 1 SET @PageSize = 10;

    -- 1. Contar el total de registros (Filtros aplicados)
    SELECT @TotalRegistros = COUNT(*)
    FROM finanzas_vuelo f
             INNER JOIN vuelo v ON v.id = f.vuelo_id
    WHERE v.aerolinea_id = @AerolineaId
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta);

    -- 2. Obtener los datos paginados
    SELECT
        f.id,
        f.vuelo_id,
        v.numero_vuelo,
        (ao.codigo_iata + '-' + ad.codigo_iata) AS ruta,
        v.fecha_salida,
        f.ingreso_pasajes,
        f.coste_combustible,
        f.coste_tripulacion,
        f.coste_mantenimiento,
        f.otros_costes,
        f.beneficio_neto,
        f.fecha_calculo
    FROM finanzas_vuelo f
             INNER JOIN vuelo v         ON v.id = f.vuelo_id
             INNER JOIN ruta r          ON r.id = v.ruta_id
             INNER JOIN aeropuerto ao   ON ao.id = r.aeropuerto_origen_id
             INNER JOIN aeropuerto ad   ON ad.id = r.aeropuerto_destino_id
    WHERE v.aerolinea_id = @AerolineaId
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta)
    ORDER BY v.fecha_salida DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO


-- =============================================
-- COMBUSTIBLE (PAGINADO NORMAL)
-- =============================================
CREATE OR ALTER PROCEDURE SP_COMBUSTIBLE_PAGINADO
    @AerolineaId     INT,
    @PageNumber      INT = 1,
    @PageSize        INT = 10,
    @Desde           DATE = NULL,
    @Hasta           DATE = NULL,
    @TotalRegistros  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize < 1 SET @PageSize = 10;

    -- 1. Contar el total de registros (Filtros aplicados)
    SELECT @TotalRegistros = COUNT(*)
    FROM combustible_vuelo c
             INNER JOIN vuelo v ON v.id = c.vuelo_id
    WHERE v.aerolinea_id = @AerolineaId
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta);

    -- 2. Obtener los datos paginados
    SELECT
        c.id,
        c.vuelo_id,
        v.numero_vuelo,
        v.fecha_salida,
        a.id AS aerolinea_id,
        a.nombre AS aerolinea,
        a.codigo_iata AS codigo_aerolinea,
        ao.codigo_iata AS iata_origen,
        ao.ciudad AS ciudad_origen,
        ad.codigo_iata AS iata_destino,
        ad.ciudad AS ciudad_destino,
        c.litros_cargados,
        c.litros_consumidos,
        c.precio_por_litro AS precio_por_litro,
        (c.litros_cargados * c.precio_por_litro) AS coste_carga,
        (ISNULL(c.litros_consumidos, 0) * c.precio_por_litro) AS coste_consumo,
        CASE WHEN c.litros_cargados > 0
                 THEN (ISNULL(c.litros_consumidos, 0) / c.litros_cargados) * 100
             ELSE 0 END AS pct_consumido,
        c.fecha_registro,
        c.observaciones,
        ev.nombre AS estado_vuelo
    FROM combustible_vuelo c
             INNER JOIN vuelo v         ON v.id = c.vuelo_id
             INNER JOIN aerolinea a     ON a.id = v.aerolinea_id
             INNER JOIN ruta r          ON r.id = v.ruta_id
             INNER JOIN aeropuerto ao   ON ao.id = r.aeropuerto_origen_id
             INNER JOIN aeropuerto ad   ON ad.id = r.aeropuerto_destino_id
             LEFT  JOIN estado_vuelo ev ON ev.id = v.estado_id
    WHERE v.aerolinea_id = @AerolineaId
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta)
    ORDER BY v.fecha_salida DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO

CREATE OR ALTER VIEW V_ADMINISTRACION_USUARIOS
AS
SELECT
    u.id,
    u.nombre,
    u.apellidos,
    u.email,
    rol.nombre AS rol,
    ae.id AS aerolinea_id,   -- ESTA ES LA COLUMNA QUE TE FALTABA
    ae.nombre AS aerolinea,
    u.activo
FROM usuario u
         INNER JOIN usuario_rol ur ON u.id = ur.usuario_id
         INNER JOIN rol ON ur.rol_id = rol.id
         INNER JOIN aerolinea ae ON u.aerolinea_id = ae.id;
GO

CREATE OR ALTER PROCEDURE SP_BORRAR_VUELOS_EN_VUELO
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EstadoVueloEnVuelo INT;
    DECLARE @EstadoAvionOperativo INT;

    -- Obtener IDs de los estados para evitar harcodearlos
    SELECT @EstadoVueloEnVuelo = id FROM estado_vuelo WHERE nombre = 'En Vuelo';
    SELECT @EstadoAvionOperativo = id FROM estado_avion WHERE nombre = 'Operativo';

    -- Si no se encuentran, usar valores por defecto comunes
    IF @EstadoVueloEnVuelo IS NULL SET @EstadoVueloEnVuelo = 3;
    IF @EstadoAvionOperativo IS NULL SET @EstadoAvionOperativo = 1;

    -- Almacenar los vuelos y aviones afectados para procesarlos
    DECLARE @VuelosAfectados TABLE (
                                       VueloId INT,
                                       AvionId INT
                                   );

    INSERT INTO @VuelosAfectados (VueloId, AvionId)
    SELECT id, avion_id
    FROM vuelo
    WHERE estado_id = @EstadoVueloEnVuelo;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Restaurar el estado de los aviones a 'Operativo'
        UPDATE a
        SET a.estado_id = @EstadoAvionOperativo
        FROM avion a
                 INNER JOIN @VuelosAfectados v ON a.id = v.AvionId;

        -- 2. Eliminar historial de tripulantes (NUEVO)
        DELETE ht
        FROM historial_tripulante ht
                 INNER JOIN @VuelosAfectados v ON ht.vuelo_id = v.VueloId;

        -- 3. Eliminar asignaciones de tripulación de esos vuelos
        DELETE at
        FROM asignacion_tripulacion at
                 INNER JOIN @VuelosAfectados v ON at.vuelo_id = v.VueloId;

        -- 4. Eliminar registros de combustible (NUEVO - Soluciona el error)
        DELETE cv
        FROM combustible_vuelo cv
                 INNER JOIN @VuelosAfectados v ON cv.vuelo_id = v.VueloId;

        -- 5. Eliminar registros financieros (NUEVO)
        DELETE fv
        FROM finanzas_vuelo fv
                 INNER JOIN @VuelosAfectados v ON fv.vuelo_id = v.VueloId;

        -- 6. Eliminar los retrasos asociados a esos vuelos (si los hubiera)
        DELETE rv
        FROM retraso_vuelo rv
                 INNER JOIN @VuelosAfectados v ON rv.vuelo_id = v.VueloId;

        -- 7. Finalmente, eliminar los vuelos
        DELETE v
        FROM vuelo v
                 INNER JOIN @VuelosAfectados va ON v.id = va.VueloId;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE SP_HISTORIAL_TRIPULANTES_PAGINADO
    @AerolineaId     INT,
    @PageNumber      INT = 1,
    @PageSize        INT = 10,
    @TripulanteId    INT = NULL,
    @Desde           DATE = NULL,
    @Hasta           DATE = NULL,
    @TotalRegistros  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize   < 1 SET @PageSize = 10;

    -- TOTAL
    SELECT @TotalRegistros = COUNT(*)
    FROM V_HISTORIAL_TRIPULANTES v
             INNER JOIN aerolinea a ON v.aerolinea = a.nombre
    WHERE a.id = @AerolineaId
      AND (@TripulanteId IS NULL OR v.tripulante_id = @TripulanteId)
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta);

    -- DATOS PAGINADOS
    SELECT v.*
    FROM V_HISTORIAL_TRIPULANTES v
             INNER JOIN aerolinea a ON v.aerolinea = a.nombre
    WHERE a.id = @AerolineaId
      AND (@TripulanteId IS NULL OR v.tripulante_id = @TripulanteId)
      AND (@Desde IS NULL OR v.fecha_salida >= @Desde)
      AND (@Hasta IS NULL OR v.fecha_salida <= @Hasta)
    ORDER BY v.fecha_salida DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO

DECLARE @AerolineaID INT = 2; -- <--- CAMBIA ESTO POR EL ID DE TU AEROLÍNEA (Ej: 1 o 2)

DECLARE @I INT = 1;
DECLARE @VueloID INT;
DECLARE @RutaID INT;
DECLARE @AvionID INT;
DECLARE @HorasAtras INT;
DECLARE @Pasajeros INT;
DECLARE @Precio DECIMAL(10,2);
DECLARE @Capacidad INT = 180; -- Capacidad total del avión

-- Bucle para generar 15 vuelos
WHILE @I <= 15
    BEGIN
        -- 1. Seleccionar una ruta aleatoria de la aerolínea
        SELECT TOP 1 @RutaID = ruta_id, @Precio = ISNULL(precio_base, 120.00)
        FROM ruta_aerolinea
        WHERE aerolinea_id = @AerolineaID
        ORDER BY NEWID();

        -- Si la aerolínea no tiene rutas asignadas, cogemos una genérica
        IF @RutaID IS NULL
            BEGIN
                SELECT TOP 1 @RutaID = id FROM ruta ORDER BY NEWID();
                SET @Precio = 150.00;
            END

        -- 2. Seleccionar un avión aleatorio de la aerolínea
        SELECT TOP 1 @AvionID = id FROM avion WHERE aerolinea_id = @AerolineaID ORDER BY NEWID();

        -- Si no tiene aviones, cogemos uno cualquiera
        IF @AvionID IS NULL SELECT TOP 1 @AvionID = id FROM avion ORDER BY NEWID();

        -- 3. Generar datos aleatorios para el vuelo
        SET @HorasAtras = ROUND(RAND() * 23 + 1, 0);  -- Aleatorio entre 1 y 24 horas atrás
        SET @Pasajeros = ROUND(RAND() * 60 + 100, 0); -- Aleatorio entre 100 y 160 pasajeros

        -- 4. INSERTAR EL VUELO (Añadida la capacidad_total)
        INSERT INTO vuelo (
            numero_vuelo, aerolinea_id, ruta_id, avion_id, estado_id,
            fecha_salida, fecha_llegada, pasajeros_confirmados, pasajeros_embarcados, capacidad_total
        )
        VALUES (
                   'SIM-' + CAST((1000 + @I) AS VARCHAR), -- Ej: SIM-1001
                   @AerolineaID,
                   @RutaID,
                   @AvionID,
                   7,
                   DATEADD(HOUR, -@HorasAtras, GETDATE()),
                   DATEADD(HOUR, -@HorasAtras + 2, GETDATE()), -- Vuelo de 2 horas
                   @Pasajeros + ROUND(RAND() * 5, 0), -- Algunos confirmados más que embarcados
                   @Pasajeros,
                   @Capacidad -- <--- CORRECCIÓN DEL ERROR
               );

        SET @VueloID = SCOPE_IDENTITY();

        -- 5. INSERTAR COMBUSTIBLE (Datos lógicos basados en pasajeros)
        DECLARE @Litros DECIMAL(10,2) = @Pasajeros * 30.5;

        INSERT INTO combustible_vuelo (vuelo_id, litros_cargados, litros_consumidos, precio_por_litro, fecha_registro, observaciones)
        VALUES (@VueloID, @Litros + 800, @Litros, 0.75, GETDATE(), 'Vuelo simulado para Dashboard');

        -- 6. INSERTAR FINANZAS (Cálculo real para que los gráficos cuadren)
        DECLARE @Ingresos DECIMAL(12,2) = @Pasajeros * @Precio;
        DECLARE @CosteComb DECIMAL(12,2) = @Litros * 0.75;
        DECLARE @CosteTrip DECIMAL(12,2) = 450.00;
        DECLARE @CosteMant DECIMAL(12,2) = 500.00;
        DECLARE @Otros DECIMAL(12,2) = @Ingresos * 0.12; -- 12% de tasas
        DECLARE @Beneficio DECIMAL(12,2) = @Ingresos - (@CosteComb + @CosteTrip + @CosteMant + @Otros);

        INSERT INTO finanzas_vuelo (
            vuelo_id, ingreso_pasajes, coste_combustible, coste_tripulacion,
            coste_mantenimiento, otros_costes, beneficio_neto, fecha_calculo
        )
        VALUES (
                   @VueloID, @Ingresos, @CosteComb, @CosteTrip,
                   @CosteMant, @Otros, @Beneficio, GETDATE()
               );

        -- Siguiente iteración
        SET @I = @I + 1;
    END

PRINT '¡Se han generado 15 vuelos de prueba con éxito para el Dashboard!';
GO





SELECT * FROM V_RUTAS_AVION

CREATE   OR ALTER     VIEW V_RUTAS_AVION
AS
SELECT DISTINCT
    r.id AS ruta_id,
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


SELECT * FROM RUTA WHERE aeropuerto_origen_id=1 AND aeropuerto_destino_id=2

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Eliminar asignaciones duplicadas en ruta_aerolinea
    DELETE FROM ruta_aerolinea
    WHERE id IN (
        SELECT id FROM (
                           SELECT ra.id,
                                  ROW_NUMBER() OVER(
                                      PARTITION BY r.aeropuerto_origen_id, r.aeropuerto_destino_id, ra.aerolinea_id
                                      ORDER BY ra.id
                                      ) as row_num
                           FROM ruta_aerolinea ra
                                    INNER JOIN ruta r ON ra.ruta_id = r.id
                       ) t
        WHERE t.row_num > 1
    );

    -- 2. Unificar ruta_aerolinea a la ruta original
    UPDATE ra
    SET ra.ruta_id = ruta_original.id_minimo
    FROM ruta_aerolinea ra
             INNER JOIN ruta r_actual ON ra.ruta_id = r_actual.id
             INNER JOIN (
        SELECT aeropuerto_origen_id, aeropuerto_destino_id, MIN(id) as id_minimo
        FROM ruta
        GROUP BY aeropuerto_origen_id, aeropuerto_destino_id
    ) ruta_original
                        ON r_actual.aeropuerto_origen_id = ruta_original.aeropuerto_origen_id
                            AND r_actual.aeropuerto_destino_id = ruta_original.aeropuerto_destino_id;

    -- 2.5 NUEVO: Unificar los VUELOS a la ruta original (Soluciona tu error)
    UPDATE v
    SET v.ruta_id = ruta_original.id_minimo
    FROM vuelo v
             INNER JOIN ruta r_actual ON v.ruta_id = r_actual.id
             INNER JOIN (
        SELECT aeropuerto_origen_id, aeropuerto_destino_id, MIN(id) as id_minimo
        FROM ruta
        GROUP BY aeropuerto_origen_id, aeropuerto_destino_id
    ) ruta_original
                        ON r_actual.aeropuerto_origen_id = ruta_original.aeropuerto_origen_id
                            AND r_actual.aeropuerto_destino_id = ruta_original.aeropuerto_destino_id;

    -- 3. Borrar las rutas físicas duplicadas (ahora sí, nadie las usa)
    WITH CTE_Rutas AS (
        SELECT id,
               ROW_NUMBER() OVER(
                   PARTITION BY aeropuerto_origen_id, aeropuerto_destino_id
                   ORDER BY id
                   ) as row_num
        FROM ruta
    )
    DELETE FROM CTE_Rutas WHERE row_num > 1;

    COMMIT TRANSACTION;
    PRINT '¡Limpieza completada! Base de datos optimizada y sin duplicados.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO