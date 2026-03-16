
use[PDA_AEROLINEAS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_VUELOS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_VALIDAR_TRIPULACION_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_VALIDADICION_CREACION_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_USUARIOS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_USUARIOS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_TRIPULACION]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_GESTION_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_ESTADOVUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_ESTADO_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_AEROPUERTO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATE_AEROLINEA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_TRIPULANTES_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_RUTAS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_REGISTRAR_USUARIO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_REGISTRAR_RETRASO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_PROGRAMAR_MANTENIMIENTO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_MANTENIMIENTOS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_MANTENIMIENTO_INICIAR]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_MANTENIMIENTO_COMPLETAR]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_MANTENIMIENTO_CANCELAR]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GUARDAR_POSICION_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_VUELOS_RECIENTES]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_VUELOS_POR_HORA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_VUELOS_POR_ESTADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_TRIPULANTES_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_TRIPULANTES_DISPONIBLES]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_TOP_RUTAS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_TELEMETRIA_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_RUTAS_POR_AVION]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_RUTAS_NO_OPERADAS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_RUTAS_DISPONIBLES_AEROLINEA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_PROXIMOS_VUELOS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_OCUPACION_SEMANAL]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_DASHBOARD_STATS]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_GET_AERONAVES_POR_ESTADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_FLOTAS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_DESACTIVAR_RUTA_AEROLINEA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_VUELO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_TRIPULACION]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_RUTA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_AVION]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_AEROPUERTO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_CREATE_AEROLINEA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_AVIONES_CON_RUTAS_DISPONIBLES]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_ASIGNAR_TRIPULACION]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_ASIGNAR_RUTA_AEROLINEA]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_AEROPUERTOS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_AEROLINEAS_PAGINADO]
GO
DROP PROCEDURE IF EXISTS [dbo].[SP_ACTUALIZAR_ESTADO_MANTENIMIENTO]
GO
DROP TABLE IF EXISTS dbo.retraso_vuelo;
DROP TABLE IF EXISTS dbo.asignacion_tripulacion;
DROP TABLE IF EXISTS dbo.registro_estado_avion;

-- 2. Tablas de Segundo Nivel (Dependen de aviones, rutas o usuarios)
DROP TABLE IF EXISTS dbo.vuelo;
DROP TABLE IF EXISTS dbo.mantenimiento;
DROP TABLE IF EXISTS dbo.usuario_rol;
DROP TABLE IF EXISTS dbo.users_security;
DROP TABLE IF EXISTS dbo.ruta_aerolinea;

-- 3. Tablas de Primer Nivel (Las que tienen las FK hacia las maestras)
DROP TABLE IF EXISTS dbo.usuario;
DROP TABLE IF EXISTS dbo.avion;
DROP TABLE IF EXISTS dbo.tripulante;
DROP TABLE IF EXISTS dbo.ruta;
DROP TABLE IF EXISTS dbo.aeropuerto;

-- 4. Tablas Maestras (Las que no dependen de nadie)
DROP TABLE IF EXISTS dbo.aerolinea; -- <--- Ahora ya no tendrá dependencias
DROP TABLE IF EXISTS dbo.modelo_avion;
DROP TABLE IF EXISTS dbo.estado_avion;
DROP TABLE IF EXISTS dbo.estado_vuelo;
DROP TABLE IF EXISTS dbo.mantenimiento_tipo;
DROP TABLE IF EXISTS dbo.codigo_retraso_iata;
DROP TABLE IF EXISTS dbo.rol;
DROP TABLE IF EXISTS dbo.pais;
/****** Object:  Table [dbo].[registro_estado_avion]    Script Date: 16/03/2026 14:02:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[registro_estado_avion]') AND type in (N'U'))
    DROP TABLE [dbo].[registro_estado_avion]
GO
/****** Object:  View [dbo].[V_VUELOS_TRACKING]    Script Date: 16/03/2026 14:02:29 ******/
DROP VIEW IF EXISTS [dbo].[V_VUELOS_TRACKING]
GO
DROP VIEW IF EXISTS [dbo].[V_VUELOS]
GO
DROP VIEW IF EXISTS [dbo].[V_TRIPULACION_VUELOS]
GO
DROP VIEW IF EXISTS [dbo].[V_TRIPULACION_ROLES]
GO
DROP VIEW IF EXISTS [dbo].[V_RUTAS_AVION]
GO
DROP VIEW IF EXISTS [dbo].[V_RUTAS_AEROLINEAS]
GO
DROP VIEW IF EXISTS [dbo].[V_RETRASOS_DETALLADOS]
GO
DROP VIEW IF EXISTS [dbo].[V_PRUEBA_AVION]
GO
DROP VIEW IF EXISTS [dbo].[V_MANTENIMIENTOS]
GO
DROP VIEW IF EXISTS [dbo].[V_LOGGED_USER]
GO
DROP VIEW IF EXISTS [dbo].[V_LOGED_USER]
GO
DROP VIEW IF EXISTS [dbo].[V_HISTORIAL_VUELOS_AVION]
GO
DROP VIEW IF EXISTS [dbo].[V_FLOTA_ESTADO]
GO
DROP VIEW IF EXISTS [dbo].[V_DATOS_USUARIO]
GO
DROP VIEW IF EXISTS [dbo].[V_AVIONES]
GO
DROP VIEW IF EXISTS [dbo].[V_AEROPUERTOS_EN_RUTAS]
GO
DROP VIEW IF EXISTS [dbo].[V_ADMINISTRACION_USUARIOS]
GO
DROP VIEW IF EXISTS [dbo].[v_vuelos_completos]
GO
DROP VIEW IF EXISTS [dbo].[v_dashboard_operacional]
GO


DROP TABLE IF EXISTS [dbo].[asignacion_tripulacion]
GO
DROP TABLE IF EXISTS [dbo].[tripulante]
GO
DROP TABLE IF EXISTS [dbo].[ruta_aerolinea]
GO
DROP TABLE IF EXISTS [dbo].[codigo_retraso_iata]
GO
DROP TABLE IF EXISTS [dbo].[mantenimiento_tipo]
GO
DROP TABLE IF EXISTS [dbo].[retraso_vuelo]
GO
DROP TABLE IF EXISTS [dbo].[mantenimiento]
GO
DROP TABLE IF EXISTS [dbo].[users_security]
GO
DROP TABLE IF EXISTS [dbo].[estado_avion]
GO
DROP TABLE IF EXISTS [dbo].[pais]
GO
DROP TABLE IF EXISTS [dbo].[usuario_rol]
GO
DROP TABLE IF EXISTS [dbo].[usuario]
GO
DROP TABLE IF EXISTS [dbo].[rol]
GO
DROP TABLE IF EXISTS [dbo].[estado_vuelo]
GO
DROP TABLE IF EXISTS [dbo].[modelo_avion]
GO
DROP TABLE IF EXISTS [dbo].[ruta]
GO
DROP TABLE IF EXISTS [dbo].[aeropuerto]
GO
/****** Object:  View [dbo].[v_dashboard_operacional]    Script Date: 16/03/2026 14:02:29 ******/
DROP VIEW  IF EXISTS [dbo].[v_dashboard_operacional]
GO
/****** Object:  Table [dbo].[vuelo]    Script Date: 16/03/2026 14:02:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vuelo]') AND type in (N'U'))
    DROP TABLE [dbo].[vuelo]
GO
/****** Object:  Table [dbo].[avion]    Script Date: 16/03/2026 14:02:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[avion]') AND type in (N'U'))
    DROP TABLE [dbo].[avion]
GO
/****** Object:  Table [dbo].[aerolinea]    Script Date: 16/03/2026 14:02:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aerolinea]') AND type in (N'U'))
    DROP TABLE [dbo].[aerolinea]
GO

/****** Object:  Database [PDA_AEROLINEAS]    Script Date: 16/03/2026 14:02:29 ******/

