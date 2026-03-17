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

create table dbo.aerolinea
(
    id          int identity
        primary key,
    nombre      nvarchar(100)            not null
        constraint UQ_Aerolinea_Nombre
            unique,
    logo        nvarchar(250) default '' not null,
    codigo_iata nvarchar(3)              not null
        unique
)
go

create table dbo.codigo_retraso_iata
(
    id          int identity
        primary key,
    codigo      nvarchar(5)   not null,
    descripcion nvarchar(250) not null
)
go

create table dbo.estado_avion
(
    id     int identity
        primary key,
    nombre nvarchar(50) not null
        unique
)
go

create table dbo.estado_vuelo
(
    id     int identity
        primary key,
    nombre nvarchar(50) not null
        unique
)
go

create table dbo.mantenimiento_tipo
(
    id               int identity
        primary key,
    nombre           nvarchar(100) not null
        unique,
    intervalo_horas  int default 0,
    intervalo_ciclos int default 0,
    intervalo_dias   int default 0
)
go

create table dbo.modelo_avion
(
    id              int identity
        primary key,
    fabricante      nvarchar(100) not null,
    nombre_modelo   nvarchar(100) not null,
    capacidad_total int           not null,
    alcance_km      int           not null
)
go

create table dbo.pais
(
    id         int identity
        primary key,
    nombre     nvarchar(100) not null,
    codigo_iso nvarchar(3)   not null
        unique
)
go

create table dbo.aeropuerto
(
    id          int identity
        primary key,
    nombre      nvarchar(150) not null,
    codigo_iata nvarchar(3)   not null
        unique,
    codigo_icao nvarchar(4)   not null
        unique,
    ciudad      nvarchar(100) not null,
    pais_id     int           not null
        references dbo.pais,
    latitud     decimal(9, 6) not null,
    longitud    decimal(9, 6) not null
)
go

create table dbo.avion
(
    id                   int identity
        primary key,
    matricula            nvarchar(20)  not null
        unique,
    modelo_id            int           not null
        references dbo.modelo_avion,
    aerolinea_id         int           not null
        references dbo.aerolinea,
    estado_id            int           not null
        references dbo.estado_avion,
    aeropuerto_actual_id int           not null
        references dbo.aeropuerto,
    horas_vuelo_totales  int default 0 not null,
    ciclos_totales       int default 0 not null
)
go

create table dbo.mantenimiento
(
    id                    int identity
        primary key,
    avion_id              int                               not null
        references dbo.avion,
    mantenimiento_tipo_id int                               not null
        references dbo.mantenimiento_tipo,
    estado                nvarchar(50) default 'Programado' not null
        constraint CK_mantenimiento_estado
            check ([estado] = 'Cancelado' OR [estado] = 'Completado' OR [estado] = 'En Curso' OR
                   [estado] = 'Programado'),
    fecha_programada      date                              not null,
    fecha_inicio          datetime,
    fecha_fin             datetime,
    descripcion           nvarchar(max)
)
go

create table dbo.registro_estado_avion
(
    id            int identity
        primary key,
    avion_id      int                     not null
        references dbo.avion,
    aeropuerto_id int                     not null
        references dbo.aeropuerto,
    latitud       decimal(9, 6) default 0 not null,
    longitud      decimal(9, 6) default 0 not null,
    fecha_hora    datetime                not null
)
go

create table dbo.rol
(
    id     int identity
        primary key,
    nombre nvarchar(50) not null
        unique
)
go

create table dbo.ruta
(
    id                    int identity
        primary key,
    aeropuerto_origen_id  int not null
        references dbo.aeropuerto,
    aeropuerto_destino_id int not null
        references dbo.aeropuerto,
    distancia_km          int not null
)
go

create table dbo.ruta_aerolinea
(
    id                 int identity
        primary key,
    ruta_id            int            not null
        constraint FK_rutaAerolinea_ruta
            references dbo.ruta,
    aerolinea_id       int            not null
        constraint FK_rutaAerolinea_aerolinea
            references dbo.aerolinea,
    activa             bit  default 1 not null,
    precio_base        decimal(10, 2),
    frecuencia_semanal int,
    fecha_inicio       date default getdate(),
    fecha_fin          date,
    observaciones      nvarchar(500),
    constraint UQ_rutaAerolinea
        unique (ruta_id, aerolinea_id)
)
go

