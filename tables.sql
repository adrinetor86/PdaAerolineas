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