USE [PDA_AEROLINEAS]
GO
/****** Object:  Table [dbo].[aerolinea]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aerolinea](
                                  [id] [int] IDENTITY(1,1) NOT NULL,
                                  [nombre] [nvarchar](100) NOT NULL,
                                  [logo] [nvarchar](250) NOT NULL,
                                  [codigo_iata] [nvarchar](3) NOT NULL,
                                  PRIMARY KEY CLUSTERED
                                      (
                                       [id] ASC
                                          )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[avion]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[avion](
                              [id] [int] IDENTITY(1,1) NOT NULL,
                              [matricula] [nvarchar](20) NOT NULL,
                              [modelo_id] [int] NOT NULL,
                              [aerolinea_id] [int] NOT NULL,
                              [estado_id] [int] NOT NULL,
                              [aeropuerto_actual_id] [int] NOT NULL,
                              [horas_vuelo_totales] [int] NOT NULL,
                              [ciclos_totales] [int] NOT NULL,
                              PRIMARY KEY CLUSTERED
                                  (
                                   [id] ASC
                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vuelo]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vuelo](
                              [id] [int] IDENTITY(1,1) NOT NULL,
                              [numero_vuelo] [nvarchar](10) NOT NULL,
                              [aerolinea_id] [int] NOT NULL,
                              [ruta_id] [int] NOT NULL,
                              [avion_id] [int] NOT NULL,
                              [fecha_salida] [datetime] NOT NULL,
                              [fecha_llegada] [datetime] NOT NULL,
                              [estado_id] [int] NOT NULL,
                              [puerta] [nvarchar](10) NOT NULL,
                              [capacidad_total] [int] NOT NULL,
                              [pasajeros_confirmados] [int] NOT NULL,
                              [pasajeros_embarcados] [int] NOT NULL,
                              [telemetria] [nvarchar](max) NULL,
                              PRIMARY KEY CLUSTERED
                                  (
                                   [id] ASC
                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_dashboard_operacional]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[v_dashboard_operacional] AS
SELECT
    al.id AS aerolinea_id,
    al.nombre AS nombre_aerolinea,

    -- VUELOS
    (SELECT COUNT(*) FROM vuelo v WHERE v.aerolinea_id = al.id AND v.estado_id = 1 AND v.fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_programados_hoy,
    (SELECT COUNT(*) FROM vuelo v WHERE v.aerolinea_id = al.id AND v.estado_id = 3) AS vuelos_en_curso,
    (SELECT COUNT(*) FROM vuelo v WHERE v.aerolinea_id = al.id AND v.estado_id = 4 AND v.fecha_llegada >= CAST(GETDATE() AS DATE)) AS vuelos_aterrizados_hoy,
    (SELECT COUNT(*) FROM vuelo v WHERE v.aerolinea_id = al.id AND v.estado_id = 5 AND v.fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_cancelados_hoy,
    (SELECT COUNT(*) FROM vuelo v WHERE v.aerolinea_id = al.id AND v.estado_id = 6 AND v.fecha_salida >= CAST(GETDATE() AS DATE)) AS vuelos_retrasados_hoy,

    -- FLOTA
    (SELECT COUNT(*) FROM avion av WHERE av.aerolinea_id = al.id AND av.estado_id = 1) AS aviones_operativos,
    (SELECT COUNT(*) FROM avion av WHERE av.aerolinea_id = al.id AND av.estado_id = 2) AS aviones_en_mantenimiento,
    (SELECT COUNT(*) FROM avion av WHERE av.aerolinea_id = al.id AND av.estado_id = 3) AS aviones_en_vuelo,

    -- OCUPACIÓN (Con ISNULL para que devuelva 0 si no hay vuelos, y NULLIF para evitar error de división por cero)
    ISNULL((SELECT AVG(CAST(v.pasajeros_confirmados AS FLOAT) / NULLIF(v.capacidad_total, 0) * 100)
            FROM vuelo v
            WHERE v.aerolinea_id = al.id AND v.fecha_salida >= CAST(GETDATE() AS DATE)), 0) AS ocupacion_promedio_hoy

FROM aerolinea al
GO
/****** Object:  Table [dbo].[aeropuerto]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aeropuerto](
                                   [id] [int] IDENTITY(1,1) NOT NULL,
                                   [nombre] [nvarchar](150) NOT NULL,
                                   [codigo_iata] [nvarchar](3) NOT NULL,
                                   [codigo_icao] [nvarchar](4) NOT NULL,
                                   [ciudad] [nvarchar](100) NOT NULL,
                                   [pais_id] [int] NOT NULL,
                                   [latitud] [decimal](9, 6) NOT NULL,
                                   [longitud] [decimal](9, 6) NOT NULL,
                                   PRIMARY KEY CLUSTERED
                                       (
                                        [id] ASC
                                           )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ruta]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ruta](
                             [id] [int] IDENTITY(1,1) NOT NULL,
                             [aeropuerto_origen_id] [int] NOT NULL,
                             [aeropuerto_destino_id] [int] NOT NULL,
                             [distancia_km] [int] NOT NULL,
                             PRIMARY KEY CLUSTERED
                                 (
                                  [id] ASC
                                     )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[modelo_avion]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[modelo_avion](
                                     [id] [int] IDENTITY(1,1) NOT NULL,
                                     [fabricante] [nvarchar](100) NOT NULL,
                                     [nombre_modelo] [nvarchar](100) NOT NULL,
                                     [capacidad_total] [int] NOT NULL,
                                     [alcance_km] [int] NOT NULL,
                                     PRIMARY KEY CLUSTERED
                                         (
                                          [id] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[estado_vuelo]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[estado_vuelo](
                                     [id] [int] IDENTITY(1,1) NOT NULL,
                                     [nombre] [nvarchar](50) NOT NULL,
                                     PRIMARY KEY CLUSTERED
                                         (
                                          [id] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_vuelos_completos]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[v_vuelos_completos] AS
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
GO
/****** Object:  Table [dbo].[rol]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rol](
                            [id] [int] IDENTITY(1,1) NOT NULL,
                            [nombre] [nvarchar](50) NOT NULL,
                            PRIMARY KEY CLUSTERED
                                (
                                 [id] ASC
                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario](
                                [id] [int] IDENTITY(1,1) NOT NULL,
                                [nombre] [nvarchar](50) NOT NULL,
                                [apellidos] [nvarchar](50) NOT NULL,
                                [email] [nvarchar](100) NOT NULL,
                                [password] [nvarchar](100) NOT NULL,
                                [aerolinea_id] [int] NOT NULL,
                                [activo] [bit] NOT NULL,
                                PRIMARY KEY CLUSTERED
                                    (
                                     [id] ASC
                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario_rol]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario_rol](
                                    [usuario_id] [int] NOT NULL,
                                    [rol_id] [int] NOT NULL,
                                    PRIMARY KEY CLUSTERED
                                        (
                                         [usuario_id] ASC,
                                         [rol_id] ASC
                                            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_ADMINISTRACION_USUARIOS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     view [dbo].[V_ADMINISTRACION_USUARIOS]
AS
select
    u.id,
    u.nombre ,
    u.apellidos,
    u.email,
    rol.nombre AS rol,
    ae.id  AS aerolinea_id,
    ae.nombre as aerolinea,
    u.activo

from usuario u
         inner join usuario_rol ur ON u.id = ur.usuario_id
         inner join rol ON ur.rol_id=rol.id
         inner join aerolinea ae ON u.aerolinea_id=ae.id
GO
/****** Object:  Table [dbo].[pais]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pais](
                             [id] [int] IDENTITY(1,1) NOT NULL,
                             [nombre] [nvarchar](100) NOT NULL,
                             [codigo_iso] [nvarchar](3) NOT NULL,
                             PRIMARY KEY CLUSTERED
                                 (
                                  [id] ASC
                                     )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_AEROPUERTOS_EN_RUTAS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- VISTA: Aeropuertos en Rutas
-- ============================================
CREATE   VIEW [dbo].[V_AEROPUERTOS_EN_RUTAS] AS
SELECT DISTINCT
    a.id AS aeropuerto_id,
    a.codigo_iata,
    a.nombre,
    a.ciudad,
    a.latitud,
    a.longitud,
    p.nombre AS pais,
    p.codigo_iso,

    -- Contar rutas como origen
    (SELECT COUNT(*)
     FROM ruta
     WHERE aeropuerto_origen_id = a.id) AS rutas_como_origen,

    -- Contar rutas como destino
    (SELECT COUNT(*)
     FROM ruta
     WHERE aeropuerto_destino_id = a.id) AS rutas_como_destino,

    -- Total de rutas
    (SELECT COUNT(*)
     FROM ruta
     WHERE aeropuerto_origen_id = a.id
        OR aeropuerto_destino_id = a.id) AS total_rutas

FROM aeropuerto a
         INNER JOIN pais p ON a.pais_id = p.id
WHERE
    -- Solo aeropuertos que están en al menos una ruta
    EXISTS (
        SELECT 1
        FROM ruta r
        WHERE r.aeropuerto_origen_id = a.id
           OR r.aeropuerto_destino_id = a.id
    )
GO
/****** Object:  Table [dbo].[estado_avion]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[estado_avion](
                                     [id] [int] IDENTITY(1,1) NOT NULL,
                                     [nombre] [nvarchar](50) NOT NULL,
                                     PRIMARY KEY CLUSTERED
                                         (
                                          [id] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_AVIONES]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       view [dbo].[V_AVIONES]
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
GO
/****** Object:  Table [dbo].[users_security]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users_security](
                                       [id_usuario] [int] NOT NULL,
                                       [salt] [nvarchar](100) NOT NULL,
                                       [pass] [varbinary](max) NOT NULL,
                                       PRIMARY KEY CLUSTERED
                                           (
                                            [id_usuario] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_DATOS_USUARIO]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[V_DATOS_USUARIO] AS
select u.id,u.aerolinea_id,u.email,u.password,us.salt,us.pass from usuario u
                                                                       inner join users_security us on  u.id=us.id_usuario
GO
/****** Object:  Table [dbo].[mantenimiento]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mantenimiento](
                                      [id] [int] IDENTITY(1,1) NOT NULL,
                                      [avion_id] [int] NOT NULL,
                                      [mantenimiento_tipo_id] [int] NOT NULL,
                                      [estado] [nvarchar](50) NOT NULL,
                                      [fecha_programada] [date] NOT NULL,
                                      [fecha_inicio] [datetime] NULL,
                                      [fecha_fin] [datetime] NULL,
                                      [descripcion] [nvarchar](max) NULL,
                                      PRIMARY KEY CLUSTERED
                                          (
                                           [id] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_FLOTA_ESTADO]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       VIEW [dbo].[V_FLOTA_ESTADO] AS
SELECT
    av.id               AS avion_id,
    av.matricula,
    av.aerolinea_id as id_aerolinea,
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
GO
/****** Object:  Table [dbo].[retraso_vuelo]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[retraso_vuelo](
                                      [id] [int] IDENTITY(1,1) NOT NULL,
                                      [vuelo_id] [int] NOT NULL,
                                      [codigo_retraso_id] [int] NOT NULL,
                                      [minutos] [int] NOT NULL,
                                      PRIMARY KEY CLUSTERED
                                          (
                                           [id] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_HISTORIAL_VUELOS_AVION]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- VISTA: V_HISTORIAL_VUELOS_AVION
-- Historial completo de vuelos por avión
-- ============================================
CREATE   VIEW [dbo].[V_HISTORIAL_VUELOS_AVION] AS
SELECT
    v.id                                    AS VUELO_ID,
    av.id                                   AS AVION_ID,
    av.matricula                            AS MATRICULA,
    ma.fabricante                           AS FABRICANTE,
    ma.nombre_modelo                        AS NOMBRE_MODELO,
    a.nombre                                AS AEROLINEA,
    a.codigo_iata                           AS CODIGO_AEROLINEA,
    v.numero_vuelo                          AS NUMERO_VUELO,
    v.fecha_salida                          AS FECHA_SALIDA,
    v.fecha_llegada                         AS FECHA_LLEGADA,
    ev.nombre                               AS ESTADO_VUELO,
    v.estado_id                             AS ESTADO_ID,
    ao.codigo_iata                          AS CODIGO_ORIGEN,
    ao.nombre                               AS AEROPUERTO_ORIGEN,
    ao.ciudad                               AS CIUDAD_ORIGEN,
    ad.codigo_iata                          AS CODIGO_DESTINO,
    ad.nombre                               AS AEROPUERTO_DESTINO,
    ad.ciudad                               AS CIUDAD_DESTINO,
    r.distancia_km                          AS DISTANCIA_KM,
    v.capacidad_total                       AS CAPACIDAD_TOTAL,
    v.pasajeros_confirmados                 AS PASAJEROS_CONFIRMADOS,
    v.pasajeros_embarcados                  AS PASAJEROS_EMBARCADOS,
    CASE
        WHEN v.capacidad_total > 0
            THEN CAST(ROUND(v.pasajeros_confirmados * 100.0 / v.capacidad_total, 1) AS DECIMAL(5,1))
        ELSE 0
        END                                     AS PORCENTAJE_OCUPACION,
    DATEDIFF(MINUTE, v.fecha_salida, v.fecha_llegada) AS DURACION_MINUTOS,
    ISNULL(rv.minutos, 0)                   AS MINUTOS_RETRASO,
    v.telemetria                            AS TELEMETRIA,
    v.puerta                                AS PUERTA,
    ao.codigo_iata + ' → ' + ad.codigo_iata AS RUTA_CODIGO
FROM vuelo v
         INNER JOIN avion av ON v.avion_id = av.id
         INNER JOIN modelo_avion ma ON av.modelo_id = ma.id
         INNER JOIN aerolinea a ON v.aerolinea_id = a.id
         INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
         INNER JOIN ruta r ON v.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
         LEFT JOIN retraso_vuelo rv ON v.id = rv.vuelo_id
GO
/****** Object:  View [dbo].[V_LOGED_USER]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[V_LOGED_USER]
AS
select
    u.id as idUsuario,
    u.aerolinea_id as idAerolinea,
    u.nombre,
    ur.rol_id

from usuario u
         inner join usuario_rol ur on u.id= ur.usuario_id
GO
/****** Object:  View [dbo].[V_LOGGED_USER]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[V_LOGGED_USER]
AS
select
    u.id as idUsuario,
    u.email,
    u.aerolinea_id as idAerolinea,
    u.nombre,
    ur.rol_id,
    r.nombre as rol

from usuario u
         inner join usuario_rol ur on u.id= ur.usuario_id
         inner join rol r on ur.rol_id =r.id
GO
/****** Object:  Table [dbo].[mantenimiento_tipo]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mantenimiento_tipo](
                                           [id] [int] IDENTITY(1,1) NOT NULL,
                                           [nombre] [nvarchar](100) NOT NULL,
                                           [intervalo_horas] [int] NULL,
                                           [intervalo_ciclos] [int] NULL,
                                           [intervalo_dias] [int] NULL,
                                           PRIMARY KEY CLUSTERED
                                               (
                                                [id] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_MANTENIMIENTOS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[V_MANTENIMIENTOS] AS
select m.*,
       av.aerolinea_id         AS AEROLINEA_ID,
       mt.nombre as tipo,
       av.matricula,
       mod.nombre_modelo
from mantenimiento as m
         inner join avion as av on m.avion_id = av.id
         inner join modelo_avion as mod on av.modelo_id = mod.id
         inner join mantenimiento_tipo as mt on m.mantenimiento_tipo_id=mt.id
GO
/****** Object:  View [dbo].[V_PRUEBA_AVION]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create      view [dbo].[V_PRUEBA_AVION]
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
GO
/****** Object:  Table [dbo].[codigo_retraso_iata]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[codigo_retraso_iata](
                                            [id] [int] IDENTITY(1,1) NOT NULL,
                                            [codigo] [nvarchar](5) NOT NULL,
                                            [descripcion] [nvarchar](250) NOT NULL,
                                            PRIMARY KEY CLUSTERED
                                                (
                                                 [id] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_RETRASOS_DETALLADOS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[V_RETRASOS_DETALLADOS] AS
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
GO
/****** Object:  Table [dbo].[ruta_aerolinea]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ruta_aerolinea](
                                       [id] [int] IDENTITY(1,1) NOT NULL,
                                       [ruta_id] [int] NOT NULL,
                                       [aerolinea_id] [int] NOT NULL,
                                       [activa] [bit] NOT NULL,
                                       [precio_base] [decimal](10, 2) NULL,
                                       [frecuencia_semanal] [int] NULL,
                                       [fecha_inicio] [date] NULL,
                                       [fecha_fin] [date] NULL,
                                       [observaciones] [nvarchar](500) NULL,
                                       PRIMARY KEY CLUSTERED
                                           (
                                            [id] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_RUTAS_AEROLINEAS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[V_RUTAS_AEROLINEAS] AS
SELECT
    al.id AS aerolinea_id,
    al.nombre AS aerolinea,
    al.codigo_iata AS codigo_aerolinea,
    r.id AS ruta_id,
    ao.codigo_iata + '-' + ad.codigo_iata AS codigo_ruta,
    ao.id AS aeropuerto_origen_id,
    ao.codigo_iata AS codigo_origen,
    ao.nombre AS aeropuerto_origen,
    ao.ciudad AS ciudad_origen,
    ad.id AS aeropuerto_destino_id,
    ad.codigo_iata AS codigo_destino,
    ad.nombre AS aeropuerto_destino,
    ad.ciudad AS ciudad_destino,
    r.distancia_km,
    ra.activa,
    ra.precio_base,
    ra.frecuencia_semanal,
    ra.fecha_inicio,
    ra.fecha_fin,
    -- Estadísticas
    (SELECT COUNT(*)
     FROM vuelo v
     WHERE v.ruta_id = r.id
       AND v.aerolinea_id = al.id) AS total_vuelos,
    (SELECT COUNT(*)
     FROM vuelo v
     WHERE v.ruta_id = r.id
       AND v.aerolinea_id = al.id
       AND v.estado_id = 7) AS vuelos_completados
FROM ruta_aerolinea ra
         INNER JOIN aerolinea al ON ra.aerolinea_id = al.id
         INNER JOIN ruta r ON ra.ruta_id = r.id
         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
GO
/****** Object:  View [dbo].[V_RUTAS_AVION]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        VIEW [dbo].[V_RUTAS_AVION]
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
GO
/****** Object:  Table [dbo].[tripulante]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tripulante](
                                   [id] [int] IDENTITY(1,1) NOT NULL,
                                   [id_aerolinea] [int] NULL,
                                   [nombre] [nvarchar](100) NOT NULL,
                                   [apellido] [nvarchar](100) NOT NULL,
                                   [rol] [nvarchar](50) NOT NULL,
                                   [activo] [bit] NOT NULL,
                                   PRIMARY KEY CLUSTERED
                                       (
                                        [id] ASC
                                           )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_TRIPULACION_ROLES]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        VIEW [dbo].[V_TRIPULACION_ROLES] AS
SELECT
    t.id                            AS tripulante_id,
    t.id_aerolinea                            AS aerolinea_id,
    t.nombre + ' ' + t.apellido     AS nombre_completo,
    t.rol,
    t.activo
FROM tripulante t
GO
/****** Object:  Table [dbo].[asignacion_tripulacion]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[asignacion_tripulacion](
                                               [id] [int] IDENTITY(1,1) NOT NULL,
                                               [tripulante_id] [int] NOT NULL,
                                               [vuelo_id] [int] NOT NULL,
                                               PRIMARY KEY CLUSTERED
                                                   (
                                                    [id] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_TRIPULACION_VUELOS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        VIEW [dbo].[V_TRIPULACION_VUELOS] AS
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
GO
/****** Object:  View [dbo].[V_VUELOS]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        VIEW [dbo].[V_VUELOS] AS
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
GO
/****** Object:  View [dbo].[V_VUELOS_TRACKING]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[V_VUELOS_TRACKING] AS
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

        -- ✅ Calcular progreso una sola vez (siempre que esté En Vuelo, clampeado 0-1)
        CASE
            WHEN v.estado_id = 3 THEN
                CASE
                    WHEN DATEDIFF(SECOND, v.fecha_salida, v.fecha_llegada) = 0 THEN 1.0
                    WHEN GETDATE() <= v.fecha_salida THEN 0.0
                    WHEN GETDATE() >= v.fecha_llegada THEN 1.0
                    ELSE CAST(DATEDIFF(SECOND, v.fecha_salida, GETDATE()) AS FLOAT) /
                         DATEDIFF(SECOND, v.fecha_salida, v.fecha_llegada)
                    END
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
GO
/****** Object:  Table [dbo].[registro_estado_avion]    Script Date: 16/03/2026 14:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[registro_estado_avion](
                                              [id] [int] IDENTITY(1,1) NOT NULL,
                                              [avion_id] [int] NOT NULL,
                                              [aeropuerto_id] [int] NOT NULL,
                                              [latitud] [decimal](9, 6) NOT NULL,
                                              [longitud] [decimal](9, 6) NOT NULL,
                                              [fecha_hora] [datetime] NOT NULL,
                                              PRIMARY KEY CLUSTERED
                                                  (
                                                   [id] ASC
                                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[aerolinea] ON
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (1, N'Iberia', N'logo-iberia.png', N'IB')
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (2, N'Ryanair', N'https://1000marcas.net/wp-content/uploads/2020/01/Ryanair-Logotipo.jpg', N'FR')
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (3, N'Vueling', N'https://1000marcas.net/wp-content/uploads/2020/11/Vueling-Logo.png', N'VY')
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (4, N'Air Europa', N'logo-iberia.png', N'UX')
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (5, N'Lufthansa', N'https://1000marcas.net/wp-content/uploads/2020/03/Lufthansa-Logo.png', N'LH')
GO
INSERT [dbo].[aerolinea] ([id], [nombre], [logo], [codigo_iata]) VALUES (6, N'prueba', N'gt5000.png', N'pb')
GO
SET IDENTITY_INSERT [dbo].[aerolinea] OFF
GO
SET IDENTITY_INSERT [dbo].[aeropuerto] ON
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (1, N'Adolfo Suárez Madrid-Barajas', N'MAD', N'LEMD', N'Madrid', 1, CAST(40.471926 AS Decimal(9, 6)), CAST(-3.568381 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (2, N'Barcelona-El Prat', N'BCN', N'LEBL', N'Barcelona', 1, CAST(41.297078 AS Decimal(9, 6)), CAST(2.078464 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (3, N'Málaga-Costa del Sol', N'AGP', N'LEMG', N'Málaga', 1, CAST(36.674919 AS Decimal(9, 6)), CAST(-4.499106 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (4, N'Palma de Mallorca', N'PMI', N'LEPA', N'Palma de Mallorca', 1, CAST(39.551694 AS Decimal(9, 6)), CAST(2.738806 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (5, N'Alicante-Elche', N'ALC', N'LEAL', N'Alicante', 1, CAST(38.282169 AS Decimal(9, 6)), CAST(-0.558156 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (6, N'Sevilla', N'SVQ', N'LEZL', N'Sevilla', 1, CAST(37.418000 AS Decimal(9, 6)), CAST(-5.893106 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (7, N'Valencia', N'VLC', N'LEVC', N'Valencia', 1, CAST(39.489314 AS Decimal(9, 6)), CAST(-0.481625 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (8, N'Bilbao', N'BIO', N'LEBB', N'Bilbao', 1, CAST(43.301094 AS Decimal(9, 6)), CAST(-2.910608 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (9, N'London Heathrow', N'LHR', N'EGLL', N'Londres', 2, CAST(51.470022 AS Decimal(9, 6)), CAST(-0.454296 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (10, N'Paris Charles de Gaulle', N'CDG', N'LFPG', N'París', 3, CAST(49.009724 AS Decimal(9, 6)), CAST(2.547778 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (11, N'Frankfurt', N'FRA', N'EDDF', N'Frankfurt', 4, CAST(50.026421 AS Decimal(9, 6)), CAST(8.543125 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (12, N'Munich', N'MUC', N'EDDM', N'Munich', 4, CAST(48.353783 AS Decimal(9, 6)), CAST(11.786086 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (13, N'Rome Fiumicino', N'FCO', N'LIRF', N'Roma', 5, CAST(41.800278 AS Decimal(9, 6)), CAST(12.238889 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (14, N'Milan Malpensa', N'MXP', N'LIMC', N'Milán', 5, CAST(45.630606 AS Decimal(9, 6)), CAST(8.728111 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (15, N'Lisbon Portela', N'LIS', N'LPPT', N'Lisboa', 6, CAST(38.781311 AS Decimal(9, 6)), CAST(-9.135919 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (16, N'John F. Kennedy', N'JFK', N'KJFK', N'Nueva York', 7, CAST(40.639722 AS Decimal(9, 6)), CAST(-73.778889 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (17, N'Miami International', N'MIA', N'KMIA', N'Miami', 7, CAST(25.795865 AS Decimal(9, 6)), CAST(-80.287046 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (18, N'Mexico City', N'MEX', N'MMMX', N'Ciudad de México', 8, CAST(19.436303 AS Decimal(9, 6)), CAST(-99.072097 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (19, N'Buenos Aires Ezeiza', N'EZE', N'SAEZ', N'Buenos Aires', 9, CAST(-34.822222 AS Decimal(9, 6)), CAST(-58.535833 AS Decimal(9, 6)))
GO
INSERT [dbo].[aeropuerto] ([id], [nombre], [codigo_iata], [codigo_icao], [ciudad], [pais_id], [latitud], [longitud]) VALUES (20, N'São Paulo Guarulhos', N'GRU', N'SBGR', N'São Paulo', 10, CAST(-23.432075 AS Decimal(9, 6)), CAST(-46.469511 AS Decimal(9, 6)))
GO
SET IDENTITY_INSERT [dbo].[aeropuerto] OFF
GO
SET IDENTITY_INSERT [dbo].[asignacion_tripulacion] ON
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (66, 1, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (102, 1, 30)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (42, 2, 2)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (27, 2, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (54, 2, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (78, 2, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (90, 2, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (28, 3, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (79, 3, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (103, 3, 30)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (55, 4, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (67, 4, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (91, 4, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (34, 5, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (29, 5, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (56, 5, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (68, 5, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (92, 5, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (35, 6, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (30, 6, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (57, 6, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (69, 6, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (93, 6, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (31, 7, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (58, 7, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (70, 7, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (104, 7, 30)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (32, 8, 13)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (59, 8, 25)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (71, 8, 27)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (94, 8, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (46, 11, 1)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (36, 13, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (37, 14, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (47, 16, 1)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (38, 16, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (45, 18, 1)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (43, 20, 2)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (44, 21, 2)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (39, 22, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (40, 23, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (41, 24, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (33, 25, 11)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (80, 41, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (95, 41, 29)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (81, 42, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (105, 42, 30)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (82, 43, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (106, 43, 30)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (83, 44, 28)
GO
INSERT [dbo].[asignacion_tripulacion] ([id], [tripulante_id], [vuelo_id]) VALUES (107, 44, 30)
GO
SET IDENTITY_INSERT [dbo].[asignacion_tripulacion] OFF
GO
SET IDENTITY_INSERT [dbo].[avion] ON
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (1, N'EC-ILQ', 2, 1, 1, 1, 45230, 28450)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (2, N'EC-ILS', 2, 1, 1, 4, 42181, 26891)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (3, N'EC-IZR', 2, 1, 3, 1, 39614, 24511)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (4, N'EC-JFN', 3, 1, 1, 10, 12452, 7822)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (5, N'EC-MXV', 3, 1, 2, 2, 14230, 8950)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (6, N'EC-NGR', 3, 1, 1, 3, 11681, 7341)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (7, N'EC-LVT', 4, 1, 3, 1, 52343, 31201)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (8, N'EC-JRE', 4, 1, 4, 1, 48920, 29450)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (9, N'EC-NIA', 5, 1, 1, 14, 8923, 5630)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (10, N'EC-NIB', 5, 1, 1, 1, 9450, 5980)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (11, N'EC-LUK', 6, 1, 1, 1, 68450, 15230)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (12, N'EC-LUX', 6, 1, 2, 1, 71230, 16450)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (13, N'EC-LZJ', 7, 1, 1, 1, 75680, 17890)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (14, N'EC-MHL', 7, 1, 1, 1, 72340, 16920)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (15, N'EC-MIG', 7, 1, 4, 1, 69870, 16120)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (16, N'EC-MYX', 8, 1, 1, 1, 18450, 4230)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (17, N'EC-NBE', 8, 1, 1, 1, 16780, 3890)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (18, N'EC-NDR', 8, 1, 1, 18, 15913, 3541)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (19, N'EC-NOM', 8, 1, 1, 19, 15388, 3420)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (20, N'EC-NSI', 8, 1, 1, 17, 13920, 3250)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (21, N'EC-JFH', 1, 1, 1, 2, 56780, 35420)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (22, N'EC-KHN', 1, 1, 1, 1, 62340, 38920)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (23, N'EC-KXD', 1, 1, 1, 1, 58920, 36780)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (24, N'EC-MSN', 9, 1, 1, 6, 12340, 18920)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (25, N'EC-MSZ', 9, 1, 1, 3, 11680, 17450)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (26, N'EC-MPA', 10, 1, 1, 4, 22340, 28920)
GO
INSERT [dbo].[avion] ([id], [matricula], [modelo_id], [aerolinea_id], [estado_id], [aeropuerto_actual_id], [horas_vuelo_totales], [ciclos_totales]) VALUES (27, N'EC-MQB', 10, 1, 1, 1, 24680, 31250)
GO
SET IDENTITY_INSERT [dbo].[avion] OFF
GO
SET IDENTITY_INSERT [dbo].[codigo_retraso_iata] ON
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (1, N'OA', N'No gate/stand availability due to own airline activity')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (2, N'SG', N'Scheduled ground time less than declared minimum ground time')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (3, N'PD', N'Late check-in after deadline')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (4, N'PL', N'Late check-in congestion')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (5, N'PE', N'Check-in error passenger/baggage')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (6, N'PO', N'Oversales booking errors')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (7, N'PH', N'Boarding discrepancies')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (8, N'PS', N'Passenger convenience/VIP')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (9, N'PC', N'Catering order issue')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (10, N'PB', N'Baggage processing')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (11, N'PW', N'Reduced mobility')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (12, N'CD', N'Cargo documentation errors')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (13, N'CP', N'Late cargo positioning')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (14, N'CC', N'Late cargo acceptance')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (15, N'CI', N'Inadequate packing')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (16, N'CO', N'Cargo oversales')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (17, N'CU', N'Late warehouse preparation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (18, N'CE', N'Mail documentation/packing')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (19, N'CL', N'Mail late positioning')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (20, N'CA', N'Mail late acceptance')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (21, N'GD', N'Aircraft documentation late')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (22, N'GL', N'Loading/unloading issues')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (23, N'GE', N'Loading equipment issue')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (24, N'GS', N'Servicing equipment issue')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (25, N'GC', N'Aircraft cleaning')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (26, N'GF', N'Fuelling/defuelling')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (27, N'GB', N'Catering delivery')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (28, N'GU', N'ULD issue')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (29, N'GT', N'Technical ground equipment')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (30, N'TD', N'Aircraft defects')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (31, N'TM', N'Scheduled maintenance late release')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (32, N'TN', N'Non scheduled maintenance')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (33, N'TS', N'Spares/maintenance equipment')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (34, N'TA', N'AOG spares transport')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (35, N'TC', N'Aircraft change technical')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (36, N'TL', N'Standby aircraft unavailable')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (37, N'TV', N'Cabin configuration adjustment')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (38, N'DF', N'Damage during flight operations')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (39, N'DG', N'Damage during ground operations')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (40, N'ED', N'Departure control')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (41, N'EC', N'Cargo preparation/documentation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (42, N'EF', N'Flight plans')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (43, N'EO', N'Other automated system')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (44, N'FP', N'Flight plan documentation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (45, N'FF', N'Operational requirements')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (46, N'FT', N'Late crew boarding procedures')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (47, N'FS', N'Flight deck crew shortage')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (48, N'FR', N'Flight deck crew special request')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (49, N'FL', N'Late cabin crew boarding')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (50, N'FC', N'Cabin crew shortage')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (51, N'FA', N'Cabin crew error')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (52, N'FB', N'Captain security request')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (53, N'WO', N'Weather departure')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (54, N'WT', N'Weather destination')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (55, N'WR', N'Weather en route')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (56, N'WI', N'De-icing aircraft')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (57, N'WS', N'Snow/ice removal airport')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (58, N'WG', N'Ground handling weather')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (59, N'AT', N'ATFM ATC demand/capacity')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (60, N'AX', N'ATFM staff/equipment')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (61, N'AE', N'ATFM destination restriction')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (62, N'AW', N'ATFM weather destination')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (63, N'AS', N'Mandatory security')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (64, N'AG', N'Immigration/customs/health')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (65, N'AF', N'Airport facilities')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (66, N'AD', N'Destination airport restriction')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (67, N'AM', N'Departure airport restriction')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (68, N'RL', N'Load connection')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (69, N'RT', N'Through check-in error')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (70, N'RA', N'Aircraft rotation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (71, N'RS', N'Cabin crew rotation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (72, N'RC', N'Crew rotation')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (73, N'RO', N'Operations control')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (74, N'MI', N'Industrial action own airline')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (75, N'MO', N'Industrial action external')
GO
INSERT [dbo].[codigo_retraso_iata] ([id], [codigo], [descripcion]) VALUES (76, N'MX', N'Other reason')
GO
SET IDENTITY_INSERT [dbo].[codigo_retraso_iata] OFF
GO
SET IDENTITY_INSERT [dbo].[estado_avion] ON
GO
INSERT [dbo].[estado_avion] ([id], [nombre]) VALUES (2, N'En Mantenimiento')
GO
INSERT [dbo].[estado_avion] ([id], [nombre]) VALUES (3, N'En Vuelo')
GO
INSERT [dbo].[estado_avion] ([id], [nombre]) VALUES (4, N'Fuera de Servicio')
GO
INSERT [dbo].[estado_avion] ([id], [nombre]) VALUES (1, N'Operativo')
GO
SET IDENTITY_INSERT [dbo].[estado_avion] OFF
GO
SET IDENTITY_INSERT [dbo].[estado_vuelo] ON
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (4, N'Aterrizado')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (5, N'Cancelado')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (7, N'Completado')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (2, N'Embarcando')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (3, N'En Vuelo')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (1, N'Programado')
GO
INSERT [dbo].[estado_vuelo] ([id], [nombre]) VALUES (6, N'Retrasado')
GO
SET IDENTITY_INSERT [dbo].[estado_vuelo] OFF
GO
SET IDENTITY_INSERT [dbo].[mantenimiento] ON
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (1, 12, 2, N'Completado', CAST(N'2026-02-10' AS Date), CAST(N'2026-02-10T08:00:00.000' AS DateTime), CAST(N'2026-02-14T18:00:00.000' AS DateTime), N'C-Check - Inspección estructural completa')
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (2, 27, 1, N'Completado', CAST(N'2026-02-14' AS Date), CAST(N'2026-02-14T06:00:00.000' AS DateTime), CAST(N'2026-03-16T11:02:25.950' AS DateTime), N'A-Check en curso - Revisión de sistemas')
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (3, 1, 4, N'Completado', CAST(N'2026-02-14' AS Date), CAST(N'2026-02-14T23:00:00.000' AS DateTime), CAST(N'2026-02-15T01:30:00.000' AS DateTime), N'Inspección diaria completada')
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (4, 6, 4, N'Completado', CAST(N'2026-02-14' AS Date), CAST(N'2026-02-14T22:30:00.000' AS DateTime), CAST(N'2026-02-15T00:45:00.000' AS DateTime), N'Inspección diaria - Sin anomalías')
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (5, 11, 8, N'Completado', CAST(N'2026-02-12' AS Date), CAST(N'2026-02-12T14:00:00.000' AS DateTime), CAST(N'2026-02-12T22:00:00.000' AS DateTime), N'Inspección de emergencia - Reemplazo sensor hidráulico')
GO
INSERT [dbo].[mantenimiento] ([id], [avion_id], [mantenimiento_tipo_id], [estado], [fecha_programada], [fecha_inicio], [fecha_fin], [descripcion]) VALUES (6, 5, 4, N'En Curso', CAST(N'2026-03-16' AS Date), CAST(N'2026-03-16T12:59:07.213' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[mantenimiento] OFF
GO
SET IDENTITY_INSERT [dbo].[mantenimiento_tipo] ON
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (1, N'Inspección A-Check', 750, 0, 90)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (2, N'Inspección C-Check', 7500, 0, 18)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (3, N'Inspección D-Check', 30000, 0, 72)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (4, N'Inspección Diaria', 24, 0, 1)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (5, N'Inspección Semanal', 168, 0, 7)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (6, N'Revisión de Motores', 5000, 0, 0)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (7, N'Revisión de Tren de Aterrizaje', 0, 15000, 0)
GO
INSERT [dbo].[mantenimiento_tipo] ([id], [nombre], [intervalo_horas], [intervalo_ciclos], [intervalo_dias]) VALUES (8, N'Inspección de Emergencia', 0, 0, 0)
GO
SET IDENTITY_INSERT [dbo].[mantenimiento_tipo] OFF
GO
SET IDENTITY_INSERT [dbo].[modelo_avion] ON
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (1, N'Airbus', N'A319-100', 138, 6850)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (2, N'Airbus', N'A320-200', 180, 6100)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (3, N'Airbus', N'A320neo', 180, 6300)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (4, N'Airbus', N'A321-200', 200, 5950)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (5, N'Airbus', N'A321neo', 220, 7400)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (6, N'Airbus', N'A330-200', 288, 13450)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (7, N'Airbus', N'A330-300', 348, 11750)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (8, N'Airbus', N'A350-900', 348, 15000)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (9, N'ATR', N'ATR 72-600', 68, 1528)
GO
INSERT [dbo].[modelo_avion] ([id], [fabricante], [nombre_modelo], [capacidad_total], [alcance_km]) VALUES (10, N'Bombardier', N'CRJ-1000', 100, 2761)
GO
SET IDENTITY_INSERT [dbo].[modelo_avion] OFF
GO
SET IDENTITY_INSERT [dbo].[pais] ON
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (1, N'España', N'ESP')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (2, N'Reino Unido', N'GBR')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (3, N'Francia', N'FRA')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (4, N'Alemania', N'DEU')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (5, N'Italia', N'ITA')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (6, N'Portugal', N'PRT')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (7, N'Estados Unidos', N'USA')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (8, N'México', N'MEX')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (9, N'Argentina', N'ARG')
GO
INSERT [dbo].[pais] ([id], [nombre], [codigo_iso]) VALUES (10, N'Brasil', N'BRA')
GO
SET IDENTITY_INSERT [dbo].[pais] OFF
GO
SET IDENTITY_INSERT [dbo].[registro_estado_avion] ON
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (1, 3, 1, CAST(40.471926 AS Decimal(9, 6)), CAST(-3.568381 AS Decimal(9, 6)), CAST(N'2026-03-16T09:31:11.810' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (2, 19, 19, CAST(-34.822222 AS Decimal(9, 6)), CAST(-58.535833 AS Decimal(9, 6)), CAST(N'2026-03-16T09:31:11.810' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (3, 18, 18, CAST(19.436303 AS Decimal(9, 6)), CAST(-99.072097 AS Decimal(9, 6)), CAST(N'2026-03-16T10:44:22.943' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (4, 9, 14, CAST(45.630606 AS Decimal(9, 6)), CAST(8.728111 AS Decimal(9, 6)), CAST(N'2026-03-16T12:10:01.153' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (5, 4, 5, CAST(38.282169 AS Decimal(9, 6)), CAST(-0.558156 AS Decimal(9, 6)), CAST(N'2026-03-16T12:29:35.563' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (6, 7, 9, CAST(51.470022 AS Decimal(9, 6)), CAST(-0.454296 AS Decimal(9, 6)), CAST(N'2026-03-16T12:30:02.790' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (7, 4, 10, CAST(49.009724 AS Decimal(9, 6)), CAST(2.547778 AS Decimal(9, 6)), CAST(N'2026-03-16T12:49:22.050' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (8, 6, 3, CAST(36.674919 AS Decimal(9, 6)), CAST(-4.499106 AS Decimal(9, 6)), CAST(N'2026-03-16T13:18:03.000' AS DateTime))
GO
INSERT [dbo].[registro_estado_avion] ([id], [avion_id], [aeropuerto_id], [latitud], [longitud], [fecha_hora]) VALUES (9, 2, 4, CAST(39.551694 AS Decimal(9, 6)), CAST(2.738806 AS Decimal(9, 6)), CAST(N'2026-03-16T13:29:01.947' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[registro_estado_avion] OFF
GO
SET IDENTITY_INSERT [dbo].[retraso_vuelo] ON
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (1, 10, 59, 35)
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (2, 14, 53, 45)
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (3, 7, 30, 25)
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (4, 12, 26, 15)
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (5, 24, 12, 60)
GO
INSERT [dbo].[retraso_vuelo] ([id], [vuelo_id], [codigo_retraso_id], [minutos]) VALUES (6, 31, 1, 44)
GO
SET IDENTITY_INSERT [dbo].[retraso_vuelo] OFF
GO
SET IDENTITY_INSERT [dbo].[rol] ON
GO
INSERT [dbo].[rol] ([id], [nombre]) VALUES (1, N'Administrador')
GO
INSERT [dbo].[rol] ([id], [nombre]) VALUES (2, N'Gestor')
GO
INSERT [dbo].[rol] ([id], [nombre]) VALUES (3, N'Mecanico')
GO
SET IDENTITY_INSERT [dbo].[rol] OFF
GO
SET IDENTITY_INSERT [dbo].[ruta] ON
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (1, 1, 2, 505)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (2, 1, 3, 417)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (3, 1, 4, 560)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (4, 1, 5, 354)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (5, 1, 6, 391)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (6, 1, 7, 303)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (7, 1, 8, 322)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (8, 1, 9, 1265)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (9, 1, 10, 1055)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (10, 1, 11, 1435)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (11, 1, 12, 1520)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (12, 1, 13, 1365)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (13, 1, 14, 1245)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (14, 1, 15, 502)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (15, 1, 16, 5770)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (16, 1, 17, 7120)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (17, 1, 18, 9200)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (18, 1, 19, 10075)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (19, 1, 20, 8388)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (20, 2, 9, 1140)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (21, 2, 10, 830)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (22, 2, 13, 856)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (23, 2, 15, 1005)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (24, 2, 1, 505)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (25, 9, 1, 1265)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (26, 10, 1, 1055)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (27, 16, 1, 5770)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (28, 15, 1, 502)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (29, 15, 2, 1005)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (30, 10, 2, 830)
GO
INSERT [dbo].[ruta] ([id], [aeropuerto_origen_id], [aeropuerto_destino_id], [distancia_km]) VALUES (31, 9, 2, 1140)
GO
SET IDENTITY_INSERT [dbo].[ruta] OFF
GO
SET IDENTITY_INSERT [dbo].[ruta_aerolinea] ON
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (1, 1, 1, 1, CAST(89.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (2, 2, 1, 1, CAST(79.99 AS Decimal(10, 2)), 10, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (3, 3, 1, 1, CAST(84.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (4, 4, 1, 1, CAST(74.99 AS Decimal(10, 2)), 10, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (5, 5, 1, 1, CAST(79.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (6, 6, 1, 1, CAST(74.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (7, 7, 1, 1, CAST(79.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (8, 8, 1, 1, CAST(149.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (9, 9, 1, 1, CAST(129.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (10, 10, 1, 1, CAST(159.99 AS Decimal(10, 2)), 10, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (11, 11, 1, 1, CAST(164.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (12, 12, 1, 1, CAST(139.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (13, 13, 1, 1, CAST(134.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (14, 14, 1, 1, CAST(109.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (15, 15, 1, 1, CAST(549.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (16, 16, 1, 1, CAST(649.99 AS Decimal(10, 2)), 5, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (17, 17, 1, 0, CAST(749.99 AS Decimal(10, 2)), 5, CAST(N'2024-01-01' AS Date), CAST(N'2026-03-16' AS Date), NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (18, 18, 1, 1, CAST(849.99 AS Decimal(10, 2)), 3, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (19, 19, 1, 1, CAST(799.99 AS Decimal(10, 2)), 4, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (20, 25, 1, 1, CAST(149.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (21, 26, 1, 1, CAST(129.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (22, 27, 1, 1, CAST(549.99 AS Decimal(10, 2)), 7, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (23, 28, 1, 1, CAST(109.99 AS Decimal(10, 2)), 14, CAST(N'2024-01-01' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (25, 23, 1, 1, CAST(45.00 AS Decimal(10, 2)), 5, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (26, 29, 1, 1, CAST(45.00 AS Decimal(10, 2)), 5, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (27, 21, 1, 1, CAST(44.00 AS Decimal(10, 2)), 3, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (28, 30, 1, 1, CAST(44.00 AS Decimal(10, 2)), 3, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (29, 20, 1, 1, CAST(55.00 AS Decimal(10, 2)), 6, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
INSERT [dbo].[ruta_aerolinea] ([id], [ruta_id], [aerolinea_id], [activa], [precio_base], [frecuencia_semanal], [fecha_inicio], [fecha_fin], [observaciones]) VALUES (30, 31, 1, 1, CAST(55.00 AS Decimal(10, 2)), 6, CAST(N'2026-03-16' AS Date), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ruta_aerolinea] OFF
GO
SET IDENTITY_INSERT [dbo].[tripulante] ON
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (1, 1, N'Carlos', N'Martínez', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (2, 1, N'Ana', N'García', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (3, 1, N'Pablo', N'Moreno', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (4, 1, N'Elena', N'Álvarez', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (5, 1, N'Marta', N'Gil', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (6, 1, N'Jorge', N'Castro', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (7, 1, N'Sandra', N'Ortiz', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (8, 1, N'Daniel', N'Rubio', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (9, 2, N'Michael', N'O''Connor', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (10, 2, N'Sarah', N'Kelly', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (11, 2, N'John', N'Murphy', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (12, 2, N'Emma', N'Walsh', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (13, 2, N'Liam', N'O''Brien', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (14, 2, N'Chloe', N'Byrne', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (15, 2, N'Conor', N'Ryan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (16, 2, N'Aoife', N'Doyle', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (17, 3, N'Marc', N'Vidal', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (18, 3, N'Laia', N'Ferrer', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (19, 3, N'Pol', N'Serra', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (20, 3, N'Nuria', N'Pujol', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (21, 3, N'Jordi', N'Vila', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (22, 3, N'Mireia', N'Soler', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (23, 3, N'Albert', N'Martí', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (24, 3, N'Carla', N'Rovira', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (25, 4, N'Javier', N'Pérez', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (26, 4, N'Carmen', N'Ruiz', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (27, 4, N'Sergio', N'Romero', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (28, 4, N'Lucía', N'Navarro', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (29, 4, N'Roberto', N'Delgado', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (30, 4, N'Silvia', N'Herrera', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (31, 4, N'Fernando', N'Medina', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (32, 4, N'Cristina', N'Iglesias', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (33, 5, N'Klaus', N'Müller', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (34, 5, N'Hannah', N'Schmidt', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (35, 5, N'Lukas', N'Weber', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (36, 5, N'Julia', N'Wagner', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (37, 5, N'Felix', N'Becker', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (38, 5, N'Anna', N'Hoffmann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (39, 5, N'Maximilian', N'Koch', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (40, 5, N'Sophie', N'Richter', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (41, 1, N'hththt', N'thth', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (42, 1, N'rgrg', N'rgrg', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (43, 1, N'rgrgrh', N'rhrhrh', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (44, 1, N'rhrhrhj', N'rhrhrh', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (45, 5, N'Alexander', N'Braun', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (46, 5, N'Brigitte', N'Zimmermann', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (47, 5, N'Christoph', N'Hartmann', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (48, 5, N'Dorothea', N'Krause', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (49, 5, N'Eberhard', N'Fuchs', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (50, 5, N'Franziska', N'Wolf', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (51, 5, N'Gottfried', N'Schäfer', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (52, 5, N'Hannelore', N'Bauer', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (53, 5, N'Ingmar', N'Schreiber', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (54, 5, N'Johanna', N'Neumann', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (55, 5, N'Karl', N'Lange', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (56, 5, N'Lieselotte', N'Schulz', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (57, 5, N'Manfred', N'Werner', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (58, 5, N'Nadja', N'Krüger', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (59, 5, N'Otto', N'Lehmann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (60, 5, N'Petra', N'Köhler', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (61, 5, N'Reinhard', N'Maier', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (62, 5, N'Sabine', N'Herrmann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (63, 5, N'Theodor', N'Schmitt', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (64, 5, N'Ursula', N'König', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (65, 5, N'Volkmar', N'Huber', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (66, 5, N'Waltraud', N'Meyer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (67, 5, N'Xaver', N'Fischer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (68, 5, N'Yvonne', N'Brandt', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (69, 5, N'Zdenko', N'Roth', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (70, 5, N'Andreas', N'Schwarz', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (71, 5, N'Beate', N'Weiß', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (72, 5, N'Conrad', N'Albrecht', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (73, 5, N'Dagmar', N'Böhm', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (74, 5, N'Edmund', N'Dietrich', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (75, 5, N'Elfriede', N'Engel', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (76, 5, N'Friedrich', N'Franke', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (77, 5, N'Gertrude', N'Günther', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (78, 5, N'Heinrich', N'Horn', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (79, 5, N'Irmgard', N'Jung', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (80, 5, N'Josef', N'Kaiser', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (81, 5, N'Klara', N'Klein', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (82, 5, N'Ludwig', N'Lorenz', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (83, 5, N'Mechthild', N'Mayer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (84, 5, N'Norbert', N'Naumann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (85, 5, N'Oskar', N'Pfeiffer', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (86, 5, N'Rosemarie', N'Riedel', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (87, 5, N'Stefan', N'Steinbach', N'Tripulante de Cabina', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (88, 1, N'Alejandro', N'Fernández', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (89, 1, N'Beatriz', N'Morales', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (90, 1, N'César', N'Vázquez', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (91, 1, N'Diana', N'Serrano', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (92, 1, N'Eduardo', N'Llorente', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (93, 1, N'Fátima', N'Ibáñez', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (94, 1, N'Gonzalo', N'Pedraza', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (95, 1, N'Helena', N'Montero', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (96, 1, N'Ignacio', N'Blanco', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (97, 1, N'Julia', N'Crespo', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (98, 1, N'Kevin', N'Marín', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (99, 1, N'Laura', N'Aguilar', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (100, 1, N'Miguel', N'Fuentes', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (101, 1, N'Natalia', N'Guerrero', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (102, 1, N'Óscar', N'Jiménez', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (103, 1, N'Patricia', N'Soto', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (104, 1, N'Raúl', N'Ramos', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (105, 1, N'Sofía', N'Paredes', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (106, 1, N'Tomás', N'Domínguez', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (107, 1, N'Úrsula', N'Cabrera', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (108, 1, N'Víctor', N'Gallardo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (109, 1, N'Wendy', N'Reyes', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (110, 1, N'Xavier', N'Nieto', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (111, 1, N'Yolanda', N'Prieto', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (112, 1, N'Zacarías', N'Carrasco', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (113, 1, N'Adriana', N'Molina', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (114, 1, N'Bruno', N'Vargas', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (115, 1, N'Claudia', N'Peña', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (116, 1, N'Diego', N'Santos', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (117, 1, N'Elena', N'Flores', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (118, 1, N'Francisco', N'León', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (119, 1, N'Gloria', N'Cortés', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (120, 1, N'Hugo', N'Méndez', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (121, 1, N'Irene', N'Torres', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (122, 1, N'Javier', N'Vidal', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (123, 1, N'Lorena', N'Herrero', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (124, 1, N'Manuel', N'Pascual', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (125, 1, N'Nerea', N'Calvo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (126, 1, N'Pablo', N'Bermejo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (127, 1, N'Rosa', N'Alonso', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (128, 1, N'Alberto', N'Durán', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (129, 1, N'Carmen', N'Iglesias', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (130, 1, N'Sergio', N'Prado', N'Tripulante de Cabina', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (131, 2, N'Patrick', N'O''Sullivan', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (132, 2, N'Fiona', N'McCarthy', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (133, 2, N'Brendan', N'Fitzpatrick', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (134, 2, N'Siobhan', N'Gallagher', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (135, 2, N'Declan', N'Brennan', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (136, 2, N'Niamh', N'O''Neill', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (137, 2, N'Ciarán', N'Murray', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (138, 2, N'Aisling', N'Dunne', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (139, 2, N'Seamus', N'Quinn', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (140, 2, N'Roisin', N'Flynn', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (141, 2, N'Eoin', N'Doherty', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (142, 2, N'Caoimhe', N'Burke', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (143, 2, N'Fergus', N'Nolan', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (144, 2, N'Grainne', N'Farrell', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (145, 2, N'Tadhg', N'Sheridan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (146, 2, N'Orla', N'Connolly', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (147, 2, N'Killian', N'Malone', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (148, 2, N'Sinead', N'Higgins', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (149, 2, N'Donal', N'Kearney', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (150, 2, N'Mairead', N'Whelan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (151, 2, N'Colm', N'Brady', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (152, 2, N'Sorcha', N'Regan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (153, 2, N'Ruairi', N'Boyle', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (154, 2, N'Clodagh', N'Power', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (155, 2, N'Darragh', N'Foley', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (156, 2, N'Eimear', N'Casey', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (157, 2, N'Fiachra', N'Donoghue', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (158, 2, N'Aoibheann', N'Sheehan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (159, 2, N'Lorcan', N'Tobin', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (160, 2, N'Nuala', N'Lawlor', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (161, 2, N'Peadar', N'Cullen', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (162, 2, N'Treasa', N'Delaney', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (163, 2, N'Ultan', N'Hanlon', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (164, 2, N'Viona', N'Keegan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (165, 2, N'William', N'Harrington', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (166, 2, N'Yseult', N'Finnegan', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (167, 2, N'Zara', N'Cronin', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (168, 2, N'Blathnaid', N'Kinsella', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (169, 2, N'Cathal', N'Stapleton', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (170, 2, N'Dearbhla', N'Gorman', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (171, 2, N'Eugene', N'O''Dwyer', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (172, 2, N'Fionnuala', N'Smyth', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (173, 2, N'Gerard', N'Lyons', N'Tripulante de Cabina', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (174, 3, N'Arnau', N'Puig', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (175, 3, N'Berta', N'Mas', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (176, 3, N'Carles', N'Bosch', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (177, 3, N'Dolors', N'Camps', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (178, 3, N'Enric', N'Roca', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (179, 3, N'Ester', N'Figueras', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (180, 3, N'Ferran', N'Ribas', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (181, 3, N'Gemma', N'Torrens', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (182, 3, N'Guillem', N'Pascual', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (183, 3, N'Helena', N'Garriga', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (184, 3, N'Ivan', N'Coll', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (185, 3, N'Jana', N'Obiols', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (186, 3, N'Lluc', N'Esteve', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (187, 3, N'Montserrat', N'Sala', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (188, 3, N'Narcís', N'Gómez', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (189, 3, N'Olga', N'Font', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (190, 3, N'Pere', N'Nadal', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (191, 3, N'Queralt', N'Llopis', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (192, 3, N'Ramon', N'Balcells', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (193, 3, N'Sílvia', N'Domènech', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (194, 3, N'Toni', N'Planes', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (195, 3, N'Úrsula', N'Ballester', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (196, 3, N'Víctor', N'Bassols', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (197, 3, N'Wanda', N'Anglès', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (198, 3, N'Xavier', N'Casellas', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (199, 3, N'Yolanda', N'Espinosa', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (200, 3, N'Zoe', N'Farrés', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (201, 3, N'Aleix', N'Carbonell', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (202, 3, N'Blanca', N'Claret', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (203, 3, N'Cristian', N'Duran', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (204, 3, N'Dídac', N'Espelt', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (205, 3, N'Elisenda', N'Farré', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (206, 3, N'Francesc', N'Guimerà', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (207, 3, N'Glòria', N'Huguet', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (208, 3, N'Hèctor', N'Iranzo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (209, 3, N'Ingrid', N'Julià', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (210, 3, N'Joel', N'Lladó', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (211, 3, N'Kàtia', N'Miracle', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (212, 3, N'Laia', N'Nogués', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (213, 3, N'Martí', N'Oriol', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (214, 3, N'Núria', N'Planas', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (215, 3, N'Oriol', N'Quintana', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (216, 3, N'Pau', N'Rovira', N'Tripulante de Cabina', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (217, 4, N'Andrés', N'Castellano', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (218, 4, N'Belén', N'Escudero', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (219, 4, N'Carlos', N'Fuentes', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (220, 4, N'Daniela', N'Gutiérrez', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (221, 4, N'Emilio', N'Hurtado', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (222, 4, N'Fernanda', N'Izquierdo', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (223, 4, N'Gerardo', N'Juárez', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (224, 4, N'Hortensia', N'Lara', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (225, 4, N'Ignacio', N'Maldonado', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (226, 4, N'Josefina', N'Navarrete', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (227, 4, N'Kristian', N'Olmedo', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (228, 4, N'Leticia', N'Palomino', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (229, 4, N'Marcos', N'Quintero', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (230, 4, N'Noemí', N'Recio', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (231, 4, N'Omar', N'Salinas', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (232, 4, N'Pilar', N'Trujillo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (233, 4, N'Quintín', N'Urrutia', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (234, 4, N'Rebeca', N'Valenzuela', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (235, 4, N'Salvador', N'Zambrano', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (236, 4, N'Teresa', N'Abad', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (237, 4, N'Ulises', N'Bernal', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (238, 4, N'Valentina', N'Cano', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (239, 4, N'Wilfredo', N'Dávalos', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (240, 4, N'Ximena', N'Espinoza', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (241, 4, N'Yesenia', N'Fonseca', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (242, 4, N'Zoila', N'Gamboa', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (243, 4, N'Adolfo', N'Hidalgo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (244, 4, N'Blanca', N'Infante', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (245, 4, N'Camilo', N'Jaramillo', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (246, 4, N'Dulce', N'Landero', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (247, 4, N'Ernesto', N'Montoya', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (248, 4, N'Flor', N'Nieves', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (249, 4, N'Geraldine', N'Osorio', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (250, 4, N'Hernán', N'Pereira', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (251, 4, N'Imelda', N'Quiroga', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (252, 4, N'Jorge', N'Rosales', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (253, 4, N'Karen', N'Sandoval', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (254, 4, N'Lourdes', N'Taboada', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (255, 4, N'Mauricio', N'Uribe', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (256, 4, N'Nancy', N'Villanueva', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (257, 4, N'Octavio', N'Wiseman', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (258, 4, N'Paloma', N'Ximénez', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (259, 4, N'Rodrigo', N'Yáñez', N'Tripulante de Cabina', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (260, 5, N'Alexander', N'Braun', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (261, 5, N'Brigitte', N'Zimmermann', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (262, 5, N'Christoph', N'Hartmann', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (263, 5, N'Dorothea', N'Krause', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (264, 5, N'Eberhard', N'Fuchs', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (265, 5, N'Franziska', N'Wolf', N'Comandante', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (266, 5, N'Gottfried', N'Schäfer', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (267, 5, N'Hannelore', N'Bauer', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (268, 5, N'Ingmar', N'Schreiber', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (269, 5, N'Johanna', N'Neumann', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (270, 5, N'Karl', N'Lange', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (271, 5, N'Lieselotte', N'Schulz', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (272, 5, N'Manfred', N'Werner', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (273, 5, N'Nadja', N'Krüger', N'Primer Oficial', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (274, 5, N'Otto', N'Lehmann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (275, 5, N'Petra', N'Köhler', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (276, 5, N'Reinhard', N'Maier', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (277, 5, N'Sabine', N'Herrmann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (278, 5, N'Theodor', N'Schmitt', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (279, 5, N'Ursula', N'König', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (280, 5, N'Volkmar', N'Huber', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (281, 5, N'Waltraud', N'Meyer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (282, 5, N'Xaver', N'Fischer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (283, 5, N'Yvonne', N'Brandt', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (284, 5, N'Zdenko', N'Roth', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (285, 5, N'Andreas', N'Schwarz', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (286, 5, N'Beate', N'Weiß', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (287, 5, N'Conrad', N'Albrecht', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (288, 5, N'Dagmar', N'Böhm', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (289, 5, N'Edmund', N'Dietrich', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (290, 5, N'Elfriede', N'Engel', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (291, 5, N'Friedrich', N'Franke', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (292, 5, N'Gertrude', N'Günther', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (293, 5, N'Heinrich', N'Horn', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (294, 5, N'Irmgard', N'Jung', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (295, 5, N'Josef', N'Kaiser', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (296, 5, N'Klara', N'Klein', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (297, 5, N'Ludwig', N'Lorenz', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (298, 5, N'Mechthild', N'Mayer', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (299, 5, N'Norbert', N'Naumann', N'Tripulante de Cabina', 1)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (300, 5, N'Oskar', N'Pfeiffer', N'Comandante', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (301, 5, N'Rosemarie', N'Riedel', N'Primer Oficial', 0)
GO
INSERT [dbo].[tripulante] ([id], [id_aerolinea], [nombre], [apellido], [rol], [activo]) VALUES (302, 5, N'Stefan', N'Steinbach', N'Tripulante de Cabina', 0)
GO
SET IDENTITY_INSERT [dbo].[tripulante] OFF
GO
INSERT [dbo].[users_security] ([id_usuario], [salt], [pass]) VALUES (1, N'Â|êak5=«à?ÚÞÐM??Su?PLÏÌ?ñ§ë!¶[­øT¼?ÊE?Þñ¢', 0x30783931353946464643464536363334303331413534394344464430414630433238353531394632464630443739334231414638373130433834444642343636304242334643424144334134454538463331324539424237433744304332423630373939313331363643303741454443354636453639313039413836324446393437)
GO
INSERT [dbo].[users_security] ([id_usuario], [salt], [pass]) VALUES (2, N'c^%!XBÑ)t¸aTæßb%¾s@J½ÐÒ<çËîì6G?¤x', 0xB9C129DB4907D3F0D0212B6EA7B5FAF7CAB8A53CC952C574D2C7A9ED6F8052E2F9AD15876FAF906B8BA9844B0F728CA6CE9B41817F69267657DEE4725A06848D)
GO
INSERT [dbo].[users_security] ([id_usuario], [salt], [pass]) VALUES (3, N'9NWXVXU8LXp2RNsjvAgek+q0CjPyUJxOrzdh3SOlDFI=', 0x59581D755BC1B3BE6B98545D74EF7203C4C530F40CB1F113B26B455AE4BEAE80554E20108CD2977FA93E2415952F0878B3332841294A1599E88BCBA97E7DD739)
GO
INSERT [dbo].[users_security] ([id_usuario], [salt], [pass]) VALUES (4, N'SG8lCFFxcLGjTOWLhtdM6KvjRPApkrLFjXWiXugAKcI=', 0x9F5DC781FDD99E68727D5DF092531A70B4D1C03AE150CB72D8D6101EE0AA5C27254873D3A68808E812A4A79A94BC9CA21834398938CC287EE22E8214F3EA5800)
GO
INSERT [dbo].[users_security] ([id_usuario], [salt], [pass]) VALUES (5, N'RD1cXsHC+GjKOPzeiQEv9OoTl7Lat+OzpkJVWX3uVlw=', 0xB26F446B1C5A0B425BA06532BB4F695EF487074731D930FF2D4BF6745A7A413ED6EFC2E5B57CF6FA62655A1AD0792E339E9464C5B9683E50542B9BD3501B428C)
GO
SET IDENTITY_INSERT [dbo].[usuario] ON
GO
INSERT [dbo].[usuario] ([id], [nombre], [apellidos], [email], [password], [aerolinea_id], [activo]) VALUES (1, N'Adrian', N'Jacek', N'admin@gmail.com', N'12345', 1, 1)
GO
INSERT [dbo].[usuario] ([id], [nombre], [apellidos], [email], [password], [aerolinea_id], [activo]) VALUES (2, N'rrgggrg', N'grgrg', N'efef@gmail.com', N'12345', 1, 1)
GO
INSERT [dbo].[usuario] ([id], [nombre], [apellidos], [email], [password], [aerolinea_id], [activo]) VALUES (3, N'ffff', N'ffff', N'admin2@gmail.com', N'12345', 1, 1)
GO
INSERT [dbo].[usuario] ([id], [nombre], [apellidos], [email], [password], [aerolinea_id], [activo]) VALUES (4, N'pruebaaa', N'ththth', N'admin44@gmail.com', N'12345', 1, 1)
GO
INSERT [dbo].[usuario] ([id], [nombre], [apellidos], [email], [password], [aerolinea_id], [activo]) VALUES (5, N'fbfbfb', N'bfbfbfb', N'admin67@gmail.com', N'12345', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[usuario] OFF
GO
INSERT [dbo].[usuario_rol] ([usuario_id], [rol_id]) VALUES (1, 1)
GO
INSERT [dbo].[usuario_rol] ([usuario_id], [rol_id]) VALUES (2, 1)
GO
INSERT [dbo].[usuario_rol] ([usuario_id], [rol_id]) VALUES (3, 1)
GO
INSERT [dbo].[usuario_rol] ([usuario_id], [rol_id]) VALUES (4, 1)
GO
INSERT [dbo].[usuario_rol] ([usuario_id], [rol_id]) VALUES (5, 2)
GO
SET IDENTITY_INSERT [dbo].[vuelo] ON
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (1, N'IB6251', 1, 1, 1, CAST(N'2026-02-15T07:00:00.000' AS DateTime), CAST(N'2026-02-15T08:25:00.000' AS DateTime), 5, N'', 180, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (2, N'IB6252', 1, 24, 2, CAST(N'2026-02-15T09:30:00.000' AS DateTime), CAST(N'2026-02-15T10:55:00.000' AS DateTime), 5, N'', 180, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (3, N'IB2610', 1, 2, 21, CAST(N'2026-02-15T08:15:00.000' AS DateTime), CAST(N'2026-02-15T09:20:00.000' AS DateTime), 5, N'', 138, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (4, N'IB2611', 1, 2, 22, CAST(N'2026-02-15T14:30:00.000' AS DateTime), CAST(N'2026-02-15T15:35:00.000' AS DateTime), 5, N'', 138, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (5, N'IB3902', 1, 3, 4, CAST(N'2026-02-15T10:45:00.000' AS DateTime), CAST(N'2026-02-15T12:30:00.000' AS DateTime), 5, N'', 180, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (6, N'IB8750', 1, 4, 5, CAST(N'2026-02-15T11:30:00.000' AS DateTime), CAST(N'2026-02-15T12:45:00.000' AS DateTime), 5, N'', 180, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (7, N'IB3162', 1, 8, 7, CAST(N'2026-02-15T06:30:00.000' AS DateTime), CAST(N'2026-02-15T09:15:00.000' AS DateTime), 5, N'', 200, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (8, N'IB3163', 1, 25, 8, CAST(N'2026-02-15T11:45:00.000' AS DateTime), CAST(N'2026-02-15T14:30:00.000' AS DateTime), 5, N'', 200, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (9, N'IB3100', 1, 9, 23, CAST(N'2026-02-15T07:45:00.000' AS DateTime), CAST(N'2026-02-15T09:45:00.000' AS DateTime), 5, N'', 138, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (10, N'IB3101', 1, 26, 3, CAST(N'2026-02-15T12:30:00.000' AS DateTime), CAST(N'2026-02-15T14:30:00.000' AS DateTime), 7, N'', 180, 178, 178, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (11, N'IB6251', 1, 15, 16, CAST(N'2026-02-15T11:30:00.000' AS DateTime), CAST(N'2026-02-15T14:45:00.000' AS DateTime), 5, N'', 348, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (12, N'IB6261', 1, 16, 17, CAST(N'2026-02-15T13:15:00.000' AS DateTime), CAST(N'2026-02-15T19:30:00.000' AS DateTime), 5, N'', 348, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (13, N'IB6403', 1, 17, 18, CAST(N'2026-02-15T23:45:00.000' AS DateTime), CAST(N'2026-02-16T09:20:00.000' AS DateTime), 7, N'23', 348, 23, 2, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (14, N'IB6845', 1, 18, 19, CAST(N'2026-02-14T22:30:00.000' AS DateTime), CAST(N'2026-02-15T14:35:00.000' AS DateTime), 7, N'', 348, 341, 341, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (15, N'IB6701', 1, 19, 20, CAST(N'2026-02-15T18:30:00.000' AS DateTime), CAST(N'2026-02-16T06:45:00.000' AS DateTime), 5, N'', 348, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (16, N'IB3162', 1, 8, 11, CAST(N'2026-02-14T06:30:00.000' AS DateTime), CAST(N'2026-02-14T09:15:00.000' AS DateTime), 4, N'T4-S80', 288, 256, 256, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (17, N'IB2610', 1, 2, 6, CAST(N'2026-02-14T20:15:00.000' AS DateTime), CAST(N'2026-02-14T21:20:00.000' AS DateTime), 4, N'T4-S38', 180, 167, 167, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (18, N'IB8780', 1, 5, 24, CAST(N'2026-02-15T16:30:00.000' AS DateTime), CAST(N'2026-02-15T17:25:00.000' AS DateTime), 5, N'', 68, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (19, N'IB8790', 1, 6, 25, CAST(N'2026-02-15T18:45:00.000' AS DateTime), CAST(N'2026-02-15T19:45:00.000' AS DateTime), 5, N'', 68, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (20, N'IB8510', 1, 7, 26, CAST(N'2026-02-15T15:15:00.000' AS DateTime), CAST(N'2026-02-15T16:10:00.000' AS DateTime), 5, N'', 100, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (21, N'IB3164', 1, 8, 7, CAST(N'2026-03-16T10:15:00.000' AS DateTime), CAST(N'2026-03-16T12:30:00.000' AS DateTime), 7, N'', 200, 187, 187, N'[{"timestamp":"2026-03-16T10:58:58","lat":44.054845362051104,"lng":-2.553885814508538,"altitud":35000,"progreso":0.32567901234567903},{"timestamp":"2026-03-16T10:59:29","lat":44.096196715959906,"lng":-2.5421772759635863,"altitud":35000,"progreso":0.3295061728395062},{"timestamp":"2026-03-16T10:59:59","lat":44.137060294806574,"lng":-2.530606849779569,"altitud":35000,"progreso":0.3332098765432099},{"timestamp":"2026-03-16T11:00:29","lat":44.17800358445858,"lng":-2.5190138536686097,"altitud":35000,"progreso":0.3369135802469136},{"timestamp":"2026-03-16T11:00:59","lat":44.21892646639667,"lng":-2.5074266359538173,"altitud":35000,"progreso":0.3406172839506173},{"timestamp":"2026-03-16T11:01:29","lat":44.25984522323409,"lng":-2.495840586251574,"altitud":35000,"progreso":0.344320987654321},{"timestamp":"2026-03-16T11:01:59","lat":44.300747629433005,"lng":-2.4842591661941418,"altitud":35000,"progreso":0.3480246913580247},{"timestamp":"2026-03-16T11:02:30","lat":44.341784458706165,"lng":-2.472639684559584,"altitud":35000,"progreso":0.35185185185185186},{"timestamp":"2026-03-16T11:03:00","lat":44.38273072381836,"lng":-2.4610458459540725,"altitud":35000,"progreso":0.35555555555555557},{"timestamp":"2026-03-16T11:03:30","lat":44.42364351507126,"lng":-2.449461485393045,"altitud":35000,"progreso":0.3592592592592593},{"timestamp":"2026-03-16T11:04:00","lat":44.464541096228956,"lng":-2.4378814315346826,"altitud":35000,"progreso":0.362962962962963},{"timestamp":"2026-03-16T11:04:30","lat":44.50548532832274,"lng":-2.42628816857355,"altitud":35000,"progreso":0.36666666666666664},{"timestamp":"2026-03-16T11:05:00","lat":44.546390967418766,"lng":-2.41470583312891,"altitud":35000,"progreso":0.37037037037037035},{"timestamp":"2026-03-16T11:05:30","lat":44.58732715094297,"lng":-2.403114849101315,"altitud":35000,"progreso":0.37407407407407406},{"timestamp":"2026-03-16T11:06:01","lat":44.628257788168085,"lng":-2.391525435495252,"altitud":35000,"progreso":0.37790123456790126},{"timestamp":"2026-03-16T11:06:31","lat":44.669219237034376,"lng":-2.379927297645503,"altitud":35000,"progreso":0.38160493827160497},{"timestamp":"2026-03-16T11:07:01","lat":44.71009568555427,"lng":-2.368353227443799,"altitud":35000,"progreso":0.3853086419753086},{"timestamp":"2026-03-16T11:07:31","lat":44.75104808502424,"lng":-2.3567576519093216,"altitud":35000,"progreso":0.38901234567901233},{"timestamp":"2026-03-16T11:08:01","lat":44.79197706167264,"lng":-2.345168708491648,"altitud":35000,"progreso":0.39271604938271604},{"timestamp":"2026-03-16T11:08:31","lat":44.83295678774513,"lng":-2.3335653954939746,"altitud":35000,"progreso":0.39641975308641975},{"timestamp":"2026-03-16T11:09:02","lat":44.87390717402042,"lng":-2.3219703899908346,"altitud":35000,"progreso":0.4002469135802469},{"timestamp":"2026-03-16T11:09:32","lat":44.914875055822414,"lng":-2.3103704306704786,"altitud":35000,"progreso":0.4039506172839506},{"timestamp":"2026-03-16T11:10:02","lat":44.95586983679476,"lng":-2.29876285491334,"altitud":35000,"progreso":0.4076543209876543},{"timestamp":"2026-03-16T11:10:32","lat":44.996799791323255,"lng":-2.28717363461122,"altitud":35000,"progreso":0.411358024691358},{"timestamp":"2026-03-16T11:11:02","lat":45.03774088013405,"lng":-2.27558126166327,"altitud":35000,"progreso":0.4150617283950617},{"timestamp":"2026-03-16T11:11:32","lat":45.0787237929388,"lng":-2.263977046349856,"altitud":35000,"progreso":0.41876543209876543},{"timestamp":"2026-03-16T11:12:03","lat":45.11970270841089,"lng":-2.252373962871781,"altitud":35000,"progreso":0.4225925925925926},{"timestamp":"2026-03-16T11:12:33","lat":45.16062305209705,"lng":-2.24078746385705,"altitud":35000,"progreso":0.4262962962962963},{"timestamp":"2026-03-16T11:13:03","lat":45.20160632037113,"lng":-2.2291831478933335,"altitud":35000,"progreso":0.43},{"timestamp":"2026-03-16T11:13:33","lat":45.24257218218949,"lng":-2.217583760526589,"altitud":35000,"progreso":0.4337037037037037},{"timestamp":"2026-03-16T11:14:03","lat":45.28371794597418,"lng":-2.2059334343414525,"altitud":35000,"progreso":0.4374074074074074},{"timestamp":"2026-03-16T11:14:33","lat":45.324614357939225,"lng":-2.1943537115372362,"altitud":35000,"progreso":0.4411111111111111},{"timestamp":"2026-03-16T11:15:04","lat":45.365509920606854,"lng":-2.1827742292095844,"altitud":35000,"progreso":0.44493827160493826},{"timestamp":"2026-03-16T11:15:34","lat":45.40660114089589,"lng":-2.171139346886882,"altitud":35000,"progreso":0.44864197530864197},{"timestamp":"2026-03-16T11:18:36","lat":45.65402989824508,"lng":-2.1010804765306172,"altitud":35000,"progreso":0.4711111111111111},{"timestamp":"2026-03-16T11:19:07","lat":45.69537669812746,"lng":-2.0893732274475285,"altitud":35000,"progreso":0.4749382716049383},{"timestamp":"2026-03-16T11:19:37","lat":45.73637543800703,"lng":-2.077764530735127,"altitud":35000,"progreso":0.478641975308642},{"timestamp":"2026-03-16T11:20:07","lat":45.777290068929105,"lng":-2.066179649276104,"altitud":35000,"progreso":0.48234567901234565},{"timestamp":"2026-03-16T11:20:37","lat":45.81854849055605,"lng":-2.0544974242880563,"altitud":35000,"progreso":0.48604938271604936},{"timestamp":"2026-03-16T11:21:07","lat":45.85945860954318,"lng":-2.0429138203727932,"altitud":35000,"progreso":0.48975308641975307},{"timestamp":"2026-03-16T11:21:38","lat":45.900448152298914,"lng":-2.031307727804361,"altitud":35000,"progreso":0.49358024691358027},{"timestamp":"2026-03-16T11:22:08","lat":45.94144793672605,"lng":-2.0196987353307754,"altitud":35000,"progreso":0.497283950617284},{"timestamp":"2026-03-16T11:22:38","lat":45.98242219199257,"lng":-2.0080969713789387,"altitud":35000,"progreso":0.5009876543209877},{"timestamp":"2026-03-16T11:23:08","lat":46.023423682346596,"lng":-1.9964874958761685,"altitud":35000,"progreso":0.5046913580246913},{"timestamp":"2026-03-16T11:23:38","lat":46.064400761679764,"lng":-1.9848849322965063,"altitud":35000,"progreso":0.5083950617283951},{"timestamp":"2026-03-16T11:24:09","lat":46.10544722881527,"lng":-1.9732627217239058,"altitud":35000,"progreso":0.5122222222222222},{"timestamp":"2026-03-16T11:24:39","lat":46.146430350719626,"lng":-1.9616584472044314,"altitud":35000,"progreso":0.5159259259259259},{"timestamp":"2026-03-16T11:25:09","lat":46.187358093544596,"lng":-1.9500698531409604,"altitud":35000,"progreso":0.5196296296296297},{"timestamp":"2026-03-16T11:25:39","lat":46.228357959710664,"lng":-1.9384608375231873,"altitud":35000,"progreso":0.5233333333333333},{"timestamp":"2026-03-16T11:26:09","lat":46.2695245195371,"lng":-1.9268046229877704,"altitud":35000,"progreso":0.5270370370370371},{"timestamp":"2026-03-16T11:26:40","lat":46.31047155139311,"lng":-1.9152105672805553,"altitud":35000,"progreso":0.5308641975308642},{"timestamp":"2026-03-16T11:27:10","lat":46.35140394274665,"lng":-1.9036206569971577,"altitud":35000,"progreso":0.5345679012345679},{"timestamp":"2026-03-16T11:27:40","lat":46.39240938331804,"lng":-1.8920100629996357,"altitud":35000,"progreso":0.5382716049382716},{"timestamp":"2026-03-16T11:28:10","lat":46.43332185209591,"lng":-1.8804257937466564,"altitud":35000,"progreso":0.5419753086419753},{"timestamp":"2026-03-16T11:28:40","lat":46.47442290128829,"lng":-1.8687881283931014,"altitud":35000,"progreso":0.5456790123456791},{"timestamp":"2026-03-16T11:29:10","lat":46.51541916455958,"lng":-1.8571801329265065,"altitud":35000,"progreso":0.5493827160493827},{"timestamp":"2026-03-16T11:29:41","lat":46.556383896832756,"lng":-1.8455810653878255,"altitud":35000,"progreso":0.5532098765432099},{"timestamp":"2026-03-16T11:30:11","lat":46.59738337888014,"lng":-1.8339721585323545,"altitud":35000,"progreso":0.5569135802469136},{"timestamp":"2026-03-16T11:30:41","lat":46.638397173523785,"lng":-1.8223591990989334,"altitud":35000,"progreso":0.5606172839506173},{"timestamp":"2026-03-16T11:31:11","lat":46.67936699058334,"lng":-1.8107586918149536,"altitud":35000,"progreso":0.564320987654321},{"timestamp":"2026-03-16T11:31:41","lat":46.72030842454426,"lng":-1.7991662211385582,"altitud":35000,"progreso":0.5680246913580247},{"timestamp":"2026-03-16T11:32:12","lat":46.76128225550152,"lng":-1.78756457732889,"altitud":35000,"progreso":0.5718518518518518},{"timestamp":"2026-03-16T11:32:42","lat":46.802271013047516,"lng":-1.775958707090749,"altitud":35000,"progreso":0.5755555555555556},{"timestamp":"2026-03-16T11:33:12","lat":46.84324626873343,"lng":-1.7643566598725138,"altitud":35000,"progreso":0.5792592592592593},{"timestamp":"2026-03-16T11:33:42","lat":46.88417359851879,"lng":-1.7527681827602353,"altitud":35000,"progreso":0.582962962962963},{"timestamp":"2026-03-16T11:34:12","lat":46.92518908564721,"lng":-1.7411547441037338,"altitud":35000,"progreso":0.5866666666666667},{"timestamp":"2026-03-16T11:34:42","lat":46.96616274674499,"lng":-1.7295531483893782,"altitud":35000,"progreso":0.5903703703703703},{"timestamp":"2026-03-16T11:35:13","lat":47.00712667792228,"lng":-1.7179543076791106,"altitud":35000,"progreso":0.5941975308641976},{"timestamp":"2026-03-16T11:35:45","lat":47.051053123041385,"lng":-1.70551663811806,"altitud":35000,"progreso":0.5981481481481481},{"timestamp":"2026-03-16T11:36:16","lat":47.09276555476106,"lng":-1.6937058612407005,"altitud":35000,"progreso":0.6019753086419753},{"timestamp":"2026-03-16T11:36:46","lat":47.133790879618466,"lng":-1.6820896370543892,"altitud":35000,"progreso":0.605679012345679},{"timestamp":"2026-03-16T11:37:16","lat":47.174813733434526,"lng":-1.6704741125376206,"altitud":35000,"progreso":0.6093827160493828},{"timestamp":"2026-03-16T11:37:46","lat":47.21582053220288,"lng":-1.6588631339698232,"altitud":35000,"progreso":0.6130864197530864},{"timestamp":"2026-03-16T11:38:17","lat":47.25681347866567,"lng":-1.6472560776497522,"altitud":35000,"progreso":0.6169135802469136},{"timestamp":"2026-03-16T11:38:47","lat":47.29787415982191,"lng":-1.6356298424106306,"altitud":35000,"progreso":0.6206172839506173},{"timestamp":"2026-03-16T11:39:17","lat":47.33890948317059,"lng":-1.624010787175045,"altitud":35000,"progreso":0.624320987654321},{"timestamp":"2026-03-16T11:39:47","lat":47.38014738479442,"lng":-1.6123343723775885,"altitud":35000,"progreso":0.6280246913580247},{"timestamp":"2026-03-16T11:40:18","lat":47.42125956528197,"lng":-1.600693555224004,"altitud":35000,"progreso":0.6318518518518519},{"timestamp":"2026-03-16T11:40:48","lat":47.4622946675825,"lng":-1.5890745625776823,"altitud":35000,"progreso":0.6355555555555555},{"timestamp":"2026-03-16T11:41:18","lat":47.50329442553274,"lng":-1.5774655776009676,"altitud":35000,"progreso":0.6392592592592593},{"timestamp":"2026-03-16T11:41:48","lat":47.54428840187895,"lng":-1.565858229671826,"altitud":35000,"progreso":0.642962962962963},{"timestamp":"2026-03-16T11:42:18","lat":47.58532693830101,"lng":-1.5542382646620743,"altitud":35000,"progreso":0.6466666666666666},{"timestamp":"2026-03-16T11:42:49","lat":47.62628732266023,"lng":-1.5426404282249964,"altitud":35000,"progreso":0.6504938271604939},{"timestamp":"2026-03-16T11:43:17","lat":47.66504716750964,"lng":-1.5316656693714754,"altitud":35000,"progreso":0.6539506172839507},{"timestamp":"2026-03-16T11:43:48","lat":47.70624989043351,"lng":-1.5199992153401234,"altitud":35000,"progreso":0.6577777777777778},{"timestamp":"2026-03-16T11:44:18","lat":47.74740030030276,"lng":-1.5083475736270797,"altitud":35000,"progreso":0.6614814814814814},{"timestamp":"2026-03-16T11:44:48","lat":47.78841490907707,"lng":-1.4967343836744775,"altitud":35000,"progreso":0.6651851851851852},{"timestamp":"2026-03-16T11:45:18","lat":47.82942827846101,"lng":-1.4851215446523431,"altitud":35000,"progreso":0.6688888888888889},{"timestamp":"2026-03-16T11:45:48","lat":47.87038534994931,"lng":-1.4735246462468687,"altitud":35000,"progreso":0.6725925925925926},{"timestamp":"2026-03-16T11:46:19","lat":47.91142264521587,"lng":-1.4619050326673766,"altitud":35000,"progreso":0.6764197530864198},{"timestamp":"2026-03-16T11:46:49","lat":47.95252277708558,"lng":-1.450267627051578,"altitud":35000,"progreso":0.6801234567901234},{"timestamp":"2026-03-16T11:47:23","lat":47.9988502245534,"lng":-1.437150119325893,"altitud":35000,"progreso":0.684320987654321},{"timestamp":"2026-03-16T11:47:53","lat":48.04010463241842,"lng":-1.4254690308250888,"altitud":35000,"progreso":0.6880246913580247},{"timestamp":"2026-03-16T11:48:24","lat":48.081099522421276,"lng":-1.4138614241962189,"altitud":35000,"progreso":0.6918518518518518},{"timestamp":"2026-03-16T11:48:54","lat":48.12214814681295,"lng":-1.4022386028016127,"altitud":35000,"progreso":0.6955555555555556},{"timestamp":"2026-03-16T11:49:24","lat":48.1633647536789,"lng":-1.3905682175647347,"altitud":35000,"progreso":0.6992592592592592},{"timestamp":"2026-03-16T11:49:54","lat":48.20440623256687,"lng":-1.378947419402686,"altitud":35000,"progreso":0.702962962962963},{"timestamp":"2026-03-16T11:50:25","lat":48.24540291430892,"lng":-1.36733930544708,"altitud":35000,"progreso":0.7067901234567902},{"timestamp":"2026-03-16T11:50:55","lat":48.28648026532,"lng":-1.3557083501777902,"altitud":35000,"progreso":0.7104938271604938},{"timestamp":"2026-03-16T11:51:25","lat":48.32745231390682,"lng":-1.3441072110421195,"altitud":35000,"progreso":0.7141975308641976},{"timestamp":"2026-03-16T11:51:39","lat":48.34696110061502,"lng":-1.3385833439967505,"altitud":35000,"progreso":0.715925925925926},{"timestamp":"2026-03-16T11:52:10","lat":48.38838550862971,"lng":-1.3268541203536364,"altitud":35000,"progreso":0.7197530864197531},{"timestamp":"2026-03-16T11:52:40","lat":48.42941668270906,"lng":-1.3152362399738973,"altitud":35000,"progreso":0.7234567901234568},{"timestamp":"2026-03-16T11:53:10","lat":48.47048738978393,"lng":-1.303607165919511,"altitud":35000,"progreso":0.7271604938271605},{"timestamp":"2026-03-16T11:53:41","lat":48.51148428103292,"lng":-1.2919989926425077,"altitud":35000,"progreso":0.7309876543209877},{"timestamp":"2026-03-16T11:54:11","lat":48.55257027356033,"lng":-1.2803655905482083,"altitud":35000,"progreso":0.7346913580246913},{"timestamp":"2026-03-16T11:54:41","lat":48.59358334029296,"lng":-1.2687528372210797,"altitud":35000,"progreso":0.7383950617283951},{"timestamp":"2026-03-16T11:55:11","lat":48.63472469642095,"lng":-1.2571037590535639,"altitud":35000,"progreso":0.7420987654320987},{"timestamp":"2026-03-16T11:55:42","lat":48.6757301405226,"lng":-1.2454931640564588,"altitud":35000,"progreso":0.7459259259259259},{"timestamp":"2026-03-16T11:56:12","lat":48.71676714359283,"lng":-1.2338736332116689,"altitud":35000,"progreso":0.7496296296296296},{"timestamp":"2026-03-16T11:56:42","lat":48.757789435691315,"lng":-1.222258267743908,"altitud":35000,"progreso":0.7533333333333333},{"timestamp":"2026-03-16T11:57:12","lat":48.7988053593491,"lng":-1.2106447054851444,"altitud":35000,"progreso":0.7570370370370371},{"timestamp":"2026-03-16T11:57:42","lat":48.839798142198234,"lng":-1.199037695491893,"altitud":35000,"progreso":0.7607407407407407},{"timestamp":"2026-03-16T11:58:13","lat":48.88076652516039,"lng":-1.1874375942692188,"altitud":35000,"progreso":0.7645679012345679},{"timestamp":"2026-03-16T11:58:43","lat":48.92200770801864,"lng":-1.1757602503979587,"altitud":35000,"progreso":0.7682716049382716},{"timestamp":"2026-03-16T11:59:13","lat":48.96294679857043,"lng":-1.1641684432523411,"altitud":35000,"progreso":0.7719753086419753},{"timestamp":"2026-03-16T11:59:43","lat":49.003933173738744,"lng":-1.152563247578835,"altitud":35000,"progreso":0.775679012345679},{"timestamp":"2026-03-16T12:00:13","lat":49.04494727320616,"lng":-1.1409502018352806,"altitud":35000,"progreso":0.7793827160493827},{"timestamp":"2026-03-16T12:00:44","lat":49.086011235325266,"lng":-1.1293230375992453,"altitud":35000,"progreso":0.7832098765432098},{"timestamp":"2026-03-16T12:01:14","lat":49.127017589960644,"lng":-1.117712184786659,"altitud":35000,"progreso":0.7869135802469136},{"timestamp":"2026-03-16T12:01:44","lat":49.168081604897765,"lng":-1.1060850055953275,"altitud":35000,"progreso":0.7906172839506173},{"timestamp":"2026-03-16T12:02:14","lat":49.20901880757886,"lng":-1.094493732995856,"altitud":35000,"progreso":0.794320987654321},{"timestamp":"2026-03-16T12:02:44","lat":49.25001732736073,"lng":-1.0828850986035996,"altitud":35000,"progreso":0.7980246913580247},{"timestamp":"2026-03-16T12:03:15","lat":49.29096167839689,"lng":-1.071291801964215,"altitud":35000,"progreso":0.8018518518518518},{"timestamp":"2026-03-16T12:03:45","lat":49.33188349161877,"lng":-1.0597048868539045,"altitud":35000,"progreso":0.8055555555555556},{"timestamp":"2026-03-16T12:04:15","lat":49.37287251135393,"lng":-1.048098942377515,"altitud":35000,"progreso":0.8092592592592592},{"timestamp":"2026-03-16T12:04:45","lat":49.41388834146002,"lng":-1.0364854066076963,"altitud":35000,"progreso":0.812962962962963},{"timestamp":"2026-03-16T12:05:15","lat":49.45497834693467,"lng":-1.0248508682568271,"altitud":35000,"progreso":0.8166666666666667},{"timestamp":"2026-03-16T12:05:46","lat":49.495932305554476,"lng":-1.0132548512527442,"altitud":35000,"progreso":0.8204938271604938},{"timestamp":"2026-03-16T12:06:16","lat":49.537363605166206,"lng":-1.0015236762701458,"altitud":35000,"progreso":0.8241975308641976},{"timestamp":"2026-03-16T12:06:46","lat":49.57847218180852,"lng":-0.9898838795368583,"altitud":35000,"progreso":0.8279012345679012},{"timestamp":"2026-03-16T12:07:17","lat":49.61972466174805,"lng":-0.9782033369236207,"altitud":35000,"progreso":0.8317283950617284},{"timestamp":"2026-03-16T12:07:47","lat":49.66068499654795,"lng":-0.9666055145191477,"altitud":35000,"progreso":0.8354320987654321},{"timestamp":"2026-03-16T12:08:17","lat":49.702136044395175,"lng":-0.9548687478701452,"altitud":35000,"progreso":0.8391358024691358},{"timestamp":"2026-03-16T12:08:48","lat":49.7434337023406,"lng":-0.9431754132108554,"altitud":35000,"progreso":0.8429629629629629},{"timestamp":"2026-03-16T12:09:18","lat":49.78448114844244,"lng":-0.9315529254462445,"altitud":35000,"progreso":0.8466666666666667},{"timestamp":"2026-03-16T12:09:49","lat":49.82579544718601,"lng":-0.9198548789841219,"altitud":35000,"progreso":0.8504938271604938},{"timestamp":"2026-03-16T12:10:19","lat":49.86695353508405,"lng":-0.908201063255293,"altitud":35000,"progreso":0.8541975308641976},{"timestamp":"2026-03-16T12:10:49","lat":49.908086615620036,"lng":-0.8965543283021802,"altitud":35000,"progreso":0.8579012345679012},{"timestamp":"2026-03-16T12:11:20","lat":49.94936609262655,"lng":-0.8848661415329588,"altitud":35000,"progreso":0.8617283950617284},{"timestamp":"2026-03-16T12:11:50","lat":49.99059488918468,"lng":-0.8731923048134278,"altitud":35000,"progreso":0.8654320987654321},{"timestamp":"2026-03-16T12:12:20","lat":50.03153714691656,"lng":-0.8615996008882214,"altitud":35000,"progreso":0.8691358024691358},{"timestamp":"2026-03-16T12:12:51","lat":50.07286014990633,"lng":-0.8498990898392718,"altitud":35000,"progreso":0.8729629629629629},{"timestamp":"2026-03-16T12:13:21","lat":50.11383746658113,"lng":-0.8382964590568855,"altitud":35000,"progreso":0.8766666666666667},{"timestamp":"2026-03-16T12:13:51","lat":50.15486705571264,"lng":-0.8266790274513953,"altitud":35000,"progreso":0.8803703703703704},{"timestamp":"2026-03-16T12:14:21","lat":50.19577774415675,"lng":-0.8150952622957313,"altitud":35000,"progreso":0.8840740740740741},{"timestamp":"2026-03-16T12:14:51","lat":50.23680539680869,"lng":-0.8034783789998738,"altitud":35000,"progreso":0.8877777777777778},{"timestamp":"2026-03-16T12:15:21","lat":50.27778281368836,"lng":-0.7918757198447137,"altitud":35000,"progreso":0.8914814814814814},{"timestamp":"2026-03-16T12:15:52","lat":50.31876848891612,"lng":-0.7802707223577277,"altitud":35000,"progreso":0.8953086419753087},{"timestamp":"2026-03-16T12:16:22","lat":50.35987504285922,"lng":-0.7686314983469624,"altitud":35000,"progreso":0.8990123456790123},{"timestamp":"2026-03-16T12:16:52","lat":50.40081788987181,"lng":-0.7570386275683121,"altitud":34049.38271604937,"progreso":0.9027160493827161},{"timestamp":"2026-03-16T12:17:22","lat":50.44182768623234,"lng":-0.7454268002393483,"altitud":32753.086419753086,"progreso":0.9064197530864198},{"timestamp":"2026-03-16T12:17:52","lat":50.48280307688255,"lng":-0.7338247148062922,"altitud":31456.790123456805,"progreso":0.9101234567901234},{"timestamp":"2026-03-16T12:29:35","lat":51.436975737442324,"lng":-0.463652971473691,"altitud":1080.2469135802517,"progreso":0.9969135802469136}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (22, N'IB3104', 1, 9, 4, CAST(N'2026-03-16T11:00:00.000' AS DateTime), CAST(N'2026-03-16T12:50:00.000' AS DateTime), 7, N'', 180, 165, 165, N'[{"timestamp":"2026-03-16T10:58:59","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T10:59:29","lat":40.51132264019571,"lng":-3.5401587211989907,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T10:59:59","lat":40.55025456287184,"lng":-3.512269348639114,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:00:29","lat":40.51007859557936,"lng":-3.541049908209586,"altitud":1537.8787878787878,"progreso":0.004393939393939394},{"timestamp":"2026-03-16T11:00:59","lat":40.54906701803928,"lng":-3.513120061318843,"altitud":3128.787878787879,"progreso":0.00893939393939394},{"timestamp":"2026-03-16T11:01:29","lat":40.58805151039556,"lng":-3.485193029807291,"altitud":4719.69696969697,"progreso":0.013484848484848485},{"timestamp":"2026-03-16T11:01:59","lat":40.62702042502194,"lng":-3.457277157598511,"altitud":6310.606060606061,"progreso":0.018030303030303032},{"timestamp":"2026-03-16T11:02:30","lat":40.66611740842937,"lng":-3.4292695417073635,"altitud":7954.545454545455,"progreso":0.022727272727272728},{"timestamp":"2026-03-16T11:03:00","lat":40.70512810872085,"lng":-3.4013237358117396,"altitud":9545.454545454544,"progreso":0.02727272727272727},{"timestamp":"2026-03-16T11:03:30","lat":40.744106917490875,"lng":-3.3734007758087,"altitud":11136.363636363634,"progreso":0.031818181818181815},{"timestamp":"2026-03-16T11:04:00","lat":40.78307123515983,"lng":-3.345488196688196,"altitud":12727.272727272728,"progreso":0.03636363636363636},{"timestamp":"2026-03-16T11:04:30","lat":40.822079998535415,"lng":-3.3175437783266433,"altitud":14318.181818181818,"progreso":0.04090909090909091},{"timestamp":"2026-03-16T11:05:00","lat":40.861051993237105,"lng":-3.289625699667169,"altitud":15909.09090909091,"progreso":0.045454545454545456},{"timestamp":"2026-03-16T11:05:30","lat":40.900053088505835,"lng":-3.26168677445042,"altitud":17500,"progreso":0.05},{"timestamp":"2026-03-16T11:06:01","lat":40.93904889965377,"lng":-3.233751634580077,"altitud":19143.939393939396,"progreso":0.054696969696969695},{"timestamp":"2026-03-16T11:06:31","lat":40.97807406595036,"lng":-3.2057954657797185,"altitud":20734.848484848484,"progreso":0.05924242424242424},{"timestamp":"2026-03-16T11:07:01","lat":41.017018249939305,"lng":-3.177897309674165,"altitud":22325.757575757572,"progreso":0.06378787878787878},{"timestamp":"2026-03-16T11:07:31","lat":41.056034794612245,"lng":-3.1499473170823675,"altitud":23916.666666666668,"progreso":0.06833333333333333},{"timestamp":"2026-03-16T11:08:01","lat":41.09502902368033,"lng":-3.1220133105548213,"altitud":25507.575757575756,"progreso":0.07287878787878788},{"timestamp":"2026-03-16T11:08:31","lat":41.13407160320402,"lng":-3.094044667570175,"altitud":27098.484848484844,"progreso":0.07742424242424242},{"timestamp":"2026-03-16T11:09:02","lat":41.1730862298477,"lng":-3.066096048982763,"altitud":28742.424242424244,"progreso":0.08212121212121212},{"timestamp":"2026-03-16T11:09:32","lat":41.212117524989644,"lng":-3.0381354897069333,"altitud":30333.333333333336,"progreso":0.08666666666666667},{"timestamp":"2026-03-16T11:10:02","lat":41.251174447755254,"lng":-3.0101565717605046,"altitud":31924.242424242424,"progreso":0.09121212121212122},{"timestamp":"2026-03-16T11:10:32","lat":41.29016960847821,"lng":-2.982221897830275,"altitud":33515.15151515152,"progreso":0.09575757575757576},{"timestamp":"2026-03-16T11:11:02","lat":41.32917537715647,"lng":-2.9542796247578256,"altitud":35000,"progreso":0.1003030303030303},{"timestamp":"2026-03-16T11:11:32","lat":41.36822099277287,"lng":-2.926308806829971,"altitud":35000,"progreso":0.10484848484848484},{"timestamp":"2026-03-16T11:12:03","lat":41.40726280001392,"lng":-2.898340717079707,"altitud":35000,"progreso":0.10954545454545454},{"timestamp":"2026-03-16T11:12:33","lat":41.446248804207244,"lng":-2.8704126025446666,"altitud":35000,"progreso":0.11409090909090909},{"timestamp":"2026-03-16T11:13:03","lat":41.48529475848963,"lng":-2.8424415420091713,"altitud":35000,"progreso":0.11863636363636364},{"timestamp":"2026-03-16T11:13:33","lat":41.52432412913429,"lng":-2.8144823613711814,"altitud":35000,"progreso":0.12318181818181818},{"timestamp":"2026-03-16T11:14:03","lat":41.56352489762613,"lng":-2.7864003977292375,"altitud":35000,"progreso":0.12772727272727272},{"timestamp":"2026-03-16T11:14:33","lat":41.60248810137117,"lng":-2.7584886165821447,"altitud":35000,"progreso":0.13227272727272726},{"timestamp":"2026-03-16T11:15:04","lat":41.64145049596581,"lng":-2.7305774150801208,"altitud":35000,"progreso":0.13696969696969696},{"timestamp":"2026-03-16T11:15:34","lat":41.680599299279486,"lng":-2.702532677347261,"altitud":35000,"progreso":0.1415151515151515},{"timestamp":"2026-03-16T11:18:36","lat":41.91633188856435,"lng":-2.533662671574353,"altitud":35000,"progreso":0.1690909090909091},{"timestamp":"2026-03-16T11:19:07","lat":41.95572419000634,"lng":-2.5054435008941445,"altitud":35000,"progreso":0.1737878787878788},{"timestamp":"2026-03-16T11:19:37","lat":41.994784884538255,"lng":-2.4774618809954747,"altitud":35000,"progreso":0.17833333333333334},{"timestamp":"2026-03-16T11:20:07","lat":42.03376544601472,"lng":-2.4495376654191277,"altitud":35000,"progreso":0.1828787878787879},{"timestamp":"2026-03-16T11:20:37","lat":42.07307354691667,"lng":-2.4213788128549916,"altitud":35000,"progreso":0.18742424242424244},{"timestamp":"2026-03-16T11:21:07","lat":42.112049809741194,"lng":-2.393457676672032,"altitud":35000,"progreso":0.19196969696969696},{"timestamp":"2026-03-16T11:21:38","lat":42.15110174190515,"lng":-2.3654823338058772,"altitud":35000,"progreso":0.19666666666666666},{"timestamp":"2026-03-16T11:22:08","lat":42.19016343160798,"lng":-2.337500001004007,"altitud":35000,"progreso":0.2012121212121212},{"timestamp":"2026-03-16T11:22:38","lat":42.229200798935345,"lng":-2.3095350918417608,"altitud":35000,"progreso":0.20575757575757575},{"timestamp":"2026-03-16T11:23:08","lat":42.268264113924445,"lng":-2.281551594745623,"altitud":35000,"progreso":0.2103030303030303},{"timestamp":"2026-03-16T11:23:38","lat":42.30730417182243,"lng":-2.2535847581592696,"altitud":35000,"progreso":0.21484848484848484},{"timestamp":"2026-03-16T11:24:09","lat":42.34641033750225,"lng":-2.225570564431787,"altitud":35000,"progreso":0.21954545454545454},{"timestamp":"2026-03-16T11:24:39","lat":42.385456152333944,"lng":-2.197599603793556,"altitud":35000,"progreso":0.2240909090909091},{"timestamp":"2026-03-16T11:25:09","lat":42.424449205902484,"lng":-2.169666439349901,"altitud":35000,"progreso":0.22863636363636364},{"timestamp":"2026-03-16T11:25:39","lat":42.463510973480375,"lng":-2.1416840507612473,"altitud":35000,"progreso":0.23318181818181818},{"timestamp":"2026-03-16T11:26:09","lat":42.502731554967355,"lng":-2.1135878938309913,"altitud":35000,"progreso":0.23772727272727273},{"timestamp":"2026-03-16T11:26:40","lat":42.541742985758006,"lng":-2.0856415646330966,"altitud":35000,"progreso":0.24242424242424243},{"timestamp":"2026-03-16T11:27:10","lat":42.580740468115216,"lng":-2.057705227570964,"altitud":35000,"progreso":0.24696969696969698},{"timestamp":"2026-03-16T11:27:40","lat":42.619807546591545,"lng":-2.029719034453405,"altitud":35000,"progreso":0.2515151515151515},{"timestamp":"2026-03-16T11:28:10","lat":42.658786048130196,"lng":-2.00179629453942,"altitud":35000,"progreso":0.25606060606060604},{"timestamp":"2026-03-16T11:28:40","lat":42.69794421572659,"lng":-1.973744848584836,"altitud":35000,"progreso":0.2606060606060606},{"timestamp":"2026-03-16T11:29:10","lat":42.7370025507216,"lng":-1.945764918970107,"altitud":35000,"progreso":0.26515151515151514},{"timestamp":"2026-03-16T11:29:41","lat":42.77603084521563,"lng":-1.9178065092461585,"altitud":35000,"progreso":0.26984848484848484},{"timestamp":"2026-03-16T11:30:11","lat":42.81509224683245,"lng":-1.8898243828183197,"altitud":35000,"progreso":0.2743939393939394},{"timestamp":"2026-03-16T11:30:41","lat":42.85416728447693,"lng":-1.8618324880505366,"altitud":35000,"progreso":0.27893939393939393},{"timestamp":"2026-03-16T11:31:11","lat":42.89320042339516,"lng":-1.83387060796237,"altitud":35000,"progreso":0.2834848484848485},{"timestamp":"2026-03-16T11:31:41","lat":42.932206520908,"lng":-1.8059280993251303,"altitud":35000,"progreso":0.288030303030303},{"timestamp":"2026-03-16T11:32:12","lat":42.971243483983564,"lng":-1.7779634797537458,"altitud":35000,"progreso":0.2927272727272727},{"timestamp":"2026-03-16T11:32:42","lat":43.01029466805531,"lng":-1.749988672792856,"altitud":35000,"progreso":0.2972727272727273},{"timestamp":"2026-03-16T11:33:12","lat":43.04933298851141,"lng":-1.7220230808448596,"altitud":35000,"progreso":0.3018181818181818},{"timestamp":"2026-03-16T11:33:42","lat":43.088325648565075,"lng":-1.6940901983005332,"altitud":35000,"progreso":0.30636363636363634},{"timestamp":"2026-03-16T11:34:12","lat":43.12740229868913,"lng":-1.6660971484127214,"altitud":35000,"progreso":0.3109090909090909},{"timestamp":"2026-03-16T11:34:42","lat":43.166439099934614,"lng":-1.6381326447703504,"altitud":35000,"progreso":0.31545454545454543},{"timestamp":"2026-03-16T11:35:13","lat":43.20546663120125,"lng":-1.6101747817939482,"altitud":35000,"progreso":0.32015151515151513},{"timestamp":"2026-03-16T11:35:45","lat":43.247316635852854,"lng":-1.5801950045024304,"altitud":35000,"progreso":0.325},{"timestamp":"2026-03-16T11:36:16","lat":43.28705728540383,"lng":-1.551726290272244,"altitud":35000,"progreso":0.3296969696969697},{"timestamp":"2026-03-16T11:36:46","lat":43.32614330821904,"lng":-1.523726526139217,"altitud":35000,"progreso":0.33424242424242423},{"timestamp":"2026-03-16T11:37:16","lat":43.36522697680113,"lng":-1.495728448490699,"altitud":35000,"progreso":0.3387878787878788},{"timestamp":"2026-03-16T11:37:46","lat":43.4042953492713,"lng":-1.4677413284043754,"altitud":35000,"progreso":0.3433333333333333},{"timestamp":"2026-03-16T11:38:17","lat":43.44335052424617,"lng":-1.4397636625098293,"altitud":35000,"progreso":0.348030303030303},{"timestamp":"2026-03-16T11:38:47","lat":43.48247023203786,"lng":-1.4117397677201509,"altitud":35000,"progreso":0.3525757575757576},{"timestamp":"2026-03-16T11:39:17","lat":43.52156578070714,"lng":-1.3837331796217232,"altitud":35000,"progreso":0.3571212121212121},{"timestamp":"2026-03-16T11:39:47","lat":43.560854331604006,"lng":-1.3555883319496678,"altitud":35000,"progreso":0.3616666666666667},{"timestamp":"2026-03-16T11:40:18","lat":43.60002310430975,"lng":-1.3275292888915837,"altitud":35000,"progreso":0.3663636363636364},{"timestamp":"2026-03-16T11:40:48","lat":43.63911844238002,"lng":-1.299522851658411,"altitud":35000,"progreso":0.3709090909090909},{"timestamp":"2026-03-16T11:41:18","lat":43.67818010685753,"lng":-1.2715405369270107,"altitud":35000,"progreso":0.37545454545454543},{"timestamp":"2026-03-16T11:41:48","lat":43.71723626303237,"lng":-1.243562168137525,"altitud":35000,"progreso":0.38},{"timestamp":"2026-03-16T11:42:18","lat":43.75633487289032,"lng":-1.2155533871180881,"altitud":35000,"progreso":0.3845454545454545},{"timestamp":"2026-03-16T11:42:49","lat":43.79535902499999,"lng":-1.187597944843283,"altitud":35000,"progreso":0.3892424242424242},{"timestamp":"2026-03-16T11:43:17","lat":43.83228665897641,"lng":-1.1611443697067467,"altitud":35000,"progreso":0.3934848484848485},{"timestamp":"2026-03-16T11:43:48","lat":43.871541694100415,"lng":-1.1330235314801915,"altitud":35000,"progreso":0.3981818181818182},{"timestamp":"2026-03-16T11:44:18","lat":43.91074688905243,"lng":-1.104938396887813,"altitud":35000,"progreso":0.4027272727272727},{"timestamp":"2026-03-16T11:44:48","lat":43.94982270234292,"lng":-1.0769459464762519,"altitud":35000,"progreso":0.4072727272727273},{"timestamp":"2026-03-16T11:45:18","lat":43.98889733483007,"lng":-1.048954341948014,"altitud":35000,"progreso":0.4118181818181818},{"timestamp":"2026-03-16T11:45:48","lat":44.027918330671056,"lng":-1.0210011607059886,"altitud":35000,"progreso":0.4163636363636364},{"timestamp":"2026-03-16T11:46:19","lat":44.06701575804398,"lng":-0.9929932267745727,"altitud":35000,"progreso":0.4210606060606061},{"timestamp":"2026-03-16T11:46:49","lat":44.106173051680315,"lng":-0.9649424068922645,"altitud":35000,"progreso":0.4256060606060606},{"timestamp":"2026-03-16T11:47:23","lat":44.15031056125498,"lng":-0.9333239466730512,"altitud":35000,"progreso":0.4307575757575758},{"timestamp":"2026-03-16T11:47:53","lat":44.18961483812895,"lng":-0.9051678334994633,"altitud":35000,"progreso":0.4353030303030303},{"timestamp":"2026-03-16T11:48:24","lat":44.22867186477111,"lng":-0.8771888411397675,"altitud":35000,"progreso":0.44},{"timestamp":"2026-03-16T11:48:54","lat":44.26778008573175,"lng":-0.8491731750860088,"altitud":35000,"progreso":0.4445454545454545},{"timestamp":"2026-03-16T11:49:24","lat":44.307048348492074,"lng":-0.8210428610757812,"altitud":35000,"progreso":0.4490909090909091},{"timestamp":"2026-03-16T11:49:54","lat":44.34614976172306,"lng":-0.7930320718248036,"altitud":35000,"progreso":0.4536363636363636},{"timestamp":"2026-03-16T11:50:25","lat":44.38520849540737,"lng":-0.7650518566039834,"altitud":35000,"progreso":0.4583333333333333},{"timestamp":"2026-03-16T11:50:55","lat":44.424344085055665,"lng":-0.7370165846465362,"altitud":35000,"progreso":0.4628787878787879},{"timestamp":"2026-03-16T11:51:25","lat":44.46337935001496,"lng":-0.7090531815421093,"altitud":35000,"progreso":0.4674242424242424},{"timestamp":"2026-03-16T11:51:40","lat":44.48196593976225,"lng":-0.6957384441634353,"altitud":35000,"progreso":0.46954545454545454},{"timestamp":"2026-03-16T11:52:10","lat":44.521432180734045,"lng":-0.6674663059709123,"altitud":35000,"progreso":0.47424242424242424},{"timestamp":"2026-03-16T11:52:40","lat":44.5605237762735,"lng":-0.6394625497467703,"altitud":35000,"progreso":0.47878787878787876},{"timestamp":"2026-03-16T11:53:10","lat":44.5996530360501,"lng":-0.6114318122725386,"altitud":35000,"progreso":0.48333333333333334},{"timestamp":"2026-03-16T11:53:41","lat":44.63871196933778,"lng":-0.5834514540633342,"altitud":35000,"progreso":0.48803030303030304},{"timestamp":"2026-03-16T11:54:11","lat":44.67785579201056,"lng":-0.5554102842752298,"altitud":35000,"progreso":0.49257575757575756},{"timestamp":"2026-03-16T11:54:41","lat":44.71693013615299,"lng":-0.5274188863063616,"altitud":35000,"progreso":0.49712121212121213},{"timestamp":"2026-03-16T11:55:11","lat":44.75612670534181,"lng":-0.4993399308879547,"altitud":35000,"progreso":0.5016666666666667},{"timestamp":"2026-03-16T11:55:42","lat":44.79519378718152,"lng":-0.4713537353609998,"altitud":35000,"progreso":0.5063636363636363},{"timestamp":"2026-03-16T11:56:12","lat":44.83429093617049,"lng":-0.44334600085343556,"altitud":35000,"progreso":0.5109090909090909},{"timestamp":"2026-03-16T11:56:42","lat":44.873374069587875,"lng":-0.4153483065768837,"altitud":35000,"progreso":0.5154545454545455},{"timestamp":"2026-03-16T11:57:12","lat":44.912451135606176,"lng":-0.3873549587579932,"altitud":35000,"progreso":0.52},{"timestamp":"2026-03-16T11:57:42","lat":44.95150615470155,"lng":-0.35937740452968336,"altitud":35000,"progreso":0.5245454545454545},{"timestamp":"2026-03-16T11:58:13","lat":44.99053792731338,"lng":-0.3314165032122949,"altitud":35000,"progreso":0.5292424242424243},{"timestamp":"2026-03-16T11:58:43","lat":45.02982960433791,"lng":-0.30326941609935476,"altitud":35000,"progreso":0.5337878787878788},{"timestamp":"2026-03-16T11:59:13","lat":45.06883346921657,"lng":-0.2753285068376936,"altitud":35000,"progreso":0.5383333333333333},{"timestamp":"2026-03-16T11:59:43","lat":45.10788238352765,"lng":-0.24735532584840758,"altitud":35000,"progreso":0.5428787878787878},{"timestamp":"2026-03-16T12:00:13","lat":45.14695771158662,"lng":-0.21936322303854894,"altitud":35000,"progreso":0.5474242424242424},{"timestamp":"2026-03-16T12:00:44","lat":45.186080545247265,"lng":-0.19133708899332458,"altitud":35000,"progreso":0.5521212121212121},{"timestamp":"2026-03-16T12:01:14","lat":45.225148494578995,"lng":-0.16335027202754748,"altitud":35000,"progreso":0.5566666666666666},{"timestamp":"2026-03-16T12:01:44","lat":45.2642713785609,"lng":-0.1353241019340521,"altitud":35000,"progreso":0.5612121212121212},{"timestamp":"2026-03-16T12:02:14","lat":45.30327344481012,"lng":-0.10738448114322052,"altitud":35000,"progreso":0.5657575757575758},{"timestamp":"2026-03-16T12:02:44","lat":45.34233392964854,"lng":-0.0794030114611215,"altitud":35000,"progreso":0.5703030303030303},{"timestamp":"2026-03-16T12:03:15","lat":45.38134280634398,"lng":-0.051458511921457895,"altitud":35000,"progreso":0.575},{"timestamp":"2026-03-16T12:03:45","lat":45.42033021060682,"lng":-0.02352939442901114,"altitud":35000,"progreso":0.5795454545454546},{"timestamp":"2026-03-16T12:04:15","lat":45.45938164447384,"lng":0.004445591475864319,"altitud":35000,"progreso":0.5840909090909091},{"timestamp":"2026-03-16T12:04:45","lat":45.4984586213627,"lng":0.03243887544576207,"altitud":35000,"progreso":0.5886363636363636},{"timestamp":"2026-03-16T12:05:15","lat":45.5376062672873,"lng":0.0604827840684008,"altitud":35000,"progreso":0.5931818181818181},{"timestamp":"2026-03-16T12:05:46","lat":45.576624297407726,"lng":0.08843384077919536,"altitud":35000,"progreso":0.5978787878787879},{"timestamp":"2026-03-16T12:06:16","lat":45.61609710420491,"lng":0.11671068248332794,"altitud":35000,"progreso":0.6024242424242424},{"timestamp":"2026-03-16T12:06:46","lat":45.65526244342226,"lng":0.1447672659188033,"altitud":35000,"progreso":0.6069696969696969},{"timestamp":"2026-03-16T12:07:17","lat":45.694564883505414,"lng":0.17292206328418436,"altitud":35000,"progreso":0.6116666666666667},{"timestamp":"2026-03-16T12:07:47","lat":45.73358898839847,"lng":0.20087747173477677,"altitud":35000,"progreso":0.6162121212121212},{"timestamp":"2026-03-16T12:08:18","lat":45.77308060991524,"lng":0.2291677915999628,"altitud":35000,"progreso":0.6207575757575757},{"timestamp":"2026-03-16T12:08:48","lat":45.81242609240149,"lng":0.25735342293225827,"altitud":35000,"progreso":0.6254545454545455},{"timestamp":"2026-03-16T12:09:18","lat":45.85153319077106,"lng":0.28536828480377796,"altitud":35000,"progreso":0.63},{"timestamp":"2026-03-16T12:09:49","lat":45.89089452743075,"lng":0.31356527347266105,"altitud":35000,"progreso":0.6346969696969696},{"timestamp":"2026-03-16T12:10:19","lat":45.93010703746461,"lng":0.34165564831593453,"altitud":35000,"progreso":0.6392424242424243},{"timestamp":"2026-03-16T12:10:49","lat":45.9692957222557,"lng":0.36972895564684327,"altitud":35000,"progreso":0.6437878787878788},{"timestamp":"2026-03-16T12:11:20","lat":46.00862388323149,"lng":0.3979021784972261,"altitud":35000,"progreso":0.6484848484848484},{"timestamp":"2026-03-16T12:11:50","lat":46.04790375946686,"lng":0.426040811966399,"altitud":35000,"progreso":0.6530303030303031},{"timestamp":"2026-03-16T12:12:20","lat":46.08691064181031,"lng":0.45398388282692137,"altitud":35000,"progreso":0.6575757575757576},{"timestamp":"2026-03-16T12:12:51","lat":46.12628027125908,"lng":0.48218681213957426,"altitud":35000,"progreso":0.6622727272727272},{"timestamp":"2026-03-16T12:13:21","lat":46.16532055527935,"lng":0.5101538107114725,"altitud":35000,"progreso":0.6668181818181819},{"timestamp":"2026-03-16T12:13:51","lat":46.2044106407928,"lng":0.5381564852094924,"altitud":35000,"progreso":0.6713636363636364},{"timestamp":"2026-03-16T12:14:21","lat":46.24338744615558,"lng":0.5660780100465561,"altitud":35000,"progreso":0.6759090909090909},{"timestamp":"2026-03-16T12:14:51","lat":46.282475686728496,"lng":0.5940793628982175,"altitud":35000,"progreso":0.6804545454545454},{"timestamp":"2026-03-16T12:15:21","lat":46.32151606621687,"lng":0.622046429859894,"altitud":35000,"progreso":0.685},{"timestamp":"2026-03-16T12:15:52","lat":46.36056431367419,"lng":0.6500191331400944,"altitud":35000,"progreso":0.6896969696969697},{"timestamp":"2026-03-16T12:16:22","lat":46.39972772580704,"lng":0.678074336084348,"altitud":35000,"progreso":0.6942424242424242},{"timestamp":"2026-03-16T12:16:52","lat":46.43873516957539,"lng":0.7060178091286597,"altitud":35000,"progreso":0.6987878787878787},{"timestamp":"2026-03-16T12:17:22","lat":46.47780639793899,"lng":0.7340069750701681,"altitud":35000,"progreso":0.7033333333333334},{"timestamp":"2026-03-16T12:17:52","lat":46.516844846979495,"lng":0.7619726591312266,"altitud":35000,"progreso":0.7078787878787879},{"timestamp":"2026-03-16T12:29:35","lat":47.42591295332392,"lng":1.4131950328898282,"altitud":35000,"progreso":0.8143939393939394},{"timestamp":"2026-03-16T12:30:05","lat":47.464916671507694,"lng":1.4411358370647585,"altitud":35000,"progreso":0.818939393939394},{"timestamp":"2026-03-16T12:30:35","lat":47.503919288315515,"lng":1.4690758522551755,"altitud":35000,"progreso":0.8234848484848485},{"timestamp":"2026-03-16T12:31:06","lat":47.542969972408635,"lng":1.4970503010500882,"altitud":35000,"progreso":0.8281818181818181},{"timestamp":"2026-03-16T12:31:36","lat":47.5819363621753,"lng":1.5249643645438478,"altitud":35000,"progreso":0.8327272727272728},{"timestamp":"2026-03-16T12:32:06","lat":47.62103401411819,"lng":1.5529724593487786,"altitud":35000,"progreso":0.8372727272727273},{"timestamp":"2026-03-16T12:32:36","lat":47.6600072500346,"lng":1.580891427168034,"altitud":35000,"progreso":0.8418181818181818},{"timestamp":"2026-03-16T12:33:06","lat":47.69914815679065,"lng":1.6089305081025018,"altitud":35000,"progreso":0.8463636363636363},{"timestamp":"2026-03-16T12:33:37","lat":47.738123361445666,"lng":1.636850886252422,"altitud":35000,"progreso":0.8510606060606061},{"timestamp":"2026-03-16T12:34:07","lat":47.77722633010821,"lng":1.664862789756366,"altitud":35000,"progreso":0.8556060606060606},{"timestamp":"2026-03-16T12:34:37","lat":47.81640404201783,"lng":1.6929282365255927,"altitud":35000,"progreso":0.8601515151515151},{"timestamp":"2026-03-16T12:35:07","lat":47.855558594115486,"lng":1.7209770924721783,"altitud":35000,"progreso":0.8646969696969697},{"timestamp":"2026-03-16T12:35:37","lat":47.89455231841861,"lng":1.7489107374049921,"altitud":35000,"progreso":0.8692424242424243},{"timestamp":"2026-03-16T12:36:08","lat":47.93359652361666,"lng":1.7768805449619136,"altitud":35000,"progreso":0.8739393939393939},{"timestamp":"2026-03-16T12:36:38","lat":47.97261578253319,"lng":1.8048324819362587,"altitud":35000,"progreso":0.8784848484848485},{"timestamp":"2026-03-16T12:37:08","lat":48.0115783951004,"lng":1.832743839585675,"altitud":35000,"progreso":0.883030303030303},{"timestamp":"2026-03-16T12:37:38","lat":48.05062766049609,"lng":1.860717272078833,"altitud":35000,"progreso":0.8875757575757576},{"timestamp":"2026-03-16T12:38:08","lat":48.08965757329092,"lng":1.8886768410929196,"altitud":35000,"progreso":0.8921212121212121},{"timestamp":"2026-03-16T12:38:38","lat":48.128707947565466,"lng":1.9166510679453945,"altitud":35000,"progreso":0.8966666666666666},{"timestamp":"2026-03-16T12:39:09","lat":48.167751241030174,"lng":1.9446202223706712,"altitud":34522.72727272727,"progreso":0.9013636363636364},{"timestamp":"2026-03-16T12:39:39","lat":48.20693285613644,"lng":1.97268846524392,"altitud":32931.81818181819,"progreso":0.9059090909090909},{"timestamp":"2026-03-16T12:40:09","lat":48.24594699547883,"lng":2.0006367347469225,"altitud":31340.909090909106,"progreso":0.9104545454545454},{"timestamp":"2026-03-16T12:40:39","lat":48.28504415818002,"lng":2.028644479077409,"altitud":29749.99999999999,"progreso":0.915},{"timestamp":"2026-03-16T12:41:09","lat":48.32407812332425,"lng":2.0566069510429634,"altitud":28159.090909090904,"progreso":0.9195454545454546},{"timestamp":"2026-03-16T12:41:40","lat":48.363109664380644,"lng":2.0845676864827074,"altitud":26515.15151515153,"progreso":0.9242424242424242},{"timestamp":"2026-03-16T12:42:10","lat":48.402082287257294,"lng":2.1124862151432127,"altitud":24924.24242424241,"progreso":0.9287878787878788},{"timestamp":"2026-03-16T12:42:40","lat":48.44118128235104,"lng":2.1404952721311568,"altitud":23333.33333333333,"progreso":0.9333333333333333},{"timestamp":"2026-03-16T12:43:10","lat":48.480294203628205,"lng":2.168514305315783,"altitud":21742.424242424247,"progreso":0.9378787878787879},{"timestamp":"2026-03-16T12:43:40","lat":48.519318103872834,"lng":2.196469567163897,"altitud":20151.515151515167,"progreso":0.9424242424242424},{"timestamp":"2026-03-16T12:44:11","lat":48.55844601053782,"lng":2.224499335319597,"altitud":18507.57575757575,"progreso":0.9471212121212121},{"timestamp":"2026-03-16T12:44:41","lat":48.59747807278798,"lng":2.2524604441230465,"altitud":16916.666666666668,"progreso":0.9516666666666667},{"timestamp":"2026-03-16T12:45:11","lat":48.63659720130301,"lng":2.280483923940604,"altitud":15325.757575757587,"progreso":0.9562121212121212},{"timestamp":"2026-03-16T12:45:41","lat":48.67564305481351,"lng":2.3084549122868894,"altitud":13734.848484848466,"progreso":0.9607575757575758},{"timestamp":"2026-03-16T12:46:11","lat":48.71473472150128,"lng":2.336458719479022,"altitud":12143.939393939385,"progreso":0.9653030303030303},{"timestamp":"2026-03-16T12:46:42","lat":48.75377099249777,"lng":2.364422843270851,"altitud":10500.00000000001,"progreso":0.97},{"timestamp":"2026-03-16T12:47:12","lat":48.7929032860386,"lng":2.3924557540202485,"altitud":8909.090909090928,"progreso":0.9745454545454545},{"timestamp":"2026-03-16T12:47:42","lat":48.83196346325757,"lng":2.420437003335284,"altitud":7318.181818181807,"progreso":0.9790909090909091},{"timestamp":"2026-03-16T12:48:12","lat":48.87099777068988,"lng":2.4483997205032124,"altitud":5727.272727272725,"progreso":0.9836363636363636},{"timestamp":"2026-03-16T12:48:42","lat":48.91007531974058,"lng":2.4763934143484323,"altitud":4136.363636363643,"progreso":0.9881818181818182},{"timestamp":"2026-03-16T12:49:13","lat":48.94910511054839,"lng":2.504352895975581,"altitud":2492.4242424242293,"progreso":0.9928787878787879}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (23, N'IB3562', 1, 13, 9, CAST(N'2026-03-16T09:45:00.000' AS DateTime), CAST(N'2026-03-16T12:10:00.000' AS DateTime), 7, N'', 220, 204, 204, N'[{"timestamp":"2026-03-16T10:58:59","lat":43.10391316400572,"lng":2.705357457570346,"altitud":35000,"progreso":0.5101149425287357},{"timestamp":"2026-03-16T10:59:29","lat":43.121971452315336,"lng":2.7484021119650532,"altitud":35000,"progreso":0.5136781609195402},{"timestamp":"2026-03-16T10:59:59","lat":43.13981672746167,"lng":2.790939017350675,"altitud":35000,"progreso":0.5171264367816092},{"timestamp":"2026-03-16T11:00:29","lat":43.15769681260981,"lng":2.833558897626904,"altitud":35000,"progreso":0.5205747126436782},{"timestamp":"2026-03-16T11:00:59","lat":43.17556798563423,"lng":2.876157534511823,"altitud":35000,"progreso":0.5240229885057471},{"timestamp":"2026-03-16T11:01:29","lat":43.19343735721203,"lng":2.91875187737693,"altitud":35000,"progreso":0.5274712643678161},{"timestamp":"2026-03-16T11:01:59","lat":43.211299588405865,"lng":2.9613292000597045,"altitud":35000,"progreso":0.5309195402298851},{"timestamp":"2026-03-16T11:02:30","lat":43.22922052265052,"lng":3.004046450319844,"altitud":35000,"progreso":0.5344827586206896},{"timestamp":"2026-03-16T11:03:00","lat":43.24710190719307,"lng":3.0466694278986677,"altitud":35000,"progreso":0.5379310344827586},{"timestamp":"2026-03-16T11:03:30","lat":43.26496867357817,"lng":3.089257560893977,"altitud":35000,"progreso":0.5413793103448276},{"timestamp":"2026-03-16T11:04:00","lat":43.28282879765876,"lng":3.1318298609544546,"altitud":35000,"progreso":0.5448275862068965},{"timestamp":"2026-03-16T11:04:30","lat":43.300709294374684,"lng":3.1744507222646035,"altitud":35000,"progreso":0.5482758620689655},{"timestamp":"2026-03-16T11:05:00","lat":43.31857293738658,"lng":3.2170314102286937,"altitud":35000,"progreso":0.5517241379310345},{"timestamp":"2026-03-16T11:05:30","lat":43.33644991926257,"lng":3.259643893387621,"altitud":35000,"progreso":0.5551724137931034},{"timestamp":"2026-03-16T11:06:01","lat":43.35432447904936,"lng":3.302250603131546,"altitud":35000,"progreso":0.5587356321839081},{"timestamp":"2026-03-16T11:06:31","lat":43.37221249439315,"lng":3.3448893862254363,"altitud":35000,"progreso":0.5621839080459771},{"timestamp":"2026-03-16T11:07:01","lat":43.39006338977311,"lng":3.387439688285744,"altitud":35000,"progreso":0.5656321839080459},{"timestamp":"2026-03-16T11:07:31","lat":43.40794745321225,"lng":3.430069051418729,"altitud":35000,"progreso":0.5690804597701149},{"timestamp":"2026-03-16T11:08:01","lat":43.42582128781908,"lng":3.472674032586824,"altitud":35000,"progreso":0.5725287356321839},{"timestamp":"2026-03-16T11:08:31","lat":43.44371728488603,"lng":3.515331841321959,"altitud":35000,"progreso":0.5759770114942528},{"timestamp":"2026-03-16T11:09:02","lat":43.46160046915565,"lng":3.5579591088217604,"altitud":35000,"progreso":0.5795402298850575},{"timestamp":"2026-03-16T11:09:32","lat":43.47949129378612,"lng":3.600604588274251,"altitud":35000,"progreso":0.5829885057471265},{"timestamp":"2026-03-16T11:10:02","lat":43.497393865383195,"lng":3.643278068393751,"altitud":35000,"progreso":0.5864367816091954},{"timestamp":"2026-03-16T11:10:32","lat":43.515268127033856,"lng":3.6858840674852424,"altitud":35000,"progreso":0.5898850574712644},{"timestamp":"2026-03-16T11:11:02","lat":43.533147251066545,"lng":3.7285016567978055,"altitud":35000,"progreso":0.5933333333333334},{"timestamp":"2026-03-16T11:11:32","lat":43.551044639791186,"lng":3.7711627827590015,"altitud":35000,"progreso":0.5967816091954024},{"timestamp":"2026-03-16T11:12:03","lat":43.56894028286596,"lng":3.8138197477003737,"altitud":35000,"progreso":0.6003448275862069},{"timestamp":"2026-03-16T11:12:33","lat":43.58681034742643,"lng":3.85641574239424,"altitud":35000,"progreso":0.6037931034482759},{"timestamp":"2026-03-16T11:13:03","lat":43.60470789138584,"lng":3.8990772383809085,"altitud":35000,"progreso":0.6072413793103448},{"timestamp":"2026-03-16T11:13:33","lat":43.622597833882025,"lng":3.941720615133264,"altitud":35000,"progreso":0.6106896551724138},{"timestamp":"2026-03-16T11:14:03","lat":43.640566340228446,"lng":3.9845512606745097,"altitud":35000,"progreso":0.6141379310344828},{"timestamp":"2026-03-16T11:14:33","lat":43.65842595371831,"lng":4.027122343664956,"altitud":35000,"progreso":0.6175862068965517},{"timestamp":"2026-03-16T11:15:04","lat":43.67628519631687,"lng":4.069692542580032,"altitud":35000,"progreso":0.6211494252873563},{"timestamp":"2026-03-16T11:15:34","lat":43.694229883318165,"lng":4.1124664111188824,"altitud":35000,"progreso":0.6245977011494253},{"timestamp":"2026-03-16T11:18:36","lat":43.80228293150025,"lng":4.370027151956975,"altitud":35000,"progreso":0.6455172413793103},{"timestamp":"2026-03-16T11:19:07","lat":43.820339231049786,"lng":4.413067065842007,"altitud":35000,"progreso":0.649080459770115},{"timestamp":"2026-03-16T11:19:37","lat":43.838243531516206,"lng":4.4557446669823975,"altitud":35000,"progreso":0.6525287356321839},{"timestamp":"2026-03-16T11:20:07","lat":43.856111101291596,"lng":4.498334714979661,"altitud":35000,"progreso":0.6559770114942529},{"timestamp":"2026-03-16T11:20:37","lat":43.874128805732,"lng":4.541282631599756,"altitud":35000,"progreso":0.6594252873563219},{"timestamp":"2026-03-16T11:21:07","lat":43.891994405128806,"lng":4.583867982902431,"altitud":35000,"progreso":0.6628735632183909},{"timestamp":"2026-03-16T11:21:38","lat":43.90989468917743,"lng":4.626536010305095,"altitud":35000,"progreso":0.6664367816091954},{"timestamp":"2026-03-16T11:22:08","lat":43.927799445801604,"lng":4.669214698766325,"altitud":35000,"progreso":0.6698850574712644},{"timestamp":"2026-03-16T11:22:38","lat":43.94569305374747,"lng":4.711866812670934,"altitud":35000,"progreso":0.6733333333333333},{"timestamp":"2026-03-16T11:23:08","lat":43.96359855535619,"lng":4.754547276915213,"altitud":35000,"progreso":0.6767816091954023},{"timestamp":"2026-03-16T11:23:38","lat":43.981493396582344,"lng":4.7972023305294424,"altitud":35000,"progreso":0.6802298850574713},{"timestamp":"2026-03-16T11:24:09","lat":43.999418539716935,"lng":4.8399296133136644,"altitud":35000,"progreso":0.6837931034482758},{"timestamp":"2026-03-16T11:24:39","lat":44.017316019756144,"lng":4.882590956936902,"altitud":35000,"progreso":0.6872413793103448},{"timestamp":"2026-03-16T11:25:09","lat":44.03518931554775,"lng":4.925194653757609,"altitud":35000,"progreso":0.6906896551724138},{"timestamp":"2026-03-16T11:25:39","lat":44.053094107867615,"lng":4.967873427304909,"altitud":35000,"progreso":0.6941379310344827},{"timestamp":"2026-03-16T11:26:09","lat":44.071071695921944,"lng":5.010725720466972,"altitud":35000,"progreso":0.6975862068965517},{"timestamp":"2026-03-16T11:26:40","lat":44.088953415304324,"lng":5.053349496187064,"altitud":35000,"progreso":0.7011494252873564},{"timestamp":"2026-03-16T11:27:10","lat":44.10682874112545,"lng":5.095958031889381,"altitud":35000,"progreso":0.7045977011494253},{"timestamp":"2026-03-16T11:27:40","lat":44.124735967808626,"lng":5.138642608108853,"altitud":35000,"progreso":0.7080459770114943},{"timestamp":"2026-03-16T11:28:10","lat":44.14260259336769,"lng":5.181230405424065,"altitud":35000,"progreso":0.7114942528735633},{"timestamp":"2026-03-16T11:28:40","lat":44.160551572687226,"lng":5.224014505350954,"altitud":35000,"progreso":0.7149425287356321},{"timestamp":"2026-03-16T11:29:10","lat":44.178454791609695,"lng":5.266689528468195,"altitud":35000,"progreso":0.7183908045977011},{"timestamp":"2026-03-16T11:29:41","lat":44.19634424082935,"lng":5.309331729421505,"altitud":35000,"progreso":0.7219540229885058},{"timestamp":"2026-03-16T11:30:11","lat":44.21424886540318,"lng":5.352010103120806,"altitud":35000,"progreso":0.7254022988505747},{"timestamp":"2026-03-16T11:30:41","lat":44.23215974034043,"lng":5.394703375504223,"altitud":35000,"progreso":0.7288505747126437},{"timestamp":"2026-03-16T11:31:11","lat":44.25005141010499,"lng":5.437350869461316,"altitud":35000,"progreso":0.7322988505747127},{"timestamp":"2026-03-16T11:31:41","lat":44.267930684866,"lng":5.479968818057589,"altitud":35000,"progreso":0.7357471264367816},{"timestamp":"2026-03-16T11:32:12","lat":44.28582410751445,"lng":5.522620490277859,"altitud":35000,"progreso":0.7393103448275862},{"timestamp":"2026-03-16T11:32:42","lat":44.30372404865909,"lng":5.565287700317153,"altitud":35000,"progreso":0.7427586206896551},{"timestamp":"2026-03-16T11:33:12","lat":44.32161809349178,"lng":5.607940855607431,"altitud":35000,"progreso":0.7462068965517241},{"timestamp":"2026-03-16T11:33:42","lat":44.33949120890747,"lng":5.6505441224749315,"altitud":35000,"progreso":0.7496551724137931},{"timestamp":"2026-03-16T11:34:12","lat":44.35740282295904,"lng":5.693239156648842,"altitud":35000,"progreso":0.7531034482758621},{"timestamp":"2026-03-16T11:34:42","lat":44.37529617142923,"lng":5.735890652054039,"altitud":35000,"progreso":0.756551724137931},{"timestamp":"2026-03-16T11:35:13","lat":44.39318527080736,"lng":5.778532019107317,"altitud":35000,"progreso":0.7601149425287357},{"timestamp":"2026-03-16T11:35:45","lat":44.41236811091767,"lng":5.824257212364834,"altitud":35000,"progreso":0.7637931034482759},{"timestamp":"2026-03-16T11:36:16","lat":44.43058408323506,"lng":5.867677730379711,"altitud":35000,"progreso":0.7673563218390804},{"timestamp":"2026-03-16T11:36:46","lat":44.44849999345905,"lng":5.910383005128695,"altitud":35000,"progreso":0.7708045977011494},{"timestamp":"2026-03-16T11:37:16","lat":44.46641482457021,"lng":5.953085707649425,"altitud":35000,"progreso":0.7742528735632184},{"timestamp":"2026-03-16T11:37:46","lat":44.48432264438299,"lng":5.9957716976828,"altitud":35000,"progreso":0.7777011494252873},{"timestamp":"2026-03-16T11:38:17","lat":44.50222441484299,"lng":6.038443268171228,"altitud":35000,"progreso":0.781264367816092},{"timestamp":"2026-03-16T11:38:47","lat":44.52015576529271,"lng":6.081185347027461,"altitud":35000,"progreso":0.784712643678161},{"timestamp":"2026-03-16T11:39:17","lat":44.538076041894605,"lng":6.12390102969688,"altitud":35000,"progreso":0.7881609195402299},{"timestamp":"2026-03-16T11:39:47","lat":44.55608478517419,"lng":6.166827586038318,"altitud":35000,"progreso":0.7916091954022989},{"timestamp":"2026-03-16T11:40:18","lat":44.574038625571255,"lng":6.209623273076824,"altitud":35000,"progreso":0.7951724137931034},{"timestamp":"2026-03-16T11:40:48","lat":44.591958805640616,"lng":6.25233872564637,"altitud":35000,"progreso":0.7986206896551724},{"timestamp":"2026-03-16T11:41:18","lat":44.60986355070224,"lng":6.295017386546494,"altitud":35000,"progreso":0.8020689655172414},{"timestamp":"2026-03-16T11:41:48","lat":44.62776577091613,"lng":6.337690029091151,"altitud":35000,"progreso":0.8055172413793104},{"timestamp":"2026-03-16T11:42:18","lat":44.645687450678984,"lng":6.380409056406393,"altitud":35000,"progreso":0.8089655172413793},{"timestamp":"2026-03-16T11:42:49","lat":44.66357500114862,"lng":6.423046731402614,"altitud":35000,"progreso":0.8125287356321839},{"timestamp":"2026-03-16T11:43:17","lat":44.680501567922484,"lng":6.4633937567893796,"altitud":35000,"progreso":0.8157471264367816},{"timestamp":"2026-03-16T11:43:48","lat":44.69849494853443,"lng":6.506283693894964,"altitud":35000,"progreso":0.8193103448275862},{"timestamp":"2026-03-16T11:44:18","lat":44.716465483843066,"lng":6.549119175773717,"altitud":35000,"progreso":0.8227586206896552},{"timestamp":"2026-03-16T11:44:48","lat":44.734376714314166,"lng":6.591813295625711,"altitud":35000,"progreso":0.8262068965517242},{"timestamp":"2026-03-16T11:45:18","lat":44.752287403538936,"lng":6.634506125335415,"altitud":35000,"progreso":0.829655172413793},{"timestamp":"2026-03-16T11:45:48","lat":44.77017350726567,"lng":6.677140351801658,"altitud":35000,"progreso":0.833103448275862},{"timestamp":"2026-03-16T11:46:19","lat":44.788094645011356,"lng":6.719858087137206,"altitud":35000,"progreso":0.8366666666666667},{"timestamp":"2026-03-16T11:46:49","lat":44.80604322373271,"lng":6.762641232177888,"altitud":35000,"progreso":0.8401149425287356},{"timestamp":"2026-03-16T11:47:23","lat":44.826274590397695,"lng":6.810865746655443,"altitud":35000,"progreso":0.8440229885057471},{"timestamp":"2026-03-16T11:47:53","lat":44.8442905420135,"lng":6.853809485153697,"altitud":35000,"progreso":0.8474712643678161},{"timestamp":"2026-03-16T11:48:24","lat":44.8621931612246,"lng":6.896483078768407,"altitud":35000,"progreso":0.8510344827586207},{"timestamp":"2026-03-16T11:48:54","lat":44.880119246440884,"lng":6.939212607146478,"altitud":35000,"progreso":0.8544827586206897},{"timestamp":"2026-03-16T11:49:24","lat":44.8981186902214,"lng":6.982116996728994,"altitud":35000,"progreso":0.8579310344827586},{"timestamp":"2026-03-16T11:49:54","lat":44.916041654969945,"lng":7.024839087001457,"altitud":35000,"progreso":0.8613793103448276},{"timestamp":"2026-03-16T11:50:25","lat":44.93394505664014,"lng":7.067514545725457,"altitud":35000,"progreso":0.8649425287356322},{"timestamp":"2026-03-16T11:50:55","lat":44.951883686876755,"lng":7.110273977051987,"altitud":35000,"progreso":0.8683908045977011},{"timestamp":"2026-03-16T11:51:25","lat":44.969776331157476,"lng":7.152923793915356,"altitud":35000,"progreso":0.8718390804597701},{"timestamp":"2026-03-16T11:51:40","lat":44.97829589005087,"lng":7.173231447767915,"altitud":35000,"progreso":0.873448275862069},{"timestamp":"2026-03-16T11:52:10","lat":44.996386081357166,"lng":7.216352147767983,"altitud":35000,"progreso":0.8770114942528736},{"timestamp":"2026-03-16T11:52:40","lat":45.01430454595789,"lng":7.259063511259251,"altitud":35000,"progreso":0.8804597701149425},{"timestamp":"2026-03-16T11:53:10","lat":45.03224027476314,"lng":7.301816026586396,"altitud":35000,"progreso":0.8839080459770114},{"timestamp":"2026-03-16T11:53:41","lat":45.05014376792578,"lng":7.344491703396457,"altitud":35000,"progreso":0.8874712643678161},{"timestamp":"2026-03-16T11:54:11","lat":45.06808617194436,"lng":7.387260130101572,"altitud":35000,"progreso":0.8909195402298851},{"timestamp":"2026-03-16T11:54:41","lat":45.085996729000186,"lng":7.429952644766674,"altitud":35000,"progreso":0.894367816091954},{"timestamp":"2026-03-16T11:55:11","lat":45.10396331050672,"lng":7.4727787021616745,"altitud":35000,"progreso":0.897816091954023},{"timestamp":"2026-03-16T11:55:42","lat":45.12187053873157,"lng":7.515463282055961,"altitud":34517.24137931036,"progreso":0.9013793103448275},{"timestamp":"2026-03-16T11:56:12","lat":45.13979154887405,"lng":7.558180713230005,"altitud":33310.34482758622,"progreso":0.9048275862068965},{"timestamp":"2026-03-16T11:56:42","lat":45.15770613468108,"lng":7.60088283103134,"altitud":32103.44827586208,"progreso":0.9082758620689655},{"timestamp":"2026-03-16T11:57:12","lat":45.17561793936663,"lng":7.643578319610098,"altitud":30896.55172413794,"progreso":0.9117241379310345},{"timestamp":"2026-03-16T11:57:42","lat":45.193519638375946,"lng":7.686249719785044,"altitud":29689.655172413797,"progreso":0.9151724137931034},{"timestamp":"2026-03-16T11:58:13","lat":45.2114106818649,"lng":7.728895720919741,"altitud":28442.52873563217,"progreso":0.9187356321839081},{"timestamp":"2026-03-16T11:58:43","lat":45.22942085807162,"lng":7.771825692859174,"altitud":27235.63218390803,"progreso":0.922183908045977},{"timestamp":"2026-03-16T11:59:13","lat":45.24729910945725,"lng":7.814441202085845,"altitud":26028.735632183892,"progreso":0.925632183908046},{"timestamp":"2026-03-16T11:59:43","lat":45.26519801020879,"lng":7.857105932191246,"altitud":24821.83908045975,"progreso":0.929080459770115},{"timestamp":"2026-03-16T12:00:13","lat":45.2831090182637,"lng":7.899799521880693,"altitud":23614.94252873565,"progreso":0.9325287356321839},{"timestamp":"2026-03-16T12:00:44","lat":45.30104180152196,"lng":7.942545016052247,"altitud":22367.816091954024,"progreso":0.9360919540229885},{"timestamp":"2026-03-16T12:01:14","lat":45.31894942738024,"lng":7.985230543765789,"altitud":21160.919540229883,"progreso":0.9395402298850575},{"timestamp":"2026-03-16T12:01:44","lat":45.33688223370432,"lng":8.027976092918207,"altitud":19954.02298850574,"progreso":0.9429885057471264},{"timestamp":"2026-03-16T12:02:14","lat":45.354759660649876,"lng":8.070589636967583,"altitud":18747.126436781604,"progreso":0.9464367816091954},{"timestamp":"2026-03-16T12:02:44","lat":45.37266386499882,"lng":8.113267008997472,"altitud":17540.229885057463,"progreso":0.9498850574712644},{"timestamp":"2026-03-16T12:03:15","lat":45.390544413657324,"lng":8.155887994120576,"altitud":16293.103448275875,"progreso":0.9534482758620689},{"timestamp":"2026-03-16T12:03:45","lat":45.40841511996945,"lng":8.198485518526313,"altitud":15086.206896551736,"progreso":0.9568965517241379},{"timestamp":"2026-03-16T12:04:15","lat":45.42631517561306,"lng":8.241153001491195,"altitud":13879.310344827594,"progreso":0.9603448275862069},{"timestamp":"2026-03-16T12:04:45","lat":45.44422693944424,"lng":8.28384839268739,"altitud":12672.413793103455,"progreso":0.9637931034482758},{"timestamp":"2026-03-16T12:05:15","lat":45.46217109593164,"lng":8.32662099666631,"altitud":11465.517241379313,"progreso":0.9672413793103448},{"timestamp":"2026-03-16T12:05:46","lat":45.480055840257236,"lng":8.3692519827949,"altitud":10218.390804597688,"progreso":0.9708045977011495},{"timestamp":"2026-03-16T12:06:16","lat":45.498149041149304,"lng":8.412379856596667,"altitud":9011.494252873548,"progreso":0.9742528735632184},{"timestamp":"2026-03-16T12:06:46","lat":45.516101307733905,"lng":8.455171792215742,"altitud":7804.597701149407,"progreso":0.9777011494252874},{"timestamp":"2026-03-16T12:07:17","lat":45.534116417417565,"lng":8.498113523841699,"altitud":6557.47126436782,"progreso":0.9812643678160919},{"timestamp":"2026-03-16T12:07:47","lat":45.55200394624446,"lng":8.540751147249187,"altitud":5350.57471264368,"progreso":0.9847126436781609},{"timestamp":"2026-03-16T12:08:18","lat":45.570105771263584,"lng":8.5838995779588,"altitud":4143.67816091954,"progreso":0.9881609195402299},{"timestamp":"2026-03-16T12:08:48","lat":45.588140610348546,"lng":8.626888337589078,"altitud":2896.5517241379134,"progreso":0.9917241379310345},{"timestamp":"2026-03-16T12:09:18","lat":45.60606618100133,"lng":8.66961663942741,"altitud":1689.6551724138121,"progreso":0.9951724137931034},{"timestamp":"2026-03-16T12:09:49","lat":45.62410828718403,"lng":8.712622721281443,"altitud":442.5287356321861,"progreso":0.998735632183908}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (24, N'IB6262', 1, 16, 17, CAST(N'2026-03-16T06:00:00.000' AS DateTime), CAST(N'2026-03-16T14:10:00.000' AS DateTime), 6, N'', 348, 321, 321, N'[{"timestamp":"2026-03-16T10:58:59","lat":31.51713854861554,"lng":-50.37926156454441,"altitud":35000,"progreso":0.6101360544217687},{"timestamp":"2026-03-16T10:59:29","lat":31.501935894173567,"lng":-50.45873298083551,"altitud":35000,"progreso":0.6111904761904762},{"timestamp":"2026-03-16T10:59:59","lat":31.486912568218187,"lng":-50.53726696288673,"altitud":35000,"progreso":0.6122108843537415},{"timestamp":"2026-03-16T11:00:29","lat":31.47185993691451,"lng":-50.615954137759836,"altitud":35000,"progreso":0.6132312925170068},{"timestamp":"2026-03-16T11:00:59","lat":31.45681480842255,"lng":-50.69460209191161,"altitud":35000,"progreso":0.6142517006802721},{"timestamp":"2026-03-16T11:01:29","lat":31.441771196506807,"lng":-50.77324211820707,"altitud":35000,"progreso":0.6152721088435374},{"timestamp":"2026-03-16T11:01:59","lat":31.42673359583577,"lng":-50.85185072090266,"altitud":35000,"progreso":0.6162925170068028},{"timestamp":"2026-03-16T11:02:30","lat":31.411646575076787,"lng":-50.930717665613265,"altitud":35000,"progreso":0.6173469387755102},{"timestamp":"2026-03-16T11:03:00","lat":31.39659284985746,"lng":-51.009410558897336,"altitud":35000,"progreso":0.6183673469387755},{"timestamp":"2026-03-16T11:03:30","lat":31.381551431164223,"lng":-51.08803912018848,"altitud":35000,"progreso":0.6193877551020408},{"timestamp":"2026-03-16T11:04:00","lat":31.36651560439966,"lng":-51.166638449841635,"altitud":35000,"progreso":0.6204081632653061},{"timestamp":"2026-03-16T11:04:30","lat":31.351462626611152,"lng":-51.2453274359537,"altitud":35000,"progreso":0.6214285714285714},{"timestamp":"2026-03-16T11:05:00","lat":31.336423837378845,"lng":-51.323942251817364,"altitud":35000,"progreso":0.6224489795918368},{"timestamp":"2026-03-16T11:05:30","lat":31.3213738186137,"lng":-51.40261576972431,"altitud":35000,"progreso":0.6234693877551021},{"timestamp":"2026-03-16T11:06:01","lat":31.306325838922497,"lng":-51.48127862843388,"altitud":35000,"progreso":0.6245238095238095},{"timestamp":"2026-03-16T11:06:31","lat":31.291266531458703,"lng":-51.56000070273207,"altitud":35000,"progreso":0.6255442176870748},{"timestamp":"2026-03-16T11:07:01","lat":31.276238474021127,"lng":-51.63855941846338,"altitud":35000,"progreso":0.6265646258503401},{"timestamp":"2026-03-16T11:07:31","lat":31.261182493530505,"lng":-51.717264101109926,"altitud":35000,"progreso":0.6275850340136054},{"timestamp":"2026-03-16T11:08:01","lat":31.24613512434348,"lng":-51.79592376842741,"altitud":35000,"progreso":0.6286054421768708},{"timestamp":"2026-03-16T11:08:31","lat":31.231069097340324,"lng":-51.87468096891436,"altitud":35000,"progreso":0.6296258503401361},{"timestamp":"2026-03-16T11:09:02","lat":31.21601385699242,"lng":-51.95338178248728,"altitud":35000,"progreso":0.6306802721088436},{"timestamp":"2026-03-16T11:09:32","lat":31.200952184486386,"lng":-52.03211621997223,"altitud":35000,"progreso":0.6317006802721088},{"timestamp":"2026-03-16T11:10:02","lat":31.185880622611492,"lng":-52.1109023538338,"altitud":35000,"progreso":0.6327210884353741},{"timestamp":"2026-03-16T11:10:32","lat":31.170832893910887,"lng":-52.18956390049763,"altitud":35000,"progreso":0.6337414965986394},{"timestamp":"2026-03-16T11:11:02","lat":31.15578107173739,"lng":-52.26824684566719,"altitud":35000,"progreso":0.6347619047619047}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (25, N'IB3104', 1, 4, 4, CAST(N'2026-03-16T13:12:00.000' AS DateTime), CAST(N'2026-03-16T13:39:00.000' AS DateTime), 7, N'23', 180, 23, 23, N'[{"timestamp":"2026-03-16T11:12:33","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:13:03","lat":40.43112648407195,"lng":-3.5122945379704165,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:13:33","lat":40.39034429655614,"lng":-3.456231897040483,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:14:03","lat":40.34938301368141,"lng":-3.3999230564971885,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:14:33","lat":40.30866996463395,"lng":-3.3439554591478533,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:15:04","lat":40.267957761076,"lng":-3.287989024079838,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:15:34","lat":40.227050777146026,"lng":-3.2317548274540924,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:18:36","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:19:07","lat":40.43076458239188,"lng":-3.511797037341401,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:19:37","lat":40.38994966422674,"lng":-3.45568940209527,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:20:07","lat":40.349218477908664,"lng":-3.3996968717211993,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:20:37","lat":40.30814504230374,"lng":-3.3432338565584057,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:21:07","lat":40.26741834769091,"lng":-3.287247500861912,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:21:38","lat":40.22661258541344,"lng":-3.231152452072608,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:22:08","lat":40.185796627384065,"lng":-3.1750433873412347,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:22:38","lat":40.1450060840529,"lng":-3.118969259801497,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:23:08","lat":40.10418842774532,"lng":-3.062857860473401,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:23:38","lat":40.06339507300948,"lng":-3.0067798681392333,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:24:09","lat":40.02253264157806,"lng":-2.950606917142542,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:24:39","lat":39.98173327136347,"lng":-2.8945206554229923,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:25:09","lat":39.94098903193095,"lng":-2.8385101811348594,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:25:39","lat":39.90017299252912,"lng":-2.7824010045420384,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:26:09","lat":39.85919100685366,"lng":-2.7260637041795324,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:26:40","lat":39.8184275648743,"lng":-2.670026832447946,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:27:10","lat":39.77767869775531,"lng":-2.6140099965509798,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:27:40","lat":39.736857108941535,"lng":-2.55789319126758,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:28:10","lat":39.69612807507349,"lng":-2.501903619833194,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:28:40","lat":39.65521130630898,"lng":-2.445655972147108,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:29:10","lat":39.61439885364801,"lng":-2.389551726191347,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:29:41","lat":39.573617790612964,"lng":-2.333490631067696,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:30:11","lat":39.53280213360759,"lng":-2.2773819801493516,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:30:41","lat":39.49197222817783,"lng":-2.221253742142892,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:31:11","lat":39.45118610315451,"lng":-2.165185688382449,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:31:41","lat":39.410428233971544,"lng":-2.109156477487671,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:32:12","lat":39.36963811304721,"lng":-2.0530829306240523,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:32:42","lat":39.32883313245892,"lng":-1.9969889564107468,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:33:12","lat":39.28804159319383,"lng":-1.9409134597760833,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:33:42","lat":39.24729776494902,"lng":-1.8849035507413119,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:34:12","lat":39.206466174622896,"lng":-1.828772996533949,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:34:42","lat":39.16567622279646,"lng":-1.772699682126594,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:35:13","lat":39.12489595726551,"lng":-1.716639683319455,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:35:45","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:36:16","lat":40.430400589899385,"lng":-3.51129666250496,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:36:46","lat":40.389559205952665,"lng":-3.4551526451591927,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:37:16","lat":40.34872028196815,"lng":-3.399012009485326,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:37:46","lat":40.307897341047,"lng":-3.3428933454808964,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:38:17","lat":40.26708819032333,"lng":-3.2867936386471297,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:38:47","lat":40.22621160860106,"lng":-3.2306012354649987,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:39:17","lat":40.18536027099225,"lng":-3.1744435349742592,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:39:47","lat":40.14430726338707,"lng":-3.1180086018660216,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:40:18","lat":40.10337941323561,"lng":-3.061745720769088,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:40:48","lat":40.062528295683855,"lng":-3.0055883227873794,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:41:18","lat":40.021712364012664,"lng":-2.949479294290196,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:41:48","lat":39.98090218802313,"lng":-2.8933781780393533,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:42:18","lat":39.94004765174705,"lng":-2.837216080390318,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:42:49","lat":39.89927091713167,"lng":-2.7811609354780833,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:43:17","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:43:48","lat":40.43090801336776,"lng":-3.51199420968033,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:44:18","lat":40.38994210523965,"lng":-3.4556790108728968,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:44:48","lat":40.34911138932945,"lng":-3.399549658711554,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:45:18","lat":40.308281907252706,"lng":-3.3434220026819275,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:45:48","lat":40.267508470654676,"lng":-3.2873713915030125,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:46:19","lat":40.22665516996926,"lng":-3.2312109924013055,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:46:49","lat":40.185739314414526,"lng":-3.174964600090534,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:47:23","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:47:53","lat":40.430856560160926,"lng":-3.5119234777545665,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:48:24","lat":40.39004547461121,"lng":-3.4558211111454504,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:48:54","lat":40.349180895595886,"lng":-3.399645207898463,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:49:24","lat":40.30814908727153,"lng":-3.34323941711292,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:49:54","lat":40.26729162172237,"lng":-3.2870732926375896,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:50:25","lat":40.226478752466896,"lng":-3.230968473995813,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:50:55","lat":40.18558557563066,"lng":-3.1747532577677746,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:51:25","lat":40.14479722908535,"lng":-3.1186821501154878,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:51:40","lat":40.471926,"lng":-3.568381,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:52:10","lat":40.430687322222944,"lng":-3.5116908289849307,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:52:40","lat":40.38984011527982,"lng":-3.4555388068562762,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:53:10","lat":40.348953552591084,"lng":-3.3993326829942685,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:53:41","lat":40.30814047476801,"lng":-3.343227577637852,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:54:11","lat":40.26723869516051,"lng":-3.287000535313523,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:54:41","lat":40.226409514378105,"lng":-3.2308732934685587,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:55:11","lat":40.185452619397935,"lng":-3.1745704848958782,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:55:42","lat":40.14463102706973,"lng":-3.1184536747812532,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:56:12","lat":40.10377801727056,"lng":-3.0622936755563486,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:56:42","lat":40.06293965248509,"lng":-3.0061538086047546,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:57:12","lat":40.02210762758682,"lng":-2.9500226569978008,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:57:42","lat":39.981298639743216,"lng":-2.8939231740727456,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:58:13","lat":39.9405139423874,"lng":-2.8378570829046756,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:58:43","lat":39.89945766825952,"lng":-2.7814176593583304,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:59:13","lat":39.85870213197878,"lng":-2.7253916554680755,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T11:59:43","lat":39.81789952308655,"lng":-2.6693009415885878,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:00:13","lat":39.77706931419972,"lng":-2.6131722864244047,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:00:44","lat":39.736189466225106,"lng":-2.5569753931757977,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:01:14","lat":39.695366967445636,"lng":-2.500857336976676,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:01:44","lat":39.65448706688982,"lng":-2.444660371445506,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:02:14","lat":39.61373341001533,"lng":-2.3886369511458936,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:02:44","lat":39.572918710961055,"lng":-2.3325296171080785,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:03:15","lat":39.532157937781825,"lng":-2.276496414134665,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:03:45","lat":39.49141960136646,"lng":-2.2204940546327037,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:04:15","lat":39.450614359764536,"lng":-2.1643997216080106,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:04:45","lat":39.40978242799853,"lng":-2.108268698028528,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:05:15","lat":39.3688766534362,"lng":-2.0520361639017377,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:05:46","lat":39.328106315749835,"lng":-1.9959898127486466,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:06:16","lat":39.28686077727486,"lng":-1.9392902104385092,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:06:46","lat":39.24593651481045,"lng":-1.8830322612793504,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:07:17","lat":39.204868994252834,"lng":-1.826577377440384,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:07:47","lat":39.164092308974574,"lng":-1.7705223003511203,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:08:18","lat":39.12282711080718,"lng":-1.7137956721666066,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:08:48","lat":39.0817146148035,"lng":-1.657278961279202,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:09:18","lat":39.04085120879504,"lng":-1.6011046705465692,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:09:49","lat":38.99972214660381,"lng":-1.5445651863779584,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:10:19","lat":38.958748594872056,"lng":-1.488239480027111,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:10:49","lat":38.9177999383795,"lng":-1.431947996775636,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:11:20","lat":38.87670554179879,"lng":-1.3754561668843874,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:11:50","lat":38.83566159843589,"lng":-1.319033694249486,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:12:20","lat":38.794902909175406,"lng":-1.2630033560068639,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:12:51","lat":38.75376518176428,"lng":-1.2064519598948054,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:13:21","lat":38.71297159075096,"lng":-1.1503736427536437,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:13:51","lat":38.6721259616494,"lng":-1.094223789659336,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:14:21","lat":38.63139870013282,"lng":-1.0382366546490371,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:14:51","lat":38.590554998828445,"lng":-0.982089451667628,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:15:21","lat":38.54976130805953,"lng":-0.9260109973939938,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:15:52","lat":38.508959395969605,"lng":-0.8699212413978317,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:16:22","lat":38.46803714713545,"lng":-0.8136660603449584,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:16:52","lat":38.427277871236356,"lng":-0.7576349156593429,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:17:22","lat":38.386451946163035,"lng":-0.7015121493871774,"altitud":0,"progreso":0},{"timestamp":"2026-03-16T12:17:52","lat":38.345660272538794,"lng":-0.645436468051054,"altitud":0,"progreso":0}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (26, N'IB3100', 1, 23, 5, CAST(N'2026-03-16T12:33:00.000' AS DateTime), CAST(N'2026-03-16T13:48:00.000' AS DateTime), 1, N'', 180, 0, 0, NULL)
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (27, N'IB3101', 1, 3, 2, CAST(N'2026-03-16T12:47:00.000' AS DateTime), CAST(N'2026-03-16T13:29:00.000' AS DateTime), 7, N'34', 180, 31, 2, N'[{"timestamp":"2026-03-16T12:48:18","lat":40.443128380408126,"lng":-3.3710047167140105,"altitud":10833.333333333334,"progreso":0.030952380952380953},{"timestamp":"2026-03-16T12:48:48","lat":40.43212429106821,"lng":-3.2955836824188043,"altitud":15000.000000000002,"progreso":0.04285714285714286},{"timestamp":"2026-03-16T12:49:19","lat":40.42109405684166,"lng":-3.2199834534323726,"altitud":19305.55555555556,"progreso":0.05515873015873016},{"timestamp":"2026-03-16T12:49:49","lat":40.41006930577367,"lng":-3.1444208055193377,"altitud":23472.22222222222,"progreso":0.06706349206349206},{"timestamp":"2026-03-16T12:50:19","lat":40.399064886428334,"lng":-3.0689975093967936,"altitud":27638.888888888887,"progreso":0.07896825396825397},{"timestamp":"2026-03-16T12:50:49","lat":40.38804377367283,"lng":-2.993459798148933,"altitud":31805.555555555555,"progreso":0.09087301587301587},{"timestamp":"2026-03-16T12:51:19","lat":40.377049043055834,"lng":-2.9181029076952316,"altitud":35000,"progreso":0.10277777777777777},{"timestamp":"2026-03-16T12:51:50","lat":40.365985836222904,"lng":-2.842276687443171,"altitud":35000,"progreso":0.11507936507936507},{"timestamp":"2026-03-16T12:52:20","lat":40.35497512749354,"lng":-2.766810284450619,"altitud":35000,"progreso":0.12698412698412698},{"timestamp":"2026-03-16T12:52:50","lat":40.34396194750305,"lng":-2.69132694365755,"altitud":35000,"progreso":0.1388888888888889},{"timestamp":"2026-03-16T12:53:20","lat":40.33295606199442,"lng":-2.6158935985842895,"altitud":35000,"progreso":0.15079365079365079},{"timestamp":"2026-03-16T12:53:50","lat":40.32192649789396,"lng":-2.540297962581534,"altitud":35000,"progreso":0.1626984126984127},{"timestamp":"2026-03-16T12:54:20","lat":40.3109170186968,"lng":-2.4648399866916124,"altitud":35000,"progreso":0.1746031746031746},{"timestamp":"2026-03-16T12:54:51","lat":40.29989048544616,"lng":-2.3892651238597544,"altitud":35000,"progreso":0.1869047619047619},{"timestamp":"2026-03-16T12:55:21","lat":40.288884397559535,"lng":-2.313830391705925,"altitud":35000,"progreso":0.1988095238095238},{"timestamp":"2026-03-16T12:55:51","lat":40.27786537489922,"lng":-2.23830700578168,"altitud":35000,"progreso":0.21071428571428572},{"timestamp":"2026-03-16T12:56:21","lat":40.266838118864776,"lng":-2.16272718905489,"altitud":35000,"progreso":0.2226190476190476},{"timestamp":"2026-03-16T12:56:51","lat":40.255824457030585,"lng":-2.087240545748627,"altitud":35000,"progreso":0.23452380952380952},{"timestamp":"2026-03-16T12:57:22","lat":40.24478265749624,"lng":-2.0115610491872915,"altitud":35000,"progreso":0.24682539682539684},{"timestamp":"2026-03-16T12:57:52","lat":40.23377083298557,"lng":-1.9360869987305023,"altitud":35000,"progreso":0.25873015873015875},{"timestamp":"2026-03-16T12:58:22","lat":40.22274291752456,"lng":-1.8605026623535992,"altitud":35000,"progreso":0.2706349206349206},{"timestamp":"2026-03-16T12:58:52","lat":40.211738848013454,"lng":-1.7850817639632557,"altitud":35000,"progreso":0.28253968253968254},{"timestamp":"2026-03-16T12:59:22","lat":40.20073115742595,"lng":-1.7096360470423526,"altitud":35000,"progreso":0.29444444444444445},{"timestamp":"2026-03-16T12:59:52","lat":40.18973355144913,"lng":-1.6342594491321283,"altitud":35000,"progreso":0.30634920634920637},{"timestamp":"2026-03-16T13:00:23","lat":40.17869240838346,"lng":-1.5585844519478043,"altitud":35000,"progreso":0.31865079365079363},{"timestamp":"2026-03-16T13:00:53","lat":40.16769982789584,"lng":-1.4832422982865858,"altitud":35000,"progreso":0.33055555555555555},{"timestamp":"2026-03-16T13:01:23","lat":40.15668020949486,"lng":-1.4077148292096142,"altitud":35000,"progreso":0.34246031746031746},{"timestamp":"2026-03-16T13:01:53","lat":40.145657372545934,"lng":-1.332165300495825,"altitud":35000,"progreso":0.3543650793650794},{"timestamp":"2026-03-16T13:02:23","lat":40.13465204717377,"lng":-1.2567357945472226,"altitud":35000,"progreso":0.36626984126984125},{"timestamp":"2026-03-16T13:02:53","lat":40.12362113062441,"lng":-1.1811308889818588,"altitud":35000,"progreso":0.37817460317460316},{"timestamp":"2026-03-16T13:03:23","lat":40.112623576063726,"lng":-1.105754643473194,"altitud":35000,"progreso":0.3900793650793651},{"timestamp":"2026-03-16T13:03:54","lat":40.10159042944896,"lng":-1.0301344532410477,"altitud":35000,"progreso":0.4023809523809524},{"timestamp":"2026-03-16T13:04:24","lat":40.09060071877057,"lng":-0.9548119689930017,"altitud":35000,"progreso":0.4142857142857143},{"timestamp":"2026-03-16T13:04:54","lat":40.0795650666416,"lng":-0.8791746061928221,"altitud":35000,"progreso":0.4261904761904762},{"timestamp":"2026-03-16T13:05:24","lat":40.06856411872542,"lng":-0.8037751029320952,"altitud":35000,"progreso":0.4380952380952381},{"timestamp":"2026-03-16T13:05:54","lat":40.057524124233446,"lng":-0.7281079779681168,"altitud":35000,"progreso":0.45},{"timestamp":"2026-03-16T13:06:24","lat":40.04651663050985,"lng":-0.6526636103347183,"altitud":35000,"progreso":0.46190476190476193},{"timestamp":"2026-03-16T13:06:55","lat":40.03550653691176,"lng":-0.5772014233963336,"altitud":35000,"progreso":0.4742063492063492},{"timestamp":"2026-03-16T13:07:25","lat":40.02450604188118,"lng":-0.5018050241726368,"altitud":35000,"progreso":0.4861111111111111},{"timestamp":"2026-03-16T13:07:55","lat":40.013506569951396,"lng":-0.4264156371893444,"altitud":35000,"progreso":0.498015873015873},{"timestamp":"2026-03-16T13:08:35","lat":39.99893150989158,"lng":-0.3265194921590715,"altitud":35000,"progreso":0.5138888888888888},{"timestamp":"2026-03-16T13:09:05","lat":39.98779824130487,"lng":-0.25021307497562173,"altitud":35000,"progreso":0.5257936507936508},{"timestamp":"2026-03-16T13:09:35","lat":39.97677425180189,"lng":-0.1746556467603999,"altitud":35000,"progreso":0.5376984126984127},{"timestamp":"2026-03-16T13:10:06","lat":39.96577392876706,"lng":-0.09926042637998744,"altitud":35000,"progreso":0.55},{"timestamp":"2026-03-16T13:10:36","lat":39.954749760914346,"lng":-0.023701775771856504,"altitud":35000,"progreso":0.5619047619047619},{"timestamp":"2026-03-16T13:11:06","lat":39.943743835711594,"lng":0.051731841361414066,"altitud":35000,"progreso":0.5738095238095238},{"timestamp":"2026-03-16T13:11:36","lat":39.932687338538486,"lng":0.12751207421111843,"altitud":35000,"progreso":0.5857142857142857},{"timestamp":"2026-03-16T13:12:06","lat":39.92168779423172,"lng":0.20290195725967441,"altitud":35000,"progreso":0.5976190476190476},{"timestamp":"2026-03-16T13:12:36","lat":39.910666813741315,"lng":0.278438761974547,"altitud":35000,"progreso":0.6095238095238096},{"timestamp":"2026-03-16T13:13:07","lat":39.89965508534377,"lng":0.3539121536806942,"altitud":35000,"progreso":0.6218253968253968},{"timestamp":"2026-03-16T13:13:37","lat":39.88862249123338,"lng":0.42952855709778825,"altitud":35000,"progreso":0.6337301587301587},{"timestamp":"2026-03-16T13:14:07","lat":39.87762854821813,"lng":0.5048800494003296,"altitud":35000,"progreso":0.6456349206349207},{"timestamp":"2026-03-16T13:14:37","lat":39.8665984424954,"lng":0.5804793976331486,"altitud":35000,"progreso":0.6575396825396825},{"timestamp":"2026-03-16T13:15:07","lat":39.85558391213748,"lng":0.6559719937225696,"altitud":35000,"progreso":0.6694444444444444},{"timestamp":"2026-03-16T13:15:37","lat":39.844575813397874,"lng":0.7314205080811358,"altitud":35000,"progreso":0.6813492063492064},{"timestamp":"2026-03-16T13:16:08","lat":39.83352221166902,"lng":0.8071808958174578,"altitud":35000,"progreso":0.6936507936507936},{"timestamp":"2026-03-16T13:16:38","lat":39.822485844790016,"lng":0.8828231574498253,"altitud":35000,"progreso":0.7055555555555556},{"timestamp":"2026-03-16T13:17:08","lat":39.81144790734522,"lng":0.9584761835982927,"altitud":35000,"progreso":0.7174603174603175},{"timestamp":"2026-03-16T13:17:38","lat":39.80043527065678,"lng":1.03395580064818,"altitud":35000,"progreso":0.7293650793650793},{"timestamp":"2026-03-16T13:18:09","lat":39.78939210720715,"lng":1.109644645361676,"altitud":35000,"progreso":0.7416666666666667},{"timestamp":"2026-03-16T13:18:39","lat":39.778390090908914,"lng":1.1850514712164535,"altitud":35000,"progreso":0.7535714285714286},{"timestamp":"2026-03-16T13:19:09","lat":39.76737315275667,"lng":1.2605605701107172,"altitud":35000,"progreso":0.7654761904761904},{"timestamp":"2026-03-16T13:19:39","lat":39.756362177671264,"lng":1.3360287986835062,"altitud":35000,"progreso":0.7773809523809524},{"timestamp":"2026-03-16T13:20:09","lat":39.74533346887532,"lng":1.4116185725063457,"altitud":35000,"progreso":0.7892857142857143},{"timestamp":"2026-03-16T13:20:41","lat":39.73374363660324,"lng":1.491054235946264,"altitud":35000,"progreso":0.801984126984127},{"timestamp":"2026-03-16T13:21:11","lat":39.7226150197893,"lng":1.5673287702994299,"altitud":35000,"progreso":0.8138888888888889},{"timestamp":"2026-03-16T13:21:42","lat":39.711610018032054,"lng":1.6427560582206024,"altitud":35000,"progreso":0.8261904761904761},{"timestamp":"2026-03-16T13:22:12","lat":39.7006110998117,"lng":1.7181416501294309,"altitud":35000,"progreso":0.8380952380952381},{"timestamp":"2026-03-16T13:22:42","lat":39.68960539619497,"lng":1.7935737485321188,"altitud":35000,"progreso":0.85},{"timestamp":"2026-03-16T13:23:12","lat":39.67860716632277,"lng":1.8689546225649578,"altitud":35000,"progreso":0.861904761904762},{"timestamp":"2026-03-16T13:23:42","lat":39.667578185583665,"lng":1.9445462602616685,"altitud":35000,"progreso":0.8738095238095238},{"timestamp":"2026-03-16T13:24:12","lat":39.65656009615545,"lng":2.0200632498973836,"altitud":35000,"progreso":0.8857142857142857},{"timestamp":"2026-03-16T13:24:41","lat":39.6461161515227,"lng":2.091645102969682,"altitud":35000,"progreso":0.8972222222222223},{"timestamp":"2026-03-16T13:25:11","lat":39.635016930497514,"lng":2.167718161242117,"altitud":31805.55555555556,"progreso":0.9091269841269841},{"timestamp":"2026-03-16T13:25:42","lat":39.623994959223985,"lng":2.243261756694993,"altitud":27500.00000000002,"progreso":0.9214285714285714},{"timestamp":"2026-03-16T13:26:00","lat":39.61716399835702,"lng":2.290080545410882,"altitud":24999.99999999999,"progreso":0.9285714285714286},{"timestamp":"2026-03-16T13:26:31","lat":39.60608743976115,"lng":2.365998277440037,"altitud":20694.44444444445,"progreso":0.9408730158730159},{"timestamp":"2026-03-16T13:27:01","lat":39.595056066272775,"lng":2.441606314824089,"altitud":16527.777777777796,"progreso":0.9527777777777777},{"timestamp":"2026-03-16T13:27:31","lat":39.5840440383251,"lng":2.517081759619719,"altitud":12361.111111111106,"progreso":0.9646825396825397},{"timestamp":"2026-03-16T13:28:01","lat":39.573019173068005,"lng":2.592645190174568,"altitud":8194.444444444454,"progreso":0.9765873015873016},{"timestamp":"2026-03-16T13:28:31","lat":39.56201192094183,"lng":2.6680879019210946,"altitud":4027.7777777777633,"progreso":0.9884920634920635}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (28, N'IB2610', 1, 2, 6, CAST(N'2026-03-16T12:47:00.000' AS DateTime), CAST(N'2026-03-16T13:18:00.000' AS DateTime), 7, N'2323', 180, 23, 2, N'[{"timestamp":"2026-03-16T12:51:19","lat":39.94153956289329,"lng":-3.6983896928141426,"altitud":35000,"progreso":0.139247311827957},{"timestamp":"2026-03-16T12:51:50","lat":39.87969340926351,"lng":-3.7135494650603027,"altitud":35000,"progreso":0.15591397849462366},{"timestamp":"2026-03-16T12:52:20","lat":39.81814073344967,"lng":-3.728637299819848,"altitud":35000,"progreso":0.17204301075268819},{"timestamp":"2026-03-16T12:52:50","lat":39.75657424265455,"lng":-3.7437285209172244,"altitud":35000,"progreso":0.1881720430107527},{"timestamp":"2026-03-16T12:53:20","lat":39.69504852987735,"lng":-3.758809746478452,"altitud":35000,"progreso":0.20430107526881722},{"timestamp":"2026-03-16T12:53:50","lat":39.63339044772021,"lng":-3.7739234185142703,"altitud":35000,"progreso":0.22043010752688172},{"timestamp":"2026-03-16T12:54:20","lat":39.571844645305596,"lng":-3.78900956846141,"altitud":35000,"progreso":0.23655913978494625},{"timestamp":"2026-03-16T12:54:51","lat":39.51020350637356,"lng":-3.8041190873620914,"altitud":35000,"progreso":0.2532258064516129},{"timestamp":"2026-03-16T12:55:21","lat":39.448676662251586,"lng":-3.8192005902393373,"altitud":35000,"progreso":0.2693548387096774},{"timestamp":"2026-03-16T12:55:51","lat":39.387077509438946,"lng":-3.834299817473195,"altitud":35000,"progreso":0.2854838709677419},{"timestamp":"2026-03-16T12:56:21","lat":39.32543232996069,"lng":-3.8494103267953776,"altitud":35000,"progreso":0.3016129032258065},{"timestamp":"2026-03-16T12:56:51","lat":39.26386314553615,"lng":-3.8645022081570755,"altitud":35000,"progreso":0.317741935483871},{"timestamp":"2026-03-16T12:57:22","lat":39.202136664176564,"lng":-3.8796326462530284,"altitud":35000,"progreso":0.33440860215053764},{"timestamp":"2026-03-16T12:57:52","lat":39.14057775086009,"lng":-3.8947220099535618,"altitud":35000,"progreso":0.35053763440860214},{"timestamp":"2026-03-16T12:58:22","lat":39.07892888501881,"lng":-3.9098334228796183,"altitud":35000,"progreso":0.36666666666666664},{"timestamp":"2026-03-16T12:58:52","lat":39.01741332413183,"lng":-3.924912160002445,"altitud":35000,"progreso":0.3827956989247312},{"timestamp":"2026-03-16T12:59:22","lat":38.95587752050232,"lng":-3.939995859040418,"altitud":35000,"progreso":0.3989247311827957},{"timestamp":"2026-03-16T12:59:52","lat":38.89439809242389,"lng":-3.955065739264051,"altitud":35000,"progreso":0.4150537634408602},{"timestamp":"2026-03-16T13:00:23","lat":38.83267528089198,"lng":-3.970195277809288,"altitud":35000,"progreso":0.43172043010752686},{"timestamp":"2026-03-16T13:00:53","lat":38.77122394658255,"lng":-3.9852582716687004,"altitud":35000,"progreso":0.4478494623655914},{"timestamp":"2026-03-16T13:01:23","lat":38.70962146342732,"lng":-4.000358315238453,"altitud":35000,"progreso":0.4639784946236559},{"timestamp":"2026-03-16T13:01:53","lat":38.648000987766544,"lng":-4.015462769143692,"altitud":35000,"progreso":0.4801075268817204},{"timestamp":"2026-03-16T13:02:23","lat":38.586478406295285,"lng":-4.030543227157028,"altitud":35000,"progreso":0.4962365591397849},{"timestamp":"2026-03-16T13:02:53","lat":38.52481276360312,"lng":-4.045658752436454,"altitud":35000,"progreso":0.5123655913978494},{"timestamp":"2026-03-16T13:03:23","lat":38.463333622954046,"lng":-4.060728562205206,"altitud":35000,"progreso":0.5284946236559139},{"timestamp":"2026-03-16T13:03:54","lat":38.40165551362637,"lng":-4.075847143315009,"altitud":35000,"progreso":0.5451612903225806},{"timestamp":"2026-03-16T13:04:24","lat":38.34022022228394,"lng":-4.09090620471118,"altitud":35000,"progreso":0.5612903225806452},{"timestamp":"2026-03-16T13:04:54","lat":38.27852810649153,"lng":-4.106028219095377,"altitud":35000,"progreso":0.5774193548387097},{"timestamp":"2026-03-16T13:05:24","lat":38.21702999611796,"lng":-4.121102678736205,"altitud":35000,"progreso":0.5935483870967742},{"timestamp":"2026-03-16T13:05:54","lat":38.15531360540654,"lng":-4.13623064340545,"altitud":35000,"progreso":0.6096774193548387},{"timestamp":"2026-03-16T13:06:24","lat":38.09377890229664,"lng":-4.151314072683291,"altitud":35000,"progreso":0.6258064516129033},{"timestamp":"2026-03-16T13:06:55","lat":38.03222966522382,"lng":-4.1664010645362435,"altitud":35000,"progreso":0.6424731182795699},{"timestamp":"2026-03-16T13:07:25","lat":37.97073408659652,"lng":-4.18147490359366,"altitud":35000,"progreso":0.6586021505376344},{"timestamp":"2026-03-16T13:07:55","lat":37.909244227364134,"lng":-4.196547340709016,"altitud":35000,"progreso":0.6747311827956989},{"timestamp":"2026-03-16T13:08:35","lat":37.82776591666861,"lng":-4.216519360966576,"altitud":35000,"progreso":0.696236559139785},{"timestamp":"2026-03-16T13:09:05","lat":37.76552809992952,"lng":-4.231775137946836,"altitud":35000,"progreso":0.7123655913978495},{"timestamp":"2026-03-16T13:09:35","lat":37.703901181196976,"lng":-4.246881171182315,"altitud":35000,"progreso":0.728494623655914},{"timestamp":"2026-03-16T13:10:06","lat":37.642406564069844,"lng":-4.261954774556143,"altitud":35000,"progreso":0.7451612903225806},{"timestamp":"2026-03-16T13:10:36","lat":37.58077864831676,"lng":-4.277061052181992,"altitud":35000,"progreso":0.7612903225806451},{"timestamp":"2026-03-16T13:11:06","lat":37.519252713639204,"lng":-4.2921423321355885,"altitud":35000,"progreso":0.7774193548387097},{"timestamp":"2026-03-16T13:11:36","lat":37.45744406872266,"lng":-4.30729291021984,"altitud":35000,"progreso":0.7935483870967742},{"timestamp":"2026-03-16T13:12:06","lat":37.39595380488447,"lng":-4.3223654465124515,"altitud":35000,"progreso":0.8096774193548387},{"timestamp":"2026-03-16T13:12:36","lat":37.334343707301215,"lng":-4.337467356536102,"altitud":35000,"progreso":0.8258064516129032},{"timestamp":"2026-03-16T13:13:07","lat":37.27278533128165,"lng":-4.3525565885340445,"altitud":35000,"progreso":0.8424731182795699},{"timestamp":"2026-03-16T13:13:37","lat":37.21111031059463,"lng":-4.367674412554104,"altitud":35000,"progreso":0.8586021505376344},{"timestamp":"2026-03-16T13:14:07","lat":37.14965135940749,"lng":-4.382739273467882,"altitud":35000,"progreso":0.874731182795699},{"timestamp":"2026-03-16T13:14:37","lat":37.08799024944348,"lng":-4.397853687681829,"altitud":35000,"progreso":0.8908602150537634},{"timestamp":"2026-03-16T13:15:07","lat":37.026416209749335,"lng":-4.412946759170592,"altitud":32553.763440860217,"progreso":0.906989247311828},{"timestamp":"2026-03-16T13:15:37","lat":36.96487812444524,"lng":-4.428031017494227,"altitud":26908.60215053764,"progreso":0.9231182795698925},{"timestamp":"2026-03-16T13:16:08","lat":36.90308566580209,"lng":-4.443177627987874,"altitud":21075.26881720429,"progreso":0.9397849462365592},{"timestamp":"2026-03-16T13:16:38","lat":36.8413895543743,"lng":-4.458300621784996,"altitud":15430.107526881715,"progreso":0.9559139784946237},{"timestamp":"2026-03-16T13:17:08","lat":36.779684663082314,"lng":-4.4734257677085445,"altitud":9784.946236559139,"progreso":0.9720430107526882},{"timestamp":"2026-03-16T13:17:38","lat":36.718121209484515,"lng":-4.488516244325999,"altitud":4139.784946236563,"progreso":0.9881720430107527}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (29, N'IB2611', 1, 3, 3, CAST(N'2026-03-16T13:36:00.000' AS DateTime), CAST(N'2026-03-16T14:18:00.000' AS DateTime), 3, N'23', 180, 23, 23, N'[{"timestamp":"2026-03-16T13:37:16","lat":40.44413241399251,"lng":-3.377886272203299,"altitud":10555.555555555555,"progreso":0.03015873015873016},{"timestamp":"2026-03-16T13:37:46","lat":40.43305132971757,"lng":-3.3019375215786475,"altitud":14722.222222222224,"progreso":0.04206349206349207},{"timestamp":"2026-03-16T13:38:16","lat":40.42203682013791,"lng":-3.2264450679015044,"altitud":18888.88888888889,"progreso":0.05396825396825397},{"timestamp":"2026-03-16T13:38:46","lat":40.41100384657789,"lng":-3.150826063770914,"altitud":23055.555555555555,"progreso":0.06587301587301587},{"timestamp":"2026-03-16T13:39:16","lat":40.40000200914062,"lng":-3.075420463813038,"altitud":27222.222222222223,"progreso":0.07777777777777778},{"timestamp":"2026-03-16T13:39:47","lat":40.388981351023546,"lng":-2.9998858686158973,"altitud":31527.777777777777,"progreso":0.09007936507936508},{"timestamp":"2026-03-16T13:40:17","lat":40.37796028902687,"lng":-2.9243485052644616,"altitud":35000,"progreso":0.10198412698412698},{"timestamp":"2026-03-16T13:40:47","lat":40.36695724772896,"lng":-2.84893465415445,"altitud":35000,"progreso":0.11388888888888889},{"timestamp":"2026-03-16T13:41:17","lat":40.355920946069574,"lng":-2.7732928395314467,"altitud":35000,"progreso":0.1257936507936508},{"timestamp":"2026-03-16T13:41:47","lat":40.344920663970456,"lng":-2.6978978997207417,"altitud":35000,"progreso":0.1376984126984127},{"timestamp":"2026-03-16T13:42:18","lat":40.333829923175294,"lng":-2.6218829641787926,"altitud":35000,"progreso":0.15},{"timestamp":"2026-03-16T13:42:48","lat":40.3227392798809,"lng":-2.5458686968983235,"altitud":35000,"progreso":0.1619047619047619},{"timestamp":"2026-03-16T13:43:18","lat":40.31170149883902,"lng":-2.4702167427213615,"altitud":35000,"progreso":0.1738095238095238},{"timestamp":"2026-03-16T13:43:48","lat":40.30069048289093,"lng":-2.3947482340794357,"altitud":35000,"progreso":0.18571428571428572},{"timestamp":"2026-03-16T13:44:16","lat":40.29062841543971,"lng":-2.325783732712978,"altitud":35000,"progreso":0.19682539682539682},{"timestamp":"2026-03-16T13:44:46","lat":40.27953881427154,"lng":-2.249776608071501,"altitud":35000,"progreso":0.20873015873015874},{"timestamp":"2026-03-16T13:45:17","lat":40.26852297627126,"lng":-2.1742750495194096,"altitud":35000,"progreso":0.22103174603174602},{"timestamp":"2026-03-16T13:45:47","lat":40.25751649962312,"lng":-2.0988376528293577,"altitud":35000,"progreso":0.23293650793650794},{"timestamp":"2026-03-16T13:46:17","lat":40.24652066330356,"lng":-2.023473183990134,"altitud":35000,"progreso":0.24484126984126983},{"timestamp":"2026-03-16T13:46:47","lat":40.23550172905125,"lng":-1.9479504040063544,"altitud":35000,"progreso":0.2567460317460317},{"timestamp":"2026-03-16T13:47:17","lat":40.22449852550767,"lng":-1.8725354408792063,"altitud":35000,"progreso":0.26865079365079364},{"timestamp":"2026-03-16T13:47:47","lat":40.213479955440825,"lng":-1.7970151569897104,"altitud":35000,"progreso":0.28055555555555556},{"timestamp":"2026-03-16T13:48:17","lat":40.20246995875923,"lng":-1.7215536343082425,"altitud":35000,"progreso":0.2924603174603175},{"timestamp":"2026-03-16T13:48:48","lat":40.191450927115696,"lng":-1.646030186813839,"altitud":35000,"progreso":0.3047619047619048},{"timestamp":"2026-03-16T13:49:18","lat":40.18044857924181,"lng":-1.57062108836946,"altitud":35000,"progreso":0.31666666666666665},{"timestamp":"2026-03-16T13:49:48","lat":40.169427540141385,"lng":-1.4950838819468442,"altitud":35000,"progreso":0.32857142857142857},{"timestamp":"2026-03-16T13:50:18","lat":40.15842692427558,"lng":-1.4196866545294258,"altitud":35000,"progreso":0.3404761904761905},{"timestamp":"2026-03-16T13:50:48","lat":40.147395731547064,"lng":-1.344079856057106,"altitud":35000,"progreso":0.3523809523809524},{"timestamp":"2026-03-16T13:51:18","lat":40.136390028076406,"lng":-1.2686477586555602,"altitud":35000,"progreso":0.36428571428571427},{"timestamp":"2026-03-16T13:51:34","lat":40.1307290937392,"lng":-1.2298482260817138,"altitud":35000,"progreso":0.37063492063492065},{"timestamp":"2026-03-16T13:52:04","lat":40.11961271400241,"lng":-1.1536575635499626,"altitud":35000,"progreso":0.3825396825396825},{"timestamp":"2026-03-16T13:52:34","lat":40.108603747907615,"lng":-1.0782031044173648,"altitud":35000,"progreso":0.39444444444444443},{"timestamp":"2026-03-16T13:53:05","lat":40.09757945370559,"lng":-1.0026435878224471,"altitud":35000,"progreso":0.40674603174603174},{"timestamp":"2026-03-16T13:53:35","lat":40.086577795713566,"lng":-0.9272392177660369,"altitud":35000,"progreso":0.41865079365079366},{"timestamp":"2026-03-16T13:54:05","lat":40.07555023037892,"lng":-0.8516572811236158,"altitud":35000,"progreso":0.4305555555555556},{"timestamp":"2026-03-16T13:54:35","lat":40.064526780964485,"lng":-0.776103554626479,"altitud":35000,"progreso":0.44246031746031744},{"timestamp":"2026-03-16T13:55:05","lat":40.053522816074995,"lng":-0.7006833733032294,"altitud":35000,"progreso":0.45436507936507936},{"timestamp":"2026-03-16T13:55:39","lat":40.04109756626329,"lng":-0.6155218335131467,"altitud":35000,"progreso":0.46785714285714286},{"timestamp":"2026-03-16T13:56:10","lat":40.03003063446268,"lng":-0.539670082669137,"altitud":35000,"progreso":0.4801587301587302},{"timestamp":"2026-03-16T13:56:40","lat":40.018991251632855,"lng":-0.464007149982232,"altitud":35000,"progreso":0.49206349206349204},{"timestamp":"2026-03-16T13:57:10","lat":40.00798049210814,"lng":-0.3885403988429692,"altitud":35000,"progreso":0.503968253968254},{"timestamp":"2026-03-16T13:57:40","lat":39.99695476351275,"lng":-0.3129710510454582,"altitud":35000,"progreso":0.5158730158730159},{"timestamp":"2026-03-16T13:58:10","lat":39.98594320050134,"lng":-0.23749879288097464,"altitud":35000,"progreso":0.5277777777777778},{"timestamp":"2026-03-16T13:58:41","lat":39.97491386448696,"lng":-0.16190472015956825,"altitud":35000,"progreso":0.540079365079365},{"timestamp":"2026-03-16T13:59:11","lat":39.96390703150455,"lng":-0.08646488118655027,"altitud":35000,"progreso":0.551984126984127},{"timestamp":"2026-03-16T13:59:41","lat":39.95290088011461,"lng":-0.011029713786760098,"altitud":35000,"progreso":0.5638888888888889},{"timestamp":"2026-03-16T14:00:11","lat":39.941891964449994,"lng":0.06442439970197933,"altitud":35000,"progreso":0.5757936507936507},{"timestamp":"2026-03-16T14:00:41","lat":39.93089429106253,"lng":0.13980145963867985,"altitud":35000,"progreso":0.5876984126984127},{"timestamp":"2026-03-16T14:01:11","lat":39.91989039204996,"lng":0.21522118944743118,"altitud":35000,"progreso":0.5996031746031746},{"timestamp":"2026-03-16T14:01:41","lat":39.908894778521486,"lng":0.2905841312966597,"altitud":35000,"progreso":0.6115079365079366},{"timestamp":"2026-03-16T14:02:11","lat":39.89789528650727,"lng":0.36597365593681186,"altitud":35000,"progreso":0.6234126984126984}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (30, N'IB3101', 1, 25, 7, CAST(N'2026-03-16T13:36:00.000' AS DateTime), CAST(N'2026-03-16T15:11:00.000' AS DateTime), 3, N'23', 200, 23, 23, N'[{"timestamp":"2026-03-16T13:37:34","lat":51.28803353310784,"lng":-0.505825606117446,"altitud":5771.929824561404,"progreso":0.01649122807017544},{"timestamp":"2026-03-16T13:38:04","lat":51.229686200354394,"lng":-0.5223465160747272,"altitud":7614.035087719298,"progreso":0.02175438596491228},{"timestamp":"2026-03-16T13:38:34","lat":51.17152244762642,"lng":-0.5388154457798212,"altitud":9456.140350877193,"progreso":0.027017543859649124},{"timestamp":"2026-03-16T13:39:04","lat":51.11323549499886,"lng":-0.555319259246553,"altitud":11298.245614035088,"progreso":0.032280701754385965},{"timestamp":"2026-03-16T13:39:35","lat":51.05508950535363,"lng":-0.5717831593765738,"altitud":13201.754385964912,"progreso":0.037719298245614034},{"timestamp":"2026-03-16T13:40:05","lat":50.99677321134953,"lng":-0.588295280785021,"altitud":15043.859649122807,"progreso":0.04298245614035088},{"timestamp":"2026-03-16T13:40:35","lat":50.938628782855076,"lng":-0.604758738878871,"altitud":16885.9649122807,"progreso":0.04824561403508772},{"timestamp":"2026-03-16T13:41:05","lat":50.8803444911879,"lng":-0.621261798900932,"altitud":18728.070175438595,"progreso":0.05350877192982456},{"timestamp":"2026-03-16T13:41:35","lat":50.82220687032192,"lng":-0.6377233294308,"altitud":20570.175438596492,"progreso":0.058771929824561406},{"timestamp":"2026-03-16T13:42:05","lat":50.76400692421066,"lng":-0.6542025072071976,"altitud":22412.280701754386,"progreso":0.06403508771929825},{"timestamp":"2026-03-16T13:42:18","lat":50.74035080694679,"lng":-0.6609006811392713,"altitud":23210.526315789477,"progreso":0.06631578947368422},{"timestamp":"2026-03-16T13:42:48","lat":50.68175013478852,"lng":-0.6774933235528298,"altitud":25052.63157894737,"progreso":0.07157894736842105},{"timestamp":"2026-03-16T13:43:18","lat":50.623428775871794,"lng":-0.6940068790793691,"altitud":26894.73684210526,"progreso":0.07684210526315789},{"timestamp":"2026-03-16T13:43:48","lat":50.56524883819139,"lng":-0.7104803915156557,"altitud":28736.842105263157,"progreso":0.08210526315789474},{"timestamp":"2026-03-16T13:44:16","lat":50.512082948685105,"lng":-0.7255341880112645,"altitud":30456.14035087719,"progreso":0.08701754385964912},{"timestamp":"2026-03-16T13:44:46","lat":50.453487782906905,"lng":-0.7421252713062662,"altitud":32298.245614035088,"progreso":0.09228070175438596},{"timestamp":"2026-03-16T13:45:17","lat":50.39528236649705,"lng":-0.7586059979848363,"altitud":34201.754385964916,"progreso":0.09771929824561404},{"timestamp":"2026-03-16T13:45:47","lat":50.33712641354158,"lng":-0.7750727192027016,"altitud":35000,"progreso":0.10298245614035088},{"timestamp":"2026-03-16T13:46:17","lat":50.279026681888126,"lng":-0.7915235214912124,"altitud":35000,"progreso":0.10824561403508771},{"timestamp":"2026-03-16T13:46:47","lat":50.22080490552105,"lng":-0.8080088804531697,"altitud":35000,"progreso":0.11350877192982456},{"timestamp":"2026-03-16T13:47:17","lat":50.16266624697507,"lng":-0.8244707047996891,"altitud":35000,"progreso":0.1187719298245614},{"timestamp":"2026-03-16T13:47:47","lat":50.104446394888896,"lng":-0.8409555189060375,"altitud":35000,"progreso":0.12403508771929825},{"timestamp":"2026-03-16T13:48:17","lat":50.046271842802454,"lng":-0.8574275064240693,"altitud":35000,"progreso":0.12929824561403508},{"timestamp":"2026-03-16T13:48:48","lat":49.98804955184025,"lng":-0.8739130110924247,"altitud":35000,"progreso":0.13473684210526315},{"timestamp":"2026-03-16T13:49:18","lat":49.929915414476476,"lng":-0.8903735552768438,"altitud":35000,"progreso":0.14},{"timestamp":"2026-03-16T13:49:48","lat":49.871682516526,"lng":-0.9068620632889659,"altitud":35000,"progreso":0.14526315789473684},{"timestamp":"2026-03-16T13:50:18","lat":49.81355753073579,"lng":-0.9233200162268665,"altitud":35000,"progreso":0.15052631578947367},{"timestamp":"2026-03-16T13:50:48","lat":49.75527098310829,"lng":-0.9398237150187841,"altitud":35000,"progreso":0.15578947368421053},{"timestamp":"2026-03-16T13:51:18","lat":49.69711911546312,"lng":-0.9562892794906548,"altitud":35000,"progreso":0.16105263157894736},{"timestamp":"2026-03-16T13:51:34","lat":49.66720790577053,"lng":-0.9647585681234803,"altitud":35000,"progreso":0.163859649122807},{"timestamp":"2026-03-16T13:52:04","lat":49.608471247557794,"lng":-0.9813897146683377,"altitud":35000,"progreso":0.16912280701754387},{"timestamp":"2026-03-16T13:52:34","lat":49.550302140879516,"lng":-0.9978601603318631,"altitud":35000,"progreso":0.1743859649122807},{"timestamp":"2026-03-16T13:53:05","lat":49.49205204364344,"lng":-1.0143535382812274,"altitud":35000,"progreso":0.17982456140350878},{"timestamp":"2026-03-16T13:53:35","lat":49.43392155147316,"lng":-1.0308130503376849,"altitud":35000,"progreso":0.1850877192982456},{"timestamp":"2026-03-16T13:54:05","lat":49.375654170246854,"lng":-1.0473113222082095,"altitud":35000,"progreso":0.19035087719298247},{"timestamp":"2026-03-16T13:54:35","lat":49.31740853669417,"lng":-1.0638034362761286,"altitud":35000,"progreso":0.1956140350877193},{"timestamp":"2026-03-16T13:55:05","lat":49.25926585535339,"lng":-1.0802663996675281,"altitud":35000,"progreso":0.20087719298245615},{"timestamp":"2026-03-16T13:55:39","lat":49.193613397567816,"lng":-1.0988557385861173,"altitud":35000,"progreso":0.20684210526315788},{"timestamp":"2026-03-16T13:56:10","lat":49.13513801205315,"lng":-1.115412906381384,"altitud":35000,"progreso":0.21228070175438596},{"timestamp":"2026-03-16T13:56:40","lat":49.07680818961917,"lng":-1.1319288583329135,"altitud":35000,"progreso":0.21754385964912282},{"timestamp":"2026-03-16T13:57:10","lat":49.01862960682702,"lng":-1.1484019871357813,"altitud":35000,"progreso":0.22280701754385965},{"timestamp":"2026-03-16T13:57:40","lat":48.96037193055216,"lng":-1.1648975110721425,"altitud":35000,"progreso":0.22807017543859648},{"timestamp":"2026-03-16T13:58:10","lat":48.902189102302,"lng":-1.1813718419664532,"altitud":35000,"progreso":0.23333333333333334},{"timestamp":"2026-03-16T13:58:41","lat":48.843912365169075,"lng":-1.1978727629399177,"altitud":35000,"progreso":0.2387719298245614},{"timestamp":"2026-03-16T13:59:11","lat":48.78575452941676,"lng":-1.214340017267282,"altitud":35000,"progreso":0.24403508771929824},{"timestamp":"2026-03-16T13:59:41","lat":48.7276002950585,"lng":-1.230806251868391,"altitud":35000,"progreso":0.24929824561403507},{"timestamp":"2026-03-16T14:00:11","lat":48.669431454842865,"lng":-1.2472766220836466,"altitud":35000,"progreso":0.25456140350877193},{"timestamp":"2026-03-16T14:00:41","lat":48.61132201650141,"lng":-1.2637301727980186,"altitud":35000,"progreso":0.2598245614035088},{"timestamp":"2026-03-16T14:01:11","lat":48.55317968324073,"lng":-1.2801930376313595,"altitud":35000,"progreso":0.2650877192982456},{"timestamp":"2026-03-16T14:01:41","lat":48.49508112876944,"lng":-1.2966435066035091,"altitud":35000,"progreso":0.27035087719298245},{"timestamp":"2026-03-16T14:02:11","lat":48.43696208117927,"lng":-1.3130997781540419,"altitud":35000,"progreso":0.2756140350877193}]')
GO
INSERT [dbo].[vuelo] ([id], [numero_vuelo], [aerolinea_id], [ruta_id], [avion_id], [fecha_salida], [fecha_llegada], [estado_id], [puerta], [capacidad_total], [pasajeros_confirmados], [pasajeros_embarcados], [telemetria]) VALUES (31, N'IB3104', 1, 2, 22, CAST(N'2026-03-16T13:49:00.000' AS DateTime), CAST(N'2026-03-16T14:20:00.000' AS DateTime), 6, N'', 138, 0, 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[vuelo] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__aeroline__B26EA553E8C57DF0]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[aerolinea] ADD UNIQUE NONCLUSTERED
    (
     [codigo_iata] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Aerolinea_Nombre]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[aerolinea] ADD  CONSTRAINT [UQ_Aerolinea_Nombre] UNIQUE NONCLUSTERED
    (
     [nombre] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__aeropuer__8F6B9598953466CA]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[aeropuerto] ADD UNIQUE NONCLUSTERED
    (
     [codigo_icao] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__aeropuer__B26EA5538C275E81]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[aeropuerto] ADD UNIQUE NONCLUSTERED
    (
     [codigo_iata] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_tripulante_vuelo]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[asignacion_tripulacion] ADD  CONSTRAINT [UQ_tripulante_vuelo] UNIQUE NONCLUSTERED
    (
     [tripulante_id] ASC,
     [vuelo_id] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__avion__30962D157E25DFF6]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[avion] ADD UNIQUE NONCLUSTERED
    (
     [matricula] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__estado_a__72AFBCC69E0EBC6C]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[estado_avion] ADD UNIQUE NONCLUSTERED
    (
     [nombre] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__estado_v__72AFBCC6D0285A98]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[estado_vuelo] ADD UNIQUE NONCLUSTERED
    (
     [nombre] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__mantenim__72AFBCC68FD037DA]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[mantenimiento_tipo] ADD UNIQUE NONCLUSTERED
    (
     [nombre] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__pais__296D3C1073CC08AD]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[pais] ADD UNIQUE NONCLUSTERED
    (
     [codigo_iso] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__rol__72AFBCC63AAD7C5E]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[rol] ADD UNIQUE NONCLUSTERED
    (
     [nombre] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_rutaAerolinea]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[ruta_aerolinea] ADD  CONSTRAINT [UQ_rutaAerolinea] UNIQUE NONCLUSTERED
    (
     [ruta_id] ASC,
     [aerolinea_id] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_rutaAerolinea_activa]    Script Date: 16/03/2026 14:02:32 ******/