create index IX_rutaAerolinea_aerolinea
    on dbo.ruta_aerolinea (aerolinea_id)
go

create index IX_rutaAerolinea_activa
    on dbo.ruta_aerolinea (activa)
    where [activa] = 1
go


create table dbo.tripulante
(
    id           int identity
        primary key,
    id_aerolinea int,
    nombre       nvarchar(100) not null,
    apellido     nvarchar(100) not null,
    rol          nvarchar(50)  not null
        constraint CK_tripulante_rol
            check ([rol] = 'Tripulante de Cabina' OR [rol] = 'Primer Oficial' OR [rol] = 'Comandante'),
    activo       bit default 1 not null
)
go

create table dbo.usuario
(
    id           int identity
        primary key,
    nombre       nvarchar(50)  not null,
    apellidos    nvarchar(50)  not null,
    email        nvarchar(100) not null
        unique,
    password     nvarchar(100) not null,
    aerolinea_id int           not null
        references dbo.aerolinea,
    activo       bit default 1 not null
)
go

create table dbo.users_security
(
    id_usuario int            not null
        primary key
        constraint FK_Security_Usuario
            references dbo.usuario
            on delete cascade,
    salt       nvarchar(50)   not null,
    pass       varbinary(max) not null
)
go

create table dbo.usuario_rol
(
    usuario_id int not null
        references dbo.usuario,
    rol_id     int not null
        references dbo.rol,
    primary key (usuario_id, rol_id)
)
go

create table dbo.vuelo
(
    id                    int identity
        primary key,
    numero_vuelo          nvarchar(10)            not null,
    aerolinea_id          int                     not null
        references dbo.aerolinea,
    ruta_id               int                     not null
        references dbo.ruta,
    avion_id              int                     not null
        references dbo.avion,
    fecha_salida          datetime                not null,
    fecha_llegada         datetime                not null,
    estado_id             int                     not null
        references dbo.estado_vuelo,
    puerta                nvarchar(10) default '' not null,
    capacidad_total       int                     not null,
    pasajeros_confirmados int          default 0  not null,
    pasajeros_embarcados  int          default 0  not null,
    telemetria            nvarchar(max)
        constraint CK_tracking_posiciones_json
            check (isjson([telemetria]) = 1 OR [telemetria] IS NULL)
)
go

create table dbo.asignacion_tripulacion
(
    id            int identity
        primary key,
    tripulante_id int not null
        references dbo.tripulante,
    vuelo_id      int not null
        references dbo.vuelo,
    constraint UQ_tripulante_vuelo
        unique (tripulante_id, vuelo_id)
)
go

create table dbo.retraso_vuelo
(
    id                int identity
        primary key,
    vuelo_id          int not null
        references dbo.vuelo,
    codigo_retraso_id int not null
        references dbo.codigo_retraso_iata,
    minutos           int not null
)
go

INSERT INTO pais (nombre, codigo_iso)
VALUES ('España', 'ESP'),
       ('Reino Unido', 'GBR'),
       ('Francia', 'FRA'),
       ('Alemania', 'DEU'),
       ('Italia', 'ITA'),
       ('Portugal', 'PRT'),
       ('Estados Unidos', 'USA'),
       ('México', 'MEX'),
       ('Argentina', 'ARG'),
       ('Brasil', 'BRA');

