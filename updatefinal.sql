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



-- Varsovia → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    689;

-- Varsovia → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    517;

-- Varsovia → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    575;

-- Varsovia → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    1150;

-- Varsovia → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    1245;

-- Varsovia → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    520;

-- Varsovia → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    814;

-- Varsovia → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    549;

-- Varsovia → Tallin
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    760;

-- Varsovia → Vilna
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    430;

    -- ══════════════════════════════════════════
-- DESDE BUDAPEST (BUD)
-- ══════════════════════════════════════════

-- Budapest → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    443;

-- Budapest → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    214;

-- Budapest → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    639;

-- Budapest → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    640;

-- Budapest → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    345;

-- Budapest → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    163;

-- Budapest → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    316;

-- Budapest → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    1280;

    -- ══════════════════════════════════════════
-- DESDE PRAGA (PRG)
-- ══════════════════════════════════════════

-- Praga → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    251;

-- Praga → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    251;

-- Praga → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    615;

-- Praga → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    1024;

-- Praga → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    1063;

-- Praga → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    1074;

-- Praga → Tallin
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    1287;

-- Praga → Vilna
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    945;

-- Praga → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    1534;

    -- ══════════════════════════════════════════
-- DESDE VIENA (VIE)
-- ══════════════════════════════════════════

-- Viena → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    55;

-- Viena → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    292;

-- Viena → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    829;

-- Viena → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    806;

-- Viena → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    536;

-- Viena → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    1291;

    -- ══════════════════════════════════════════
-- DESDE BUCAREST (OTP)
-- ══════════════════════════════════════════

-- Bucarest → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    302;

-- Bucarest → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    476;

-- Bucarest → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    859;

-- Bucarest → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    639;

    -- ══════════════════════════════════════════
-- DESDE SOFÍA (SOF)
-- ══════════════════════════════════════════

-- Sofía → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    390;

-- Sofía → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    750;

-- Sofía → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    524;

    -- ══════════════════════════════════════════
-- DESDE ZAGREB (ZAG)
-- ══════════════════════════════════════════

-- Zagreb → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    372;

-- Zagreb → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    1048;

-- Zagreb → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    332;

    -- ══════════════════════════════════════════
-- DESDE RIGA (RIX)
-- ══════════════════════════════════════════

-- Riga → Tallin
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    281;

-- Riga → Vilna
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    267;

-- Riga → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    1269;

-- Riga → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    1309;

    -- ══════════════════════════════════════════
-- DESDE TALLIN (TLL)
-- ══════════════════════════════════════════

-- Tallin → Vilna
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    541;

-- Tallin → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    1541;

-- Tallin → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    1287;

    -- ══════════════════════════════════════════
-- DESDE VILNA (VNO)
-- ══════════════════════════════════════════

-- Vilna → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    1033;

-- Vilna → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    1007;

    -- ══════════════════════════════════════════
-- DESDE BRATISLAVA (BTS)
-- ══════════════════════════════════════════

-- Bratislava → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    434;

-- Bratislava → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    874;

-- Bratislava → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    850;

    -- ══════════════════════════════════════════
-- DESDE BELGRADO (BEG)
-- ══════════════════════════════════════════

-- Belgrado → Atenas
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    805;

    -- ══════════════════════════════════════════
-- RUTAS INVERSAS (para vuelos de vuelta)
-- ══════════════════════════════════════════

-- Budapest → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    689;

-- Praga → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    517;

-- Viena → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    575;

-- Bucarest → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    1150;

-- Sofía → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    1245;

-- Bratislava → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    520;

-- Zagreb → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    814;

-- Riga → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    549;

-- Tallin → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    760;

-- Vilna → Varsovia
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'WAW'),
    430;

-- Praga → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    443;

-- Viena → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    214;

-- Bucarest → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    639;

-- Sofía → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    640;

-- Zagreb → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    345;

-- Bratislava → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    163;

-- Belgrado → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    316;

-- Atenas → Budapest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    1280;

-- Viena → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    251;

-- Bratislava → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    251;

-- Zagreb → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    615;

-- Sofía → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    1024;

-- Bucarest → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    1063;

-- Riga → Praga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'PRG'),
    1074;

-- Tallin → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    281;

-- Vilna → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    267;

-- Budapest → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BUD'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    1269;

-- Viena → Riga
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'RIX'),
    1309;

-- Vilna → Tallin
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VNO'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'TLL'),
    541;

-- Bratislava → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    55;

-- Zagreb → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    292;

-- Bucarest → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    829;

-- Sofía → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    806;

-- Belgrado → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    536;

-- Atenas → Viena
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'VIE'),
    1291;

-- Sofía → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    302;

-- Belgrado → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    476;

-- Zagreb → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    859;

-- Atenas → Bucarest
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    639;

-- Belgrado → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    390;

-- Zagreb → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    750;

-- Atenas → Sofía
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    524;

-- Belgrado → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    372;

-- Atenas → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    1048;

-- Bratislava → Zagreb
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ZAG'),
    332;

-- Belgrado → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    434;

-- Bucarest → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'OTP'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    874;

-- Sofía → Bratislava
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'SOF'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BTS'),
    850;

-- Atenas → Belgrado
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
SELECT
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'ATH'),
    (SELECT id FROM aeropuerto WHERE codigo_iata = 'BEG'),
    805;

GO

-- ══════════════════════════════════════════
-- ASIGNAR RUTAS A RYANAIR (ID = 2)
-- ══════════════════════════════════════════

-- Asignar TODAS las rutas de Europa Central/Oriental a Ryanair
INSERT INTO ruta_aerolinea (ruta_id, aerolinea_id, activa, precio_base, frecuencia_semanal)
SELECT
    r.id,
    2, -- Ryanair
    1, -- Activa
    CASE
        WHEN r.distancia_km < 300 THEN 19.99
        WHEN r.distancia_km < 600 THEN 29.99
        WHEN r.distancia_km < 1000 THEN 39.99
        ELSE 49.99
        END AS precio_base,
    CASE
        WHEN r.distancia_km < 300 THEN 14 -- 2 vuelos diarios
        WHEN r.distancia_km < 600 THEN 7  -- 1 vuelo diario
        WHEN r.distancia_km < 1000 THEN 5 -- 5 vuelos semanales
        ELSE 3 -- 3 vuelos semanales
        END AS frecuencia_semanal
FROM ruta r
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
WHERE ao.codigo_iata IN ('WAW', 'BUD', 'PRG', 'VIE', 'OTP', 'SOF', 'BTS', 'ZAG', 'RIX', 'TLL', 'VNO', 'BEG', 'ATH')
  AND ad.codigo_iata IN ('WAW', 'BUD', 'PRG', 'VIE', 'OTP', 'SOF', 'BTS', 'ZAG', 'RIX', 'TLL', 'VNO', 'BEG', 'ATH')
  -- Excluir rutas que ya existan
  AND NOT EXISTS (
    SELECT 1
    FROM ruta_aerolinea ra
    WHERE ra.ruta_id = r.id
      AND ra.aerolinea_id = 2
);

GO