CREATE NONCLUSTERED INDEX [IX_rutaAerolinea_activa] ON [dbo].[ruta_aerolinea]
    (
     [activa] ASC
        )
    WHERE ([activa]=(1))
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_rutaAerolinea_aerolinea]    Script Date: 16/03/2026 14:02:32 ******/
CREATE NONCLUSTERED INDEX [IX_rutaAerolinea_aerolinea] ON [dbo].[ruta_aerolinea]
    (
     [aerolinea_id] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__usuario__AB6E61645A68EBD7]    Script Date: 16/03/2026 14:02:32 ******/
ALTER TABLE [dbo].[usuario] ADD UNIQUE NONCLUSTERED
    (
     [email] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aerolinea] ADD  DEFAULT ('') FOR [logo]
GO
ALTER TABLE [dbo].[avion] ADD  DEFAULT ((0)) FOR [horas_vuelo_totales]
GO
ALTER TABLE [dbo].[avion] ADD  DEFAULT ((0)) FOR [ciclos_totales]
GO
ALTER TABLE [dbo].[mantenimiento] ADD  DEFAULT ('Programado') FOR [estado]
GO
ALTER TABLE [dbo].[mantenimiento_tipo] ADD  DEFAULT ((0)) FOR [intervalo_horas]
GO
ALTER TABLE [dbo].[mantenimiento_tipo] ADD  DEFAULT ((0)) FOR [intervalo_ciclos]
GO
ALTER TABLE [dbo].[mantenimiento_tipo] ADD  DEFAULT ((0)) FOR [intervalo_dias]
GO
ALTER TABLE [dbo].[registro_estado_avion] ADD  DEFAULT ((0)) FOR [latitud]
GO
ALTER TABLE [dbo].[registro_estado_avion] ADD  DEFAULT ((0)) FOR [longitud]
GO
ALTER TABLE [dbo].[ruta_aerolinea] ADD  DEFAULT ((1)) FOR [activa]
GO
ALTER TABLE [dbo].[ruta_aerolinea] ADD  DEFAULT (getdate()) FOR [fecha_inicio]
GO
ALTER TABLE [dbo].[tripulante] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[usuario] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[vuelo] ADD  DEFAULT ('') FOR [puerta]
GO
ALTER TABLE [dbo].[vuelo] ADD  DEFAULT ((0)) FOR [pasajeros_confirmados]
GO
ALTER TABLE [dbo].[vuelo] ADD  DEFAULT ((0)) FOR [pasajeros_embarcados]
GO
ALTER TABLE [dbo].[aeropuerto]  WITH CHECK ADD FOREIGN KEY([pais_id])
    REFERENCES [dbo].[pais] ([id])