-- ============================================
-- AEROPUERTOS
-- ============================================
-- RECUERDA: La columna codigo_icao es obligatoria ahora
INSERT INTO aeropuerto (nombre, codigo_iata, codigo_icao, ciudad, pais_id, latitud, longitud)
VALUES
    -- ESPAÑA (Prefijo LE)
    ('Adolfo Suárez Madrid-Barajas', 'MAD', 'LEMD', 'Madrid', 1, 40.471926, -3.568381),
    ('Barcelona-El Prat', 'BCN', 'LEBL', 'Barcelona', 1, 41.297078, 2.078464),
    ('Málaga-Costa del Sol', 'AGP', 'LEMG', 'Málaga', 1, 36.674919, -4.499106),
    ('Palma de Mallorca', 'PMI', 'LEPA', 'Palma de Mallorca', 1, 39.551694, 2.738806),
    ('Alicante-Elche', 'ALC', 'LEAL', 'Alicante', 1, 38.282169, -0.558156),
    ('Sevilla', 'SVQ', 'LEZL', 'Sevilla', 1, 37.418000, -5.893106),
    ('Valencia', 'VLC', 'LEVC', 'Valencia', 1, 39.489314, -0.481625),
    ('Bilbao', 'BIO', 'LEBB', 'Bilbao', 1, 43.301094, -2.910608),

    -- EUROPA
    ('London Heathrow', 'LHR', 'EGLL', 'Londres', 2, 51.470022, -0.454296),
    ('Paris Charles de Gaulle', 'CDG', 'LFPG', 'París', 3, 49.009724, 2.547778),
    ('Frankfurt', 'FRA', 'EDDF', 'Frankfurt', 4, 50.026421, 8.543125),
    ('Munich', 'MUC', 'EDDM', 'Munich', 4, 48.353783, 11.786086),
    ('Rome Fiumicino', 'FCO', 'LIRF', 'Roma', 5, 41.800278, 12.238889),
    ('Milan Malpensa', 'MXP', 'LIMC', 'Milán', 5, 45.630606, 8.728111),
    ('Lisbon Portela', 'LIS', 'LPPT', 'Lisboa', 6, 38.781311, -9.135919),

    -- AMÉRICA
    ('John F. Kennedy', 'JFK', 'KJFK', 'Nueva York', 7, 40.639722, -73.778889),
    ('Miami International', 'MIA', 'KMIA', 'Miami', 7, 25.795865, -80.287046),
    ('Mexico City', 'MEX', 'MMMX', 'Ciudad de México', 8, 19.436303, -99.072097),
    ('Buenos Aires Ezeiza', 'EZE', 'SAEZ', 'Buenos Aires', 9, -34.822222, -58.535833),
    ('São Paulo Guarulhos', 'GRU', 'SBGR', 'São Paulo', 10, -23.432075, -46.469511);
-- ============================================
-- RUTAS (igual que tu modelo original)
-- ============================================
INSERT INTO ruta (aeropuerto_origen_id, aeropuerto_destino_id, distancia_km)
VALUES (1, 2, 505),
       (1, 3, 417),
       (1, 4, 560),
       (1, 5, 354),
       (1, 6, 391),
       (1, 7, 303),
       (1, 8, 322),
       (1, 9, 1265),
       (1, 10, 1055),
       (1, 11, 1435),
       (1, 12, 1520),
       (1, 13, 1365),
       (1, 14, 1245),
       (1, 15, 502),
       (1, 16, 5770),
       (1, 17, 7120),
       (1, 18, 9200),
       (1, 19, 10075),
       (1, 20, 8388),
       (2, 9, 1140),
       (2, 10, 830),
       (2, 13, 856),
       (2, 15, 1005),
       (2, 1, 505),
       (9, 1, 1265),
       (10, 1, 1055),
       (16, 1, 5770),
       (15, 1, 502);

-- ============================================
-- AEROLÍNEA
-- ============================================
INSERT INTO aerolinea (nombre, logo, codigo_iata)
VALUES ('Iberia', 'https://www.iberia.com/images/logo.svg', 'IB'),
       ('Ryanair', 'https://1000marcas.net/wp-content/uploads/2020/01/Ryanair-Logotipo.jpg', 'FR');

INSERT INTO aerolinea (nombre, logo, codigo_iata)
VALUES
    ('Vueling', 'https://1000marcas.net/wp-content/uploads/2020/11/Vueling-Logo.png', 'VY'),
    ('Air Europa', 'https://1000marcas.net/wp-content/uploads/2020/01/Air-Europa-Logo.png', 'UX'),
    ('Lufthansa', 'https://1000marcas.net/wp-content/uploads/2020/03/Lufthansa-Logo.png', 'LH');
-- ============================================
-- ESTADOS AVIÓN
-- ============================================
INSERT INTO estado_avion (nombre)
VALUES ('Operativo'),
       ('En Mantenimiento'),
       ('En Vuelo'),
       ('Fuera de Servicio');


-- ============================================
-- MODELOS AVIÓN
-- ============================================
INSERT INTO modelo_avion (fabricante, nombre_modelo, capacidad_total, alcance_km)
VALUES ('Airbus', 'A319-100', 138, 6850),
       ('Airbus', 'A320-200', 180, 6100),
       ('Airbus', 'A320neo', 180, 6300),
       ('Airbus', 'A321-200', 200, 5950),
       ('Airbus', 'A321neo', 220, 7400),
       ('Airbus', 'A330-200', 288, 13450),
       ('Airbus', 'A330-300', 348, 11750),
       ('Airbus', 'A350-900', 348, 15000),
       ('ATR', 'ATR 72-600', 68, 1528),
       ('Bombardier', 'CRJ-1000', 100, 2761);


INSERT INTO avion (matricula, modelo_id, aerolinea_id, estado_id, aeropuerto_actual_id, horas_vuelo_totales,
                   ciclos_totales)
VALUES ('EC-ILQ', 2, 1, 1, 1, 45230, 28450),
       ('EC-ILS', 2, 1, 1, 1, 42180, 26890),
       ('EC-IZR', 2, 1, 4, 1, 38920, 24510),
       ('EC-JFN', 3, 1, 1, 1, 12450, 7820),
       ('EC-MXV', 3, 1, 1, 2, 14230, 8950),
       ('EC-NGR', 3, 1, 1, 1, 11680, 7340),
       ('EC-LVT', 4, 1, 1, 1, 52340, 31200),
       ('EC-JRE', 4, 1, 4, 1, 48920, 29450),
       ('EC-NIA', 5, 1, 1, 1, 8920, 5630),
       ('EC-NIB', 5, 1, 1, 1, 9450, 5980),
       ('EC-LUK', 6, 1, 1, 1, 68450, 15230),
       ('EC-LUX', 6, 1, 2, 1, 71230, 16450),
       ('EC-LZJ', 7, 1, 1, 1, 75680, 17890),
       ('EC-MHL', 7, 1, 1, 1, 72340, 16920),
       ('EC-MIG', 7, 1, 4, 1, 69870, 16120),
       ('EC-MYX', 8, 1, 1, 1, 18450, 4230),
       ('EC-NBE', 8, 1, 1, 1, 16780, 3890),
       ('EC-NDR', 8, 1, 1, 1, 15230, 3540),
       ('EC-NOM', 8, 1, 4, 1, 14680, 3420),
       ('EC-NSI', 8, 1, 1, 1, 13920, 3250),
       ('EC-JFH', 1, 1, 1, 2, 56780, 35420),
       ('EC-KHN', 1, 1, 1, 1, 62340, 38920),
       ('EC-KXD', 1, 1, 1, 1, 58920, 36780),
       ('EC-MSN', 9, 1, 1, 6, 12340, 18920),
       ('EC-MSZ', 9, 1, 1, 3, 11680, 17450),
       ('EC-MPA', 10, 1, 1, 4, 22340, 28920),
       ('EC-MQB', 10, 1, 2, 1, 24680, 31250);


-- ESTADOS DE VUELO
INSERT INTO estado_vuelo (nombre)
VALUES ('Programado'),
       ('Embarcando'),
       ('En Vuelo'),
       ('Aterrizado'),
       ('Cancelado'),
       ('Retrasado'),
       ('Completado');

INSERT INTO ROL(nombre)
VALUES('Administrador'),
      ('Gestor'),
      ('Mecanico')
-- VUELOS
INSERT INTO vuelo (numero_vuelo, aerolinea_id, ruta_id, avion_id, fecha_salida, fecha_llegada, estado_id, puerta,
                   capacidad_total, pasajeros_confirmados, pasajeros_embarcados)