GO
ALTER TABLE [dbo].[asignacion_tripulacion]  WITH CHECK ADD FOREIGN KEY([tripulante_id])
    REFERENCES [dbo].[tripulante] ([id])
GO
ALTER TABLE [dbo].[asignacion_tripulacion]  WITH CHECK ADD FOREIGN KEY([vuelo_id])
    REFERENCES [dbo].[vuelo] ([id])
GO
ALTER TABLE [dbo].[avion]  WITH CHECK ADD FOREIGN KEY([aerolinea_id])
    REFERENCES [dbo].[aerolinea] ([id])
GO
ALTER TABLE [dbo].[avion]  WITH CHECK ADD FOREIGN KEY([aeropuerto_actual_id])
    REFERENCES [dbo].[aeropuerto] ([id])
GO
ALTER TABLE [dbo].[avion]  WITH CHECK ADD FOREIGN KEY([estado_id])
    REFERENCES [dbo].[estado_avion] ([id])
GO
ALTER TABLE [dbo].[avion]  WITH CHECK ADD FOREIGN KEY([modelo_id])
    REFERENCES [dbo].[modelo_avion] ([id])
GO
ALTER TABLE [dbo].[mantenimiento]  WITH CHECK ADD FOREIGN KEY([avion_id])
    REFERENCES [dbo].[avion] ([id])