VALUES ('IB6251', 1, 1, 1, '15/02/2026 07:00', '15/02/2026 08:25', 1, 'T4-S42', 180, 156, 0),
       ('IB6252', 1, 24, 2, '15/02/2026 09:30', '15/02/2026 10:55', 1, 'T4-S45', 180, 172, 0),
       ('IB2610', 1, 2, 21, '15/02/2026 08:15', '15/02/2026 09:20', 1, 'T4-S38', 138, 132, 0),
       ('IB2611', 1, 2, 22, '15/02/2026 14:30', '15/02/2026 15:35', 1, 'T4-S40', 138, 125, 0),
       ('IB3902', 1, 3, 4, '15/02/2026 10:45', '15/02/2026 12:30', 1, 'T4-S50', 180, 168, 0),
       ('IB8750', 1, 4, 5, '15/02/2026 11:30', '15/02/2026 12:45', 1, 'T4-S52', 180, 154, 0),
       ('IB3162', 1, 8, 7, '15/02/2026 06:30', '15/02/2026 09:15', 1, 'T4-S80', 200, 189, 0),
       ('IB3163', 1, 25, 8, '15/02/2026 11:45', '15/02/2026 14:30', 1, 'T4-S82', 200, 195, 0),
       ('IB3100', 1, 9, 23, '15/02/2026 07:45', '15/02/2026 09:45', 1, 'T4-S75', 138, 136, 0),
       ('IB3101', 1, 26, 3, '15/02/2026 12:30', '15/02/2026 14:30', 3, '', 180, 178, 178),
       ('IB6251', 1, 15, 16, '15/02/2026 11:30', '15/02/2026 14:45', 1, 'T4-S90', 348, 326, 0),
       ('IB6261', 1, 16, 17, '15/02/2026 13:15', '15/02/2026 19:30', 1, 'T4-S92', 348, 312, 0),
       ('IB6403', 1, 17, 18, '15/02/2026 23:45', '16/02/2026 09:20', 1, 'T4-S95', 348, 289, 0),
       ('IB6845', 1, 18, 19, '14/02/2026 22:30', '15/02/2026 14:35', 3, '', 348, 341, 341),
       ('IB6701', 1, 19, 20, '15/02/2026 18:30', '16/02/2026 06:45', 1, 'T4-S98', 348, 298, 0),
       ('IB3162', 1, 8, 11, '14/02/2026 06:30', '14/02/2026 09:15', 4, 'T4-S80', 288, 256, 256),
       ('IB2610', 1, 2, 6, '14/02/2026 20:15', '14/02/2026 21:20', 4, 'T4-S38', 180, 167, 167),
       ('IB8780', 1, 5, 24, '15/02/2026 16:30', '15/02/2026 17:25', 1, 'T4-20', 68, 64, 0),
       ('IB8790', 1, 6, 25, '15/02/2026 18:45', '15/02/2026 19:45', 1, 'T4-22', 68, 58, 0),
       ('IB8510', 1, 7, 26, '15/02/2026 15:15', '15/02/2026 16:10', 1, 'T4-25', 100, 87, 0);


-- CÓDIGOS IATA DE RETRASO
INSERT INTO codigo_retraso_iata (codigo, descripcion)
VALUES ('OA', 'No gate/stand availability due to own airline activity'),
       ('SG', 'Scheduled ground time less than declared minimum ground time'),
       ('PD', 'Late check-in after deadline'),
       ('PL', 'Late check-in congestion'),
       ('PE', 'Check-in error passenger/baggage'),
       ('PO', 'Oversales booking errors'),
       ('PH', 'Boarding discrepancies'),
       ('PS', 'Passenger convenience/VIP'),
       ('PC', 'Catering order issue'),
       ('PB', 'Baggage processing'),
       ('PW', 'Reduced mobility'),
       ('CD', 'Cargo documentation errors'),
       ('CP', 'Late cargo positioning'),
       ('CC', 'Late cargo acceptance'),
       ('CI', 'Inadequate packing'),
       ('CO', 'Cargo oversales'),
       ('CU', 'Late warehouse preparation'),
       ('CE', 'Mail documentation/packing'),
       ('CL', 'Mail late positioning'),
       ('CA', 'Mail late acceptance'),
       ('GD', 'Aircraft documentation late'),
       ('GL', 'Loading/unloading issues'),
       ('GE', 'Loading equipment issue'),
       ('GS', 'Servicing equipment issue'),
       ('GC', 'Aircraft cleaning'),
       ('GF', 'Fuelling/defuelling'),
       ('GB', 'Catering delivery'),
       ('GU', 'ULD issue'),
       ('GT', 'Technical ground equipment'),
       ('TD', 'Aircraft defects'),
       ('TM', 'Scheduled maintenance late release'),
       ('TN', 'Non scheduled maintenance'),
       ('TS', 'Spares/maintenance equipment'),
       ('TA', 'AOG spares transport'),
       ('TC', 'Aircraft change technical'),
       ('TL', 'Standby aircraft unavailable'),
       ('TV', 'Cabin configuration adjustment'),
       ('DF', 'Damage during flight operations'),
       ('DG', 'Damage during ground operations'),
       ('ED', 'Departure control'),
       ('EC', 'Cargo preparation/documentation'),
       ('EF', 'Flight plans'),
       ('EO', 'Other automated system'),
       ('FP', 'Flight plan documentation'),
       ('FF', 'Operational requirements'),
       ('FT', 'Late crew boarding procedures'),
       ('FS', 'Flight deck crew shortage'),
       ('FR', 'Flight deck crew special request'),
       ('FL', 'Late cabin crew boarding'),
       ('FC', 'Cabin crew shortage'),
       ('FA', 'Cabin crew error'),
       ('FB', 'Captain security request'),
       ('WO', 'Weather departure'),
       ('WT', 'Weather destination'),
       ('WR', 'Weather en route'),
       ('WI', 'De-icing aircraft'),
       ('WS', 'Snow/ice removal airport'),
       ('WG', 'Ground handling weather'),
       ('AT', 'ATFM ATC demand/capacity'),
       ('AX', 'ATFM staff/equipment'),
       ('AE', 'ATFM destination restriction'),
       ('AW', 'ATFM weather destination'),
       ('AS', 'Mandatory security'),
       ('AG', 'Immigration/customs/health'),
       ('AF', 'Airport facilities'),
       ('AD', 'Destination airport restriction'),
       ('AM', 'Departure airport restriction'),
       ('RL', 'Load connection'),
       ('RT', 'Through check-in error'),
       ('RA', 'Aircraft rotation'),
       ('RS', 'Cabin crew rotation'),
       ('RC', 'Crew rotation'),
       ('RO', 'Operations control'),
       ('MI', 'Industrial action own airline'),
       ('MO', 'Industrial action external'),
       ('MX', 'Other reason');