GO
ALTER TABLE [dbo].[mantenimiento]  WITH CHECK ADD FOREIGN KEY([mantenimiento_tipo_id])
    REFERENCES [dbo].[mantenimiento_tipo] ([id])
GO
ALTER TABLE [dbo].[registro_estado_avion]  WITH CHECK ADD FOREIGN KEY([aeropuerto_id])
    REFERENCES [dbo].[aeropuerto] ([id])
GO
ALTER TABLE [dbo].[registro_estado_avion]  WITH CHECK ADD FOREIGN KEY([avion_id])
    REFERENCES [dbo].[avion] ([id])
GO
ALTER TABLE [dbo].[retraso_vuelo]  WITH CHECK ADD FOREIGN KEY([codigo_retraso_id])
    REFERENCES [dbo].[codigo_retraso_iata] ([id])
GO
ALTER TABLE [dbo].[retraso_vuelo]  WITH CHECK ADD FOREIGN KEY([vuelo_id])
    REFERENCES [dbo].[vuelo] ([id])
GO
ALTER TABLE [dbo].[ruta]  WITH CHECK ADD FOREIGN KEY([aeropuerto_origen_id])
    REFERENCES [dbo].[aeropuerto] ([id])
GO
ALTER TABLE [dbo].[ruta]  WITH CHECK ADD FOREIGN KEY([aeropuerto_destino_id])
    REFERENCES [dbo].[aeropuerto] ([id])
GO
ALTER TABLE [dbo].[ruta_aerolinea]  WITH CHECK ADD  CONSTRAINT [FK_rutaAerolinea_aerolinea] FOREIGN KEY([aerolinea_id])
    REFERENCES [dbo].[aerolinea] ([id])
GO
ALTER TABLE [dbo].[ruta_aerolinea] CHECK CONSTRAINT [FK_rutaAerolinea_aerolinea]
GO
ALTER TABLE [dbo].[ruta_aerolinea]  WITH CHECK ADD  CONSTRAINT [FK_rutaAerolinea_ruta] FOREIGN KEY([ruta_id])
    REFERENCES [dbo].[ruta] ([id])
GO
ALTER TABLE [dbo].[ruta_aerolinea] CHECK CONSTRAINT [FK_rutaAerolinea_ruta]
GO
ALTER TABLE [dbo].[users_security]  WITH CHECK ADD  CONSTRAINT [FK_Security_Usuario] FOREIGN KEY([id_usuario])
    REFERENCES [dbo].[usuario] ([id])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[users_security] CHECK CONSTRAINT [FK_Security_Usuario]
GO
ALTER TABLE [dbo].[usuario]  WITH CHECK ADD FOREIGN KEY([aerolinea_id])
    REFERENCES [dbo].[aerolinea] ([id])