-- RETRASOS DE VUELO
INSERT INTO retraso_vuelo (vuelo_id, codigo_retraso_id, minutos)
VALUES (10, 59, 35),
       (14, 53, 45),
       (7, 30, 25),
       (12, 26, 15);

-- TIPOS DE MANTENIMIENTO
INSERT INTO mantenimiento_tipo (nombre, intervalo_horas, intervalo_ciclos, intervalo_dias)
VALUES ('Inspección A-Check', 750, 0, 90),
       ('Inspección C-Check', 7500, 0, 18),
       ('Inspección D-Check', 30000, 0, 72),
       ('Inspección Diaria', 24, 0, 1),
       ('Inspección Semanal', 168, 0, 7),
       ('Revisión de Motores', 5000, 0, 0),
       ('Revisión de Tren de Aterrizaje', 0, 15000, 0),
       ('Inspección de Emergencia', 0, 0, 0);


-- EVENTOS DE MANTENIMIENTO
INSERT INTO mantenimiento (avion_id, mantenimiento_tipo_id, estado, fecha_programada, fecha_inicio, fecha_fin,
                           descripcion)
VALUES (12, 2, 'Completado', '10/02/2026', '10/02/2026 08:00', '14/02/2026 18:00',
        'C-Check - Inspección estructural completa'),
       (27, 1, 'En Curso', '14/02/2026', '14/02/2026 06:00', NULL, 'A-Check en curso - Revisión de sistemas'),
       (1, 4, 'Completado', '14/02/2026', '14/02/2026 23:00', '15/02/2026 01:30', 'Inspección diaria completada'),
       (6, 4, 'Completado', '14/02/2026', '14/02/2026 22:30', '15/02/2026 00:45', 'Inspección diaria - Sin anomalías'),
       (11, 8, 'Completado', '12/02/2026', '12/02/2026 14:00', '12/02/2026 22:00',
        'Inspección de emergencia - Reemplazo sensor hidráulico');


-- ============================================
-- TRIPULANTES
-- ============================================
INSERT INTO tripulante (nombre, apellido, rol, id_aerolinea, activo)
VALUES
-- ==========================================
-- IBERIA (ID: 1)
-- ==========================================
('Carlos', 'Martínez', 'Comandante', 1, 1),
('Ana', 'García', 'Comandante', 1, 1),
('Pablo', 'Moreno', 'Primer Oficial', 1, 1),
('Elena', 'Álvarez', 'Primer Oficial', 1, 1),
('Marta', 'Gil', 'Tripulante de Cabina', 1, 1),
('Jorge', 'Castro', 'Tripulante de Cabina', 1, 1),
('Sandra', 'Ortiz', 'Tripulante de Cabina', 1, 1),
('Daniel', 'Rubio', 'Tripulante de Cabina', 1, 1),