GO
ALTER TABLE [dbo].[usuario_rol]  WITH CHECK ADD FOREIGN KEY([rol_id])
    REFERENCES [dbo].[rol] ([id])
GO
ALTER TABLE [dbo].[usuario_rol]  WITH CHECK ADD FOREIGN KEY([usuario_id])
    REFERENCES [dbo].[usuario] ([id])
GO
ALTER TABLE [dbo].[vuelo]  WITH CHECK ADD FOREIGN KEY([aerolinea_id])
    REFERENCES [dbo].[aerolinea] ([id])
GO
ALTER TABLE [dbo].[vuelo]  WITH CHECK ADD FOREIGN KEY([avion_id])
    REFERENCES [dbo].[avion] ([id])
GO
ALTER TABLE [dbo].[vuelo]  WITH CHECK ADD FOREIGN KEY([estado_id])
    REFERENCES [dbo].[estado_vuelo] ([id])
GO
ALTER TABLE [dbo].[vuelo]  WITH CHECK ADD FOREIGN KEY([ruta_id])
    REFERENCES [dbo].[ruta] ([id])
GO
ALTER TABLE [dbo].[mantenimiento]  WITH CHECK ADD  CONSTRAINT [CK_mantenimiento_estado] CHECK  (([estado]='Cancelado' OR [estado]='Completado' OR [estado]='En Curso' OR [estado]='Programado'))
GO
ALTER TABLE [dbo].[mantenimiento] CHECK CONSTRAINT [CK_mantenimiento_estado]
GO
ALTER TABLE [dbo].[tripulante]  WITH CHECK ADD  CONSTRAINT [CK_tripulante_rol] CHECK  (([rol]='Tripulante de Cabina' OR [rol]='Primer Oficial' OR [rol]='Comandante'))
GO
ALTER TABLE [dbo].[tripulante] CHECK CONSTRAINT [CK_tripulante_rol]
GO
ALTER TABLE [dbo].[vuelo]  WITH CHECK ADD  CONSTRAINT [CK_tracking_posiciones_json] CHECK  ((isjson([telemetria])=(1) OR [telemetria] IS NULL))
GO
ALTER TABLE [dbo].[vuelo] CHECK CONSTRAINT [CK_tracking_posiciones_json]
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_ESTADO_MANTENIMIENTO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_ACTUALIZAR_ESTADO_MANTENIMIENTO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_AEROLINEAS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ══════════════════════════════════════════════════════════
--  SP_AEROLINEAS_PAGINADO
-- ══════════════════════════════════════════════════════════
CREATE PROCEDURE [dbo].[SP_AEROLINEAS_PAGINADO]
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @Busqueda       NVARCHAR(100) = NULL,   -- nombre, código IATA
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1   SET @PageNumber = 1;
    IF @PageSize   < 1   SET @PageSize   = 10;
    IF @PageSize   > 100 SET @PageSize   = 100;

    SELECT @TotalRegistros = COUNT(*)
    FROM dbo.aerolinea
    WHERE
        @Busqueda IS NULL OR
        nombre      LIKE '%' + @Busqueda + '%' OR
        codigo_iata LIKE '%' + @Busqueda + '%';

    SELECT
        id,
        nombre,
        logo,
        codigo_iata,
        @TotalRegistros                                      AS total_registros,
        @PageNumber                                          AS pagina_actual,
        @PageSize                                            AS registros_por_pagina,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize) AS total_paginas
    FROM dbo.aerolinea
    WHERE
        @Busqueda IS NULL OR
        nombre      LIKE '%' + @Busqueda + '%' OR
        codigo_iata LIKE '%' + @Busqueda + '%'
    ORDER BY nombre ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_AEROPUERTOS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_AEROPUERTOS_PAGINADO]
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
    FROM AEROPUERTO
    WHERE (@Busqueda IS NULL OR
           NOMBRE      LIKE '%' + @Busqueda + '%' OR
           CODIGO_IATA LIKE '%' + @Busqueda + '%' OR
           CODIGO_ICAO LIKE '%' + @Busqueda + '%' OR
           CIUDAD      LIKE '%' + @Busqueda + '%');

    SELECT
        ID,
        NOMBRE,
        CODIGO_IATA,
        CODIGO_ICAO,
        CIUDAD,
        PAIS_ID,
        LATITUD,
        LONGITUD,
        @TotalRegistros                                      AS total_registros,
        @PageNumber                                          AS pagina_actual,
        @PageSize                                            AS registros_por_pagina,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize) AS total_paginas
    FROM AEROPUERTO
    WHERE (@Busqueda IS NULL OR
           NOMBRE      LIKE '%' + @Busqueda + '%' OR
           CODIGO_IATA LIKE '%' + @Busqueda + '%' OR
           CODIGO_ICAO LIKE '%' + @Busqueda + '%' OR
           CIUDAD      LIKE '%' + @Busqueda + '%')
    ORDER BY CIUDAD, NOMBRE
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_RUTA_AEROLINEA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_ASIGNAR_RUTA_AEROLINEA
-- ============================================
CREATE   PROCEDURE [dbo].[SP_ASIGNAR_RUTA_AEROLINEA]
    @ruta_id INT,
    @aerolinea_id INT,
    @precio_base DECIMAL(10,2) = NULL,
    @frecuencia_semanal INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que la ruta existe
        IF NOT EXISTS (SELECT 1 FROM ruta WHERE id = @ruta_id)
            BEGIN
                RAISERROR('La ruta no existe', 16, 1);
                RETURN;
            END

        -- Validar que la aerolínea existe
        IF NOT EXISTS (SELECT 1 FROM aerolinea WHERE id = @aerolinea_id)
            BEGIN
                RAISERROR('La aerolínea no existe', 16, 1);
                RETURN;
            END

        -- Insertar o reactivar
        IF EXISTS (SELECT 1 FROM ruta_aerolinea
                   WHERE ruta_id = @ruta_id AND aerolinea_id = @aerolinea_id)
            BEGIN
                -- Ya existe, actualizar
                UPDATE ruta_aerolinea
                SET activa = 1,
                    precio_base = ISNULL(@precio_base, precio_base),
                    frecuencia_semanal = ISNULL(@frecuencia_semanal, frecuencia_semanal),
                    fecha_fin = NULL
                WHERE ruta_id = @ruta_id AND aerolinea_id = @aerolinea_id;

                SELECT 'Ruta reactivada correctamente' AS Mensaje;
            END
        ELSE
            BEGIN
                -- Nueva asignación
                INSERT INTO ruta_aerolinea (ruta_id, aerolinea_id, precio_base, frecuencia_semanal)
                VALUES (@ruta_id, @aerolinea_id, @precio_base, @frecuencia_semanal);

                SELECT 'Ruta asignada correctamente' AS Mensaje;
            END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_TRIPULACION]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[SP_ASIGNAR_TRIPULACION]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_AVIONES_CON_RUTAS_DISPONIBLES]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_AVIONES_CON_RUTAS_DISPONIBLES]
@AerolineaId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.*
    FROM dbo.avion AS a
    WHERE a.aerolinea_id = @AerolineaId
      AND a.estado_id = 1
      AND a.aeropuerto_actual_id IN (
        SELECT DISTINCT r.aeropuerto_origen_id
        FROM dbo.ruta_aerolinea AS ra
                 INNER JOIN dbo.ruta AS r ON r.id = ra.ruta_id
        WHERE ra.aerolinea_id = @AerolineaId
          AND ra.activa = 1
    )
      AND NOT EXISTS (
        SELECT 1
        FROM dbo.mantenimiento AS m
        WHERE m.avion_id = a.id
          AND m.estado IN ('Programado', 'En Curso', 'En Proceso')
          AND (m.fecha_fin IS NULL OR m.fecha_fin >= GETDATE())
    );
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_AEROLINEA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_CREATE_AEROLINEA]
    @nombre NVARCHAR(100),
    @logo NVARCHAR(250),
    @codIata NVARCHAR(3)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM aerolinea WHERE nombre = @nombre)
        BEGIN
            DECLARE @msgNombre NVARCHAR(200) = CONCAT('Ya existe la aerolinea: ', @nombre);
            RAISERROR(@msgNombre, 16, 1);
            RETURN;
        END


    IF EXISTS (SELECT 1 FROM aerolinea WHERE codigo_iata = @codIata)
        BEGIN
            DECLARE @msgIata NVARCHAR(200) = CONCAT('Ya existe el codigo IATA: ', @codIata);
            RAISERROR(@msgIata, 16, 1);
            RETURN;
        END

    INSERT INTO aerolinea (nombre, logo, codigo_iata)
    VALUES (@nombre, @logo, @codIata);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_AEROPUERTO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_CREATE_AEROPUERTO]
    @Nombre  NVARCHAR(150),
    @IATA    NVARCHAR(3),
    @ICAO    NVARCHAR(4),
    @Ciudad  NVARCHAR(100),
    @PaisId  INT,
    @Latitud DECIMAL(9,6),
    @Longitud DECIMAL(9,6)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM AEROPUERTO WHERE CODIGO_IATA = @IATA)
        THROW 51000, 'Ya existe un aeropuerto con ese código IATA.', 1;
    IF EXISTS (SELECT 1 FROM AEROPUERTO WHERE CODIGO_ICAO = @ICAO)
        THROW 51000, 'Ya existe un aeropuerto con ese código ICAO.', 1;

    INSERT INTO AEROPUERTO (NOMBRE, CODIGO_IATA, CODIGO_ICAO, CIUDAD, PAIS_ID, LATITUD, LONGITUD)
    VALUES (@Nombre, @IATA, @ICAO, @Ciudad, @PaisId, @Latitud, @Longitud);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_AVION]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[SP_CREATE_AVION]
(@matricula nvarchar(20),
 @modelo int,
 @aerolinea int,
 @estado int,
 @aeropuertoactual int,
 @horasvuelo int,
 @ciclos int)