-- ==========================================
-- RYANAIR (ID: 2)
-- ==========================================
('Michael', 'O''Connor', 'Comandante', 2, 1),
('Sarah', 'Kelly', 'Comandante', 2, 1),
('John', 'Murphy', 'Primer Oficial', 2, 1),
('Emma', 'Walsh', 'Primer Oficial', 2, 1),
('Liam', 'O''Brien', 'Tripulante de Cabina', 2, 1),
('Chloe', 'Byrne', 'Tripulante de Cabina', 2, 1),
('Conor', 'Ryan', 'Tripulante de Cabina', 2, 1),
('Aoife', 'Doyle', 'Tripulante de Cabina', 2, 1),

-- ==========================================
-- VUELING (ID: 3)
-- ==========================================
('Marc', 'Vidal', 'Comandante', 3, 1),
('Laia', 'Ferrer', 'Comandante', 3, 1),
('Pol', 'Serra', 'Primer Oficial', 3, 1),
('Nuria', 'Pujol', 'Primer Oficial', 3, 1),
('Jordi', 'Vila', 'Tripulante de Cabina', 3, 1),
('Mireia', 'Soler', 'Tripulante de Cabina', 3, 1),
('Albert', 'Martí', 'Tripulante de Cabina', 3, 1),
('Carla', 'Rovira', 'Tripulante de Cabina', 3, 1),

-- ==========================================
-- AIR EUROPA (ID: 4)
-- ==========================================
('Javier', 'Pérez', 'Comandante', 4, 1),
('Carmen', 'Ruiz', 'Comandante', 4, 1),
('Sergio', 'Romero', 'Primer Oficial', 4, 1),
('Lucía', 'Navarro', 'Primer Oficial', 4, 1),
('Roberto', 'Delgado', 'Tripulante de Cabina', 4, 1),
('Silvia', 'Herrera', 'Tripulante de Cabina', 4, 1),
('Fernando', 'Medina', 'Tripulante de Cabina', 4, 1),
('Cristina', 'Iglesias', 'Tripulante de Cabina', 4, 1),

-- ==========================================
-- LUFTHANSA (ID: 5)
-- ==========================================
('Klaus', 'Müller', 'Comandante', 5, 1),
('Hannah', 'Schmidt', 'Comandante', 5, 1),
('Lukas', 'Weber', 'Primer Oficial', 5, 1),
('Julia', 'Wagner', 'Primer Oficial', 5, 1),
('Felix', 'Becker', 'Tripulante de Cabina', 5, 1),
('Anna', 'Hoffmann', 'Tripulante de Cabina', 5, 1),
('Maximilian', 'Koch', 'Tripulante de Cabina', 5, 1),
('Sophie', 'Richter', 'Tripulante de Cabina', 5, 1);
-- ============================================
-- ASIGNACIÓN TRIPULACIÓN (NUEVO FORMATO)
-- ============================================
INSERT INTO asignacion_tripulacion (tripulante_id, vuelo_id)
VALUES (1, 1),
       (11, 1),
       (16, 1),
       (17, 1),
       (18, 1),

       (2, 2),
       (12, 2),
       (19, 2),
       (20, 2),
       (21, 2),

       (5, 11),
       (6, 11),
       (13, 11),
       (14, 11),
       (22, 11),
       (23, 11),
       (24, 11),
       (25, 11),
       (16, 11),
       (17, 11);


INSERT INTO dbo.usuario (nombre, apellidos, email, password, aerolinea_id, activo)
VALUES ('Adrian', 'Jacek', 'admin@gmail.com', '12345', 1, 1);


-- Obtenemos el ID del usuario recién creado
DECLARE @UserId INT = SCOPE_IDENTITY();

-- 2. Insertar la seguridad (Hash y Salt)
-- '0x010203...' simula el varbinary de una contraseña hasheada
INSERT INTO dbo.users_security (id_usuario, salt, pass)
VALUES (@UserId, 'Â|êak5=«àÚÞÐMSuPLÏÌñ§ë!¶[­øT¼ÊEÞñ¢', CAST('0x9159FFFCFE6634031A549CDFD0AF0C285519F2FF0D793B1AF8710C84DFB4660BB3FCBAD3A4EE8F312E9BB7C7D0C2B6079913166C07AEDC5F6E69109A862DF947' AS VARBINARY(MAX)));

-- 3. Asignar el Rol (Asumiendo que el ID 1 es 'Administrador')
INSERT INTO dbo.usuario_rol (usuario_id, rol_id)
VALUES (@UserId, 1);