AS
INSERT INTO AVION (matricula, modelo_id, aerolinea_id, estado_id, aeropuerto_actual_id, horas_vuelo_totales, ciclos_totales) VALUES
    (@matricula,
     @modelo,
     @aerolinea,
     @estado,
     @aeropuertoactual,
     @horasvuelo,
     @ciclos)
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_RUTA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_CREATE_RUTA]
    @aeropuerto_origen_id  INT,
    @aeropuerto_destino_id INT,
    @distancia_km NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- ══════════════════════════════════════════
    -- VALIDACIONES
    -- ══════════════════════════════════════════

    IF @aeropuerto_origen_id = @aeropuerto_destino_id
        BEGIN
            RAISERROR('El aeropuerto de origen y destino no pueden ser el mismo.', 16, 1);
            RETURN;
        END

    IF @distancia_km <= 0
        BEGIN
            RAISERROR('La distancia debe ser mayor a 0 km.', 16, 1);
            RETURN;
        END

    IF NOT EXISTS (SELECT 1 FROM dbo.aeropuerto WHERE id = @aeropuerto_origen_id)
        BEGIN
            RAISERROR('El aeropuerto de origen no existe.', 16, 1);
            RETURN;
        END

    IF NOT EXISTS (SELECT 1 FROM dbo.aeropuerto WHERE id = @aeropuerto_destino_id)
        BEGIN
            RAISERROR('El aeropuerto de destino no existe.', 16, 1);
            RETURN;
        END

    -- Evitar duplicados origen/destino
    IF EXISTS (
        SELECT 1 FROM dbo.ruta
        WHERE aeropuerto_origen_id  = @aeropuerto_origen_id
          AND aeropuerto_destino_id = @aeropuerto_destino_id
    )
        BEGIN
            RAISERROR('Ya existe una ruta entre esos dos aeropuertos.', 16, 1);
            RETURN;
        END

    -- ══════════════════════════════════════════
    -- INSERT
    -- ══════════════════════════════════════════
    BEGIN TRANSACTION;
    BEGIN TRY

        INSERT INTO dbo.ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
        VALUES (@aeropuerto_origen_id, @aeropuerto_destino_id, @distancia_km);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_TRIPULACION]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_CREATE_TRIPULACION]
(@idAerolinea INT,
 @nombre NVARCHAR(50),
 @apellido NVARCHAR(50),
 @rol NVARCHAR(50),
 @activo BIT =1)
AS
INSERT INTO tripulante (id_aerolinea,nombre,apellido,rol,activo)
VALUES(@idAerolinea,@nombre,@apellido,@rol,@activo) ;
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATE_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[SP_VALIDADICION_CREACION_VUELO]
    @avion_id      INT,
    @ruta_id       INT,
    @fecha_salida  DATETIME,
    @fecha_llegada DATETIME,
    @numero_vuelo  NVARCHAR(10)
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
        SELECT 1 FROM vuelo
        WHERE numero_vuelo = @numero_vuelo
          AND estado_id IN (1, 2, 3, 6) -- Programado, Embarcando, En Vuelo, Retrasado
          AND (
            (@fecha_salida BETWEEN fecha_salida AND fecha_llegada) -- Mi salida cruza otro vuelo
                OR (@fecha_llegada BETWEEN fecha_salida AND fecha_llegada) -- Mi llegada cruza otro vuelo
                OR (fecha_salida BETWEEN @fecha_salida AND @fecha_llegada) -- Otro vuelo empieza dentro del mío
            )
    )
        BEGIN
            RAISERROR('El número de vuelo %s ya está asignado a otro trayecto en ese horario.', 16, 1, @numero_vuelo);
            RETURN;
        END

    IF EXISTS (
        SELECT 1 FROM mantenimiento
        WHERE avion_id = @avion_id
          AND estado IN ('Programado', 'En Curso') -- Solo bloquean estos dos estados
          AND (
            -- Bloquea si la fecha de salida del vuelo es posterior o igual 
            -- al inicio del día programado del mantenimiento
            @fecha_salida >= CAST(fecha_programada AS DATETIME)
            )
    )
        BEGIN
            RAISERROR('El avión tiene un mantenimiento pendiente o en curso y no puede realizar vuelos hasta que finalice.', 16, 1);
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
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_CREATE_VUELO (MODIFICADO)
-- ============================================
CREATE   PROCEDURE [dbo].[SP_CREATE_VUELO]
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


        IF NOT EXISTS (
            SELECT 1
            FROM ruta_aerolinea
            WHERE ruta_id = @ruta_id
              AND aerolinea_id = @aerolinea_id
              AND activa = 1
        )
            BEGIN
                DECLARE @mensaje NVARCHAR(300);
                DECLARE @nombre_aerolinea NVARCHAR(100);
                DECLARE @codigo_ruta NVARCHAR(10);

                SELECT @nombre_aerolinea = nombre FROM aerolinea WHERE id = @aerolinea_id;
                SELECT @codigo_ruta = ao.codigo_iata + '-' + ad.codigo_iata
                FROM ruta r
                         INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
                         INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
                WHERE r.id = @ruta_id;

                SET @mensaje = 'La aerolínea ' + @nombre_aerolinea +
                               ' no opera la ruta ' + @codigo_ruta + '. ' +
                               'Debe asignar la ruta primero.';

                RAISERROR(@mensaje, 16, 1);
                RETURN;
            END

        -- Obtener duración de la ruta
        SELECT @duracion_minutos = ROUND((distancia_km / 800.0) * 60, 0)
        FROM ruta
        WHERE id = @ruta_id;

        IF @duracion_minutos IS NULL
            BEGIN
                RAISERROR('La ruta no existe.', 16, 1);
                RETURN;
            END

        -- Calcular fecha llegada
        SET @fecha_llegada = DATEADD(MINUTE, @duracion_minutos, CAST(@fecha_salida AS DATETIME));

        -- Validar disponibilidad del avión
        EXEC SP_VALIDADICION_CREACION_VUELO
             @avion_id,
             @ruta_id,
             @fecha_salida,
             @fecha_llegada,
             @numero_vuelo;

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
GO
/****** Object:  StoredProcedure [dbo].[SP_DESACTIVAR_RUTA_AEROLINEA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_DESACTIVAR_RUTA_AEROLINEA
-- ============================================
CREATE   PROCEDURE [dbo].[SP_DESACTIVAR_RUTA_AEROLINEA]
    @ruta_id INT,
    @aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que no hay vuelos activos con esta ruta
        IF EXISTS (
            SELECT 1 FROM vuelo
            WHERE ruta_id = @ruta_id
              AND aerolinea_id = @aerolinea_id
              AND estado_id IN (1, 2, 3) -- Programado, Embarcando, En Vuelo
        )
            BEGIN
                RAISERROR('No se puede desactivar la ruta porque tiene vuelos activos', 16, 1);
                RETURN;
            END

        UPDATE ruta_aerolinea
        SET activa = 0,
            fecha_fin = GETDATE()
        WHERE ruta_id = @ruta_id
          AND aerolinea_id = @aerolinea_id;

        IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR('No se encontró la asignación de ruta', 16, 1);
                RETURN;
            END

        SELECT 'Ruta desactivada correctamente' AS Mensaje;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_FLOTAS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_FLOTAS_PAGINADO]
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @EstadoId       INT           = NULL,
    @AerolineaId    INT           = NULL,
    @Busqueda       NVARCHAR(100) = NULL,
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1  SET @PageNumber = 1;
    IF @PageSize   < 1  SET @PageSize   = 10;
    IF @PageSize   > 100 SET @PageSize  = 100;



    SELECT @TotalRegistros = COUNT(*)
    FROM V_FLOTA_ESTADO as vf
    WHERE
        (@EstadoId    IS NULL OR vf.idestado    = @EstadoId)
      AND (@AerolineaId IS NULL OR vf.id_aerolinea = @AerolineaId)
      AND (@Busqueda    IS NULL OR
           vf.matricula    LIKE '%' + @Busqueda + '%' OR
           vf.nombre_modelo     LIKE '%' + @Busqueda + '%' OR
           vf.capacidad_total    LIKE '%' + @Busqueda + '%' OR
           vf.ubicacion     LIKE '%' + @Busqueda + '%' OR
           vf.vuelo_actual    LIKE '%' + @Busqueda + '%'
        );


    SELECT
        vf.*,
        @TotalRegistros                                              AS total_registros,
        @PageNumber                                                  AS pagina_actual,
        @PageSize                                                    AS registros_por_pagina,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize)         AS total_paginas
    FROM V_FLOTA_ESTADO as vf
    WHERE
        (@AerolineaId IS NULL OR vf.id_aerolinea = @AerolineaId)


      AND (@EstadoId IS NULL OR vf.idestado = @EstadoId)

      AND (@Busqueda    IS NULL OR
           vf.matricula    LIKE '%' + @Busqueda + '%' OR
           vf.nombre_modelo     LIKE '%' + @Busqueda + '%' OR
           vf.capacidad_total   LIKE '%' + @Busqueda + '%' OR
           vf.ubicacion     LIKE '%' + @Busqueda + '%' OR
           vf.vuelo_actual     LIKE '%' + @Busqueda + '%'
        )
    ORDER BY vf.matricula DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;

END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_AERONAVES_POR_ESTADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_AERONAVES_POR_ESTADO
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_AERONAVES_POR_ESTADO]
@aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ea.nombre AS estado,
        COUNT(a.id) AS total
    FROM estado_avion ea
             LEFT JOIN avion a ON a.estado_id = ea.id AND a.aerolinea_id = @aerolinea_id
    GROUP BY ea.id, ea.nombre
    ORDER BY COUNT(a.id) DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DASHBOARD_STATS]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_DASHBOARD_STATS
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_DASHBOARD_STATS]
@aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @Ahora DATETIME = GETDATE();
    DECLARE @InicioMes DATE = DATEFROMPARTS(YEAR(@Ahora), MONTH(@Ahora), 1);

    SELECT
        -- Vuelos
        (SELECT COUNT(*) FROM vuelo WHERE aerolinea_id = @aerolinea_id) AS TotalVuelos,
        (SELECT COUNT(*) FROM vuelo WHERE aerolinea_id = @aerolinea_id AND estado_id = 3) AS VuelosEnVuelo,
        (SELECT COUNT(*) FROM vuelo WHERE aerolinea_id = @aerolinea_id AND CAST(fecha_salida AS DATE) = @Hoy) AS VuelosHoy,
        (SELECT COUNT(*) FROM vuelo WHERE aerolinea_id = @aerolinea_id AND estado_id = 5) AS VuelosCancelados,

        -- Aeronaves
        (SELECT COUNT(*) FROM avion WHERE aerolinea_id = @aerolinea_id) AS TotalAeronaves,
        (SELECT COUNT(*) FROM avion WHERE aerolinea_id = @aerolinea_id AND estado_id = 1) AS AeronavesOperativas,
        (SELECT COUNT(*) FROM avion WHERE aerolinea_id = @aerolinea_id AND estado_id = 2) AS AeronavesEnMantenimiento,
        (SELECT COUNT(*) FROM avion WHERE aerolinea_id = @aerolinea_id AND estado_id = 3) AS AeronavesEnVuelo,

        -- Pasajeros
        (SELECT ISNULL(SUM(pasajeros_embarcados), 0)
         FROM vuelo
         WHERE aerolinea_id = @aerolinea_id AND CAST(fecha_salida AS DATE) = @Hoy) AS PasajerosHoy,

        (SELECT ISNULL(AVG(CAST(pasajeros_confirmados AS FLOAT) / NULLIF(capacidad_total, 0) * 100), 0)
         FROM vuelo
         WHERE aerolinea_id = @aerolinea_id AND fecha_salida >= DATEADD(DAY, -7, @Hoy)) AS OcupacionPromedio,

        (SELECT ISNULL(SUM(pasajeros_embarcados), 0)
         FROM vuelo
         WHERE aerolinea_id = @aerolinea_id AND fecha_salida >= @InicioMes) AS TotalPasajerosMes,

        -- Mantenimiento
        (SELECT COUNT(*)
         FROM mantenimiento m
                  INNER JOIN avion a ON m.avion_id = a.id
         WHERE a.aerolinea_id = @aerolinea_id AND m.estado = 'En Curso') AS MantenimientosActivos,

        (SELECT COUNT(*)
         FROM mantenimiento m
                  INNER JOIN avion a ON m.avion_id = a.id
         WHERE a.aerolinea_id = @aerolinea_id AND m.estado = 'Programado') AS MantenimientosPendientes;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OCUPACION_SEMANAL]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_OCUPACION_SEMANAL
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_OCUPACION_SEMANAL]
@aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Hoy DATE = CAST(GETDATE() AS DATE);

    -- ✅ SOLUCIÓN: Usar CTE en lugar de spt_values
    ;WITH Dias AS (
        SELECT DATEADD(DAY, -6, @Hoy) AS fecha UNION ALL
        SELECT DATEADD(DAY, -5, @Hoy) UNION ALL
        SELECT DATEADD(DAY, -4, @Hoy) UNION ALL
        SELECT DATEADD(DAY, -3, @Hoy) UNION ALL
        SELECT DATEADD(DAY, -2, @Hoy) UNION ALL
        SELECT DATEADD(DAY, -1, @Hoy) UNION ALL
        SELECT @Hoy
    )
     SELECT
         FORMAT(d.fecha, 'dd/MM') AS fecha,
         ISNULL(AVG(CAST(v.pasajeros_confirmados AS FLOAT) / NULLIF(v.capacidad_total, 0) * 100), 0) AS ocupacion
     FROM Dias d
              LEFT JOIN vuelo v ON CAST(v.fecha_salida AS DATE) = d.fecha
         AND v.aerolinea_id = @aerolinea_id
     GROUP BY d.fecha
     ORDER BY d.fecha;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_PROXIMOS_VUELOS]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_PROXIMOS_VUELOS
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_PROXIMOS_VUELOS]
    @aerolinea_id INT,
    @limite INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@limite)
        v.numero_vuelo AS NumeroVuelo,
        ao.codigo_iata + ' → ' + ad.codigo_iata AS Ruta,
        v.fecha_salida AS FechaSalida,
        v.pasajeros_confirmados AS PasajerosConfirmados,
        v.capacidad_total AS CapacidadTotal,
        v.puerta AS Puerta,
        CAST((v.pasajeros_confirmados * 100.0 / NULLIF(v.capacidad_total, 0)) AS FLOAT) AS PorcentajeOcupacion
    FROM vuelo v
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE v.aerolinea_id = @aerolinea_id
      AND v.fecha_salida > GETDATE()
      AND v.estado_id IN (1, 2)
    ORDER BY v.fecha_salida;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RUTAS_DISPONIBLES_AEROLINEA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_RUTAS_DISPONIBLES_AEROLINEA
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_RUTAS_DISPONIBLES_AEROLINEA]
    @aerolinea_id INT,
    @aeropuerto_origen_id INT = NULL  -- NULL = todas las rutas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.id AS ruta_id,
        ao.codigo_iata + ' → ' + ad.codigo_iata AS codigo_ruta,
        ao.nombre AS aeropuerto_origen,
        ao.ciudad AS ciudad_origen,
        ad.nombre AS aeropuerto_destino,
        ad.ciudad AS ciudad_destino,
        r.distancia_km,
        ra.precio_base,
        ra.frecuencia_semanal,
        ra.activa,
        -- Duración estimada (800 km/h promedio)
        ROUND((r.distancia_km / 800.0) * 60, 0) AS duracion_minutos
    FROM ruta_aerolinea ra
             INNER JOIN ruta r ON ra.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE ra.aerolinea_id = @aerolinea_id
      AND ra.activa = 1
      AND (@aeropuerto_origen_id IS NULL OR r.aeropuerto_origen_id = @aeropuerto_origen_id)
    ORDER BY r.distancia_km;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA (MODIFICADO)
-- Solo muestra rutas que la aerolínea del avión opera
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_RUTAS_DISPONIBLES_POR_AVION_Y_FECHA]
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
        @estado_avion = ea.nombre,
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
        ao.codigo_iata AS codigo_origen,
        ao.nombre AS nombre_origen,
        ao.ciudad AS ciudad_origen,
        ao.latitud AS latitud_origen,
        ao.longitud AS longitud_origen,
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
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RUTAS_NO_OPERADAS]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_RUTAS_NO_OPERADAS
-- Rutas disponibles que la aerolínea NO opera aún
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_RUTAS_NO_OPERADAS]
@aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.id AS ruta_id,
        ao.codigo_iata + ' → ' + ad.codigo_iata AS codigo_ruta,
        ao.nombre AS aeropuerto_origen,
        ao.ciudad AS ciudad_origen,
        ad.nombre AS aeropuerto_destino,
        ad.ciudad AS ciudad_destino,
        r.distancia_km,
        -- Ver cuántas aerolíneas la operan
        (SELECT COUNT(*)
         FROM ruta_aerolinea
         WHERE ruta_id = r.id AND activa = 1) AS competidores
    FROM ruta r
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE NOT EXISTS (
        SELECT 1
        FROM ruta_aerolinea ra
        WHERE ra.ruta_id = r.id
          AND ra.aerolinea_id = @aerolinea_id
    )
    ORDER BY r.distancia_km;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RUTAS_POR_AVION]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[SP_GET_RUTAS_POR_AVION]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_TELEMETRIA_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_GET_TELEMETRIA_VUELO]
@vuelo_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Datos básicos del vuelo
    SELECT
        v.id AS vuelo_id,
        v.numero_vuelo,
        av.matricula,
        v.fecha_salida,
        v.fecha_llegada,
        ev.nombre AS estado,
        ao.codigo_iata AS origen,
        ad.codigo_iata AS destino,
        v.telemetria
    FROM vuelo v
             INNER JOIN avion av ON v.avion_id = av.id
             INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE v.id = @vuelo_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_TOP_RUTAS]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_TOP_RUTAS
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_TOP_RUTAS]
    @aerolinea_id INT,
    @dias INT = 30,
    @limite INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FechaInicio DATE = DATEADD(DAY, -@dias, CAST(GETDATE() AS DATE));

    SELECT TOP (@limite)
        ao.codigo_iata + ' → ' + ad.codigo_iata AS Ruta,
        COUNT(v.id) AS TotalVuelos,
        SUM(v.pasajeros_embarcados) AS TotalPasajeros
    FROM vuelo v
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
    WHERE v.aerolinea_id = @aerolinea_id
      AND v.fecha_salida >= @FechaInicio
    GROUP BY ao.codigo_iata, ad.codigo_iata
    ORDER BY COUNT(v.id) DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_TRIPULANTES_DISPONIBLES]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[SP_GET_TRIPULANTES_DISPONIBLES]
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
          AND v.estado_id NOT IN (4, 5, 7)
          AND @fecha_salida  < v.fecha_llegada
          AND @fecha_llegada > v.fecha_salida
          AND t.id_aerolinea=@aerolinea_id
    )

    ORDER BY t.rol, nombre_completo;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_TRIPULANTES_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[SP_GET_TRIPULANTES_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VUELOS_POR_ESTADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_VUELOS_POR_ESTADO
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_VUELOS_POR_ESTADO]
@aerolinea_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ev.nombre AS estado,
        COUNT(v.id) AS total
    FROM estado_vuelo ev
             LEFT JOIN vuelo v ON v.estado_id = ev.id AND v.aerolinea_id = @aerolinea_id
    GROUP BY ev.id, ev.nombre
    ORDER BY COUNT(v.id) DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VUELOS_POR_HORA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_VUELOS_POR_HORA
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_VUELOS_POR_HORA]
    @aerolinea_id INT,
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha IS NULL
        SET @fecha = CAST(GETDATE() AS DATE);

        -- ✅ SOLUCIÓN: Usar CTE en lugar de spt_values
        ;WITH Horas AS (
        SELECT 0 AS hora UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
        SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
        SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
        SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23
    )
         SELECT
             FORMAT(h.hora, '00') + ':00' AS hora,
             ISNULL(COUNT(v.id), 0) AS vuelos
         FROM Horas h
                  LEFT JOIN vuelo v ON DATEPART(HOUR, v.fecha_salida) = h.hora
             AND CAST(v.fecha_salida AS DATE) = @fecha
             AND v.aerolinea_id = @aerolinea_id
         GROUP BY h.hora
         ORDER BY h.hora;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VUELOS_RECIENTES]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- SP_GET_VUELOS_RECIENTES
-- ============================================
CREATE   PROCEDURE [dbo].[SP_GET_VUELOS_RECIENTES]
    @aerolinea_id INT,
    @limite INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@limite)
        v.numero_vuelo AS NumeroVuelo,
        ao.codigo_iata + ' → ' + ad.codigo_iata AS Ruta,
        ev.nombre AS Estado,
        v.fecha_salida AS Fecha,
        v.pasajeros_embarcados AS Pasajeros
    FROM vuelo v
             INNER JOIN ruta r ON v.ruta_id = r.id
             INNER JOIN aeropuerto ao ON r.aeropuerto_origen_id = ao.id
             INNER JOIN aeropuerto ad ON r.aeropuerto_destino_id = ad.id
             INNER JOIN estado_vuelo ev ON v.estado_id = ev.id
    WHERE v.aerolinea_id = @aerolinea_id
    ORDER BY v.fecha_salida DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GUARDAR_POSICION_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_GUARDAR_POSICION_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTO_CANCELAR]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================
--  SP: SP_MANTENIMIENTO_CANCELAR
--  Cancela el mantenimiento y restaura el avión.
-- =====================================================
CREATE   PROCEDURE [dbo].[SP_MANTENIMIENTO_CANCELAR]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTO_COMPLETAR]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================
--  SP: SP_MANTENIMIENTO_COMPLETAR
--  Cierra el mantenimiento y deja el avión "Operativo".
-- =====================================================
CREATE   PROCEDURE [dbo].[SP_MANTENIMIENTO_COMPLETAR]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTO_INICIAR]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_MANTENIMIENTO_INICIAR]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTOS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_MANTENIMIENTOS_PAGINADO]
    @PageNumber     INT            = 1,
    @PageSize       INT            = 10,
    @AerolineaId    INT            =1,
    @Estado         NVARCHAR(50)   = NULL,   -- NULL = todos
    @FechaProgramada DATE          = NULL,   -- NULL = cualquier fecha
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
GO
/****** Object:  StoredProcedure [dbo].[SP_PROGRAMAR_MANTENIMIENTO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[SP_PROGRAMAR_MANTENIMIENTO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_REGISTRAR_RETRASO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_REGISTRAR_RETRASO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_REGISTRAR_USUARIO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_REGISTRAR_USUARIO]
    @Nombre       NVARCHAR(50),
    @Apellidos    NVARCHAR(50),
    @Email        NVARCHAR(100),
    @Password     NVARCHAR(100),
    @IdAerolinea  INT,
    @Salt       NVARCHAR(50),
    @Pass      VARBINARY(MAX),
    @IdRol      INT =2
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
GO
/****** Object:  StoredProcedure [dbo].[SP_RUTAS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_RUTAS_PAGINADO]
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
    FROM V_RUTAS_AVION
    WHERE (@Busqueda IS NULL OR
           CODIGO_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           CODIGO_DESTINO  LIKE '%' + @Busqueda + '%' OR
           CIUDAD_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           CIUDAD_DESTINO  LIKE '%' + @Busqueda + '%' OR
           NOMBRE_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           NOMBRE_DESTINO  LIKE '%' + @Busqueda + '%');

    SELECT
        RUTA_ID,
        DISTANCIA_KM,
        ID_ORIGEN,
        CODIGO_ORIGEN,
        NOMBRE_ORIGEN,
        CIUDAD_ORIGEN,
        LATITUD_ORIGEN,
        LONGITUD_ORIGEN,
        ID_DESTINO,
        CODIGO_DESTINO,
        NOMBRE_DESTINO,
        CIUDAD_DESTINO,
        LATITUD_DESTINO,
        LONGITUD_DESTINO,
        DURACION_MINUTOS,
        DURACION_FORMATEADA,
        @TotalRegistros                                      AS total_registros,
        @PageNumber                                          AS pagina_actual,
        @PageSize                                            AS registros_por_pagina,
        CEILING(CAST(@TotalRegistros AS FLOAT) / @PageSize) AS total_paginas
    FROM V_RUTAS_AVION
    WHERE (@Busqueda IS NULL OR
           CODIGO_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           CODIGO_DESTINO  LIKE '%' + @Busqueda + '%' OR
           CIUDAD_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           CIUDAD_DESTINO  LIKE '%' + @Busqueda + '%' OR
           NOMBRE_ORIGEN   LIKE '%' + @Busqueda + '%' OR
           NOMBRE_DESTINO  LIKE '%' + @Busqueda + '%')
    ORDER BY CODIGO_ORIGEN, CODIGO_DESTINO
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TRIPULANTES_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_TRIPULANTES_PAGINADO]
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @Rol            NVARCHAR(50)  = NULL,
    @IdAerolinea    INT           = NULL,
    @Activo         BIT           = NULL,
    @Busqueda       NVARCHAR(100) = NULL,
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;


    SELECT @TotalRegistros = COUNT(*)
    FROM TRIPULANTE T
    WHERE
        (@Rol IS NULL OR T.ROL = @Rol)
      AND (@IdAerolinea IS NULL OR T.ID_AEROLINEA = @IdAerolinea)
      AND (@Activo IS NULL OR T.ACTIVO = @Activo)
      AND (@Busqueda IS NULL OR
           T.NOMBRE LIKE '%' + @Busqueda + '%' OR
           T.APELLIDO LIKE '%' + @Busqueda + '%');


    SELECT
        T.ID,
        T.ID_AEROLINEA,
        T.NOMBRE,
        T.APELLIDO,
        T.ROL,
        T.ACTIVO
    FROM TRIPULANTE T
    WHERE
        (@Rol IS NULL OR T.ROL = @Rol)
      AND (@IdAerolinea IS NULL OR T.ID_AEROLINEA = @IdAerolinea)
      AND (@Activo IS NULL OR T.ACTIVO = @Activo)
      AND (@Busqueda IS NULL OR
           T.NOMBRE LIKE '%' + @Busqueda + '%' OR
           T.APELLIDO LIKE '%' + @Busqueda + '%')
    ORDER BY T.ID ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_AEROLINEA]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_UPDATE_AEROLINEA]
    @idAerolinea INT,
    @nombre NVARCHAR(100),
    @logo NVARCHAR(250),
    @codIata NVARCHAR(3)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM aerolinea WHERE nombre = @nombre AND id <> @idAerolinea)
        BEGIN
            DECLARE @msgNombre NVARCHAR(200) = CONCAT('Ya existe la aerolinea: ', @nombre);
            RAISERROR(@msgNombre, 16, 1);
            RETURN;
        END


    IF EXISTS (SELECT 1 FROM aerolinea WHERE codigo_iata = @codIata AND id <> @idAerolinea)
        BEGIN
            DECLARE @msgIata NVARCHAR(200) = CONCAT('Ya existe el codigo IATA: ', @codIata);
            RAISERROR(@msgIata, 16, 1);
            RETURN;
        END

    UPDATE aerolinea SET nombre=@nombre,logo=@logo,codigo_iata=@codIata
    WHERE id=@idAerolinea
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_AEROPUERTO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_UPDATE_AEROPUERTO]
    @Id      INT,
    @Nombre  NVARCHAR(150),
    @IATA    NVARCHAR(3),
    @ICAO    NVARCHAR(4),
    @Ciudad  NVARCHAR(100),
    @PaisId  INT,
    @Latitud DECIMAL(9,6),
    @Longitud DECIMAL(9,6)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM AEROPUERTO WHERE ID = @Id)
        THROW 51000, 'No existe el aeropuerto.', 1;
    IF EXISTS (SELECT 1 FROM AEROPUERTO WHERE CODIGO_IATA = @IATA AND ID <> @Id)
        THROW 51000, 'Ya existe un aeropuerto con ese código IATA.', 1;
    IF EXISTS (SELECT 1 FROM AEROPUERTO WHERE CODIGO_ICAO = @ICAO AND ID <> @Id)
        THROW 51000, 'Ya existe un aeropuerto con ese código ICAO.', 1;

    UPDATE AEROPUERTO
    SET NOMBRE      = @Nombre,
        CODIGO_IATA = @IATA,
        CODIGO_ICAO = @ICAO,
        CIUDAD      = @Ciudad,
        PAIS_ID     = @PaisId,
        LATITUD     = @Latitud,
        LONGITUD    = @Longitud
    WHERE ID = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ESTADO_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[SP_UPDATE_ESTADO_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ESTADOVUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[SP_UPDATE_ESTADOVUELO]
(@idvuelo int, @idestado int)
AS
UPDATE VUELO SET estado_id=@idestado
WHERE id=@idvuelo
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_GESTION_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_UPDATE_GESTION_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_TRIPULACION]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_UPDATE_TRIPULACION]
(@idTripulacion INT,
 @idAerolinea INT,
 @nombre NVARCHAR(50),
 @apellido NVARCHAR(50),
 @rol NVARCHAR(50),
 @activo BIT =1
)
AS

UPDATE tripulante SET nombre=@nombre,apellido=@apellido,rol=@rol,activo=@activo
WHERE id= @idTripulacion
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_USUARIOS]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_UPDATE_USUARIOS]
(@idUsuario INT,
 @nombre NVARCHAR(50),
 @apellidos NVARCHAR(50),
 @rol NVARCHAR(50),
 @aerolinea NVARCHAR(50),
 @activo BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;


        DECLARE @idAerolinea INT;
        SELECT @idAerolinea = id FROM aerolinea WHERE nombre = @aerolinea;

        IF @idAerolinea IS NOT NULL
            BEGIN
                UPDATE usuario
                SET nombre = @nombre,
                    apellidos = @apellidos,
                    activo = @activo,
                    aerolinea_id=@idAerolinea
                WHERE id = @idUsuario;
            END

        DECLARE @idRol INT;
        SELECT @idRol = id FROM rol WHERE nombre = @rol;

        IF @idRol IS NOT NULL
            BEGIN
                UPDATE usuario_rol
                SET rol_id = @idRol
                WHERE usuario_id = @idUsuario;
            END


        COMMIT TRANSACTION;
        SELECT 'Usuario actualizado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[SP_UPDATE_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_USUARIOS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ══════════════════════════════════════════════════════════
--  SP_USUARIOS_PAGINADO
-- ══════════════════════════════════════════════════════════
create   PROCEDURE [dbo].[SP_USUARIOS_PAGINADO]
    @PageNumber     INT           = 1,
    @PageSize       INT           = 10,
    @AerolineaId    INT           = NULL,
    @Activo         BIT           = NULL,
    @Busqueda       NVARCHAR(100) = NULL,
    @TotalRegistros INT           OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNumber < 1   SET @PageNumber = 1;
    IF @PageSize   < 1   SET @PageSize   = 10;
    IF @PageSize   > 100 SET @PageSize   = 100;

    -- Total usando la vista directamente, igual que el resto de SPs
    SELECT @TotalRegistros = COUNT(*)
    FROM dbo.V_ADMINISTRACION_USUARIOS
    WHERE
        (@AerolineaId IS NULL OR AEROLINEA  = @AerolineaId)   -- añade esta columna a la vista si no existe
      AND (@Activo      IS NULL OR ACTIVO        = @Activo)
      AND (@Busqueda    IS NULL OR
           NOMBRE     LIKE '%' + @Busqueda + '%' OR
           APELLIDOS  LIKE '%' + @Busqueda + '%' OR
           EMAIL      LIKE '%' + @Busqueda + '%' OR
           ROL        LIKE '%' + @Busqueda + '%' OR
           AEROLINEA  LIKE '%' + @Busqueda + '%');

-- Página: devuelve las mismas columnas que la vista (ID, NOMBRE, APELLIDOS, EMAIL, ROL, AEROLINEA, ACTIVO)
    SELECT *
    FROM dbo.V_ADMINISTRACION_USUARIOS
    WHERE
        (@AerolineaId IS NULL OR aerolinea  = @AerolineaId)
      AND (@Activo      IS NULL OR ACTIVO        = @Activo)
      AND (@Busqueda    IS NULL OR
           NOMBRE     LIKE '%' + @Busqueda + '%' OR
           APELLIDOS  LIKE '%' + @Busqueda + '%' OR
           EMAIL      LIKE '%' + @Busqueda + '%' OR
           ROL        LIKE '%' + @Busqueda + '%' OR
           AEROLINEA  LIKE '%' + @Busqueda + '%')
    ORDER BY APELLIDOS ASC, NOMBRE ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDADICION_CREACION_VUELO]    Script Date: 16/03/2026 14:02:32 ******/

/****** Object:  StoredProcedure [dbo].[SP_VALIDAR_TRIPULACION_VUELO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[SP_VALIDAR_TRIPULACION_VUELO]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_VUELOS_PAGINADO]    Script Date: 16/03/2026 14:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[SP_VUELOS_PAGINADO]
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
           matricula    LIKE '%' + @Busqueda + '%' OR
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
           matricula    LIKE '%' + @Busqueda + '%' OR
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
GO
