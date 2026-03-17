using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.FormViews;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories;

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
        string sql =
            "EXEC SP_VUELOS_PAGINADO @PageNumber, @PageSize, @EstadoId, @AerolineaId, @FechaSalida, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);

        var pamEstado = new SqlParameter("@EstadoId", idEstado.HasValue ? idEstado.Value : DBNull.Value);
        var pamAerolinea = new SqlParameter("@AerolineaId", idAerolinea.HasValue ? idAerolinea.Value : DBNull.Value);
        
        var pamSalida = new SqlParameter("@FechaSalida", fechaSalida.HasValue ? fechaSalida.Value.Date : DBNull.Value);

        var pamBusqueda = new SqlParameter("@Busqueda",
            string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda!.Trim());

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
    public async Task<List<VistaVuelo>> GetVuelosAvanzadoAsync(int numPag, int numFilas, int? idEstado,
        int? idAerolinea,
        DateTime? fechaSalida, string? busqueda)
    {
        var (vuelos, _) =
            await GetVuelosPaginadosConTotalAsync(numPag, numFilas, idEstado, idAerolinea, fechaSalida, busqueda);
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

    public async Task<List<Avion>> GetAvionesByDisponiblesAsync(int? idAerolinea)
    {
        var consulta = from datos in _context.Aviones
            where datos.IdAerolinea == idAerolinea
            where datos.IdEstado == 1
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
        // Obtener aeropuerto actual y aerolínea del avión
        var avion = await _context.Aviones
            .Where(a => a.IdAvion == idAvion)
            .Select(a => new { a.IdAeropuertoActual, a.IdAerolinea })
            .FirstOrDefaultAsync();

        if (avion == null || avion.IdAeropuertoActual == 0)
            return new List<VistaRuta>();

        // Obtener IDs de rutas activas para esta aerolínea
        var rutasActivasIds = await _context.RutasAerolinea
            .Where(ra => ra.AerolineaId == avion.IdAerolinea && ra.Activa)
            .Select(ra => ra.RutaId)
            .ToListAsync();

        // Filtrar rutas que salen del aeropuerto actual Y que la aerolínea opera
        var rutas = await _context.VistaRutas
            .Where(r => r.IdOrigen == avion.IdAeropuertoActual && rutasActivasIds.Contains(r.Id))
            .ToListAsync();

        return rutas;
    }

    // Obtener solo aviones que están en aeropuertos desde donde la aerolínea tiene rutas activas
    public async Task<List<Avion>> GetAvionesConRutasDisponiblesAsync(int idAerolinea)
    {

        string sql = "SP_AVIONES_CON_RUTAS_DISPONIBLES @AerolineaId";
        
        SqlParameter pamAerolinea = new SqlParameter("@AerolineaId", idAerolinea);
        
        

        return await _context.Aviones.FromSqlRaw(sql, pamAerolinea).ToListAsync();
    }

    

    public VueloCache GetVueloCache(int idVuelo)
    {
        var key = $"VUELO_{idVuelo}";
        _memoryCache.TryGetValue(key, out VueloCache vuelo);
        return vuelo;
    }


    public void SaveVueloCache(VueloCache datos)
    {
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
            if (datos.IdCapitan <= 0)
                errores.Add(new FormError { Field = "IdCapitan", Message = "Debe asignar un Comandante." });
            if (datos.IdCopiloto <= 0)
                errores.Add(new FormError { Field = "IdCopiloto", Message = "Debe asignar un Primer Oficial." });
            if (datos.IdsTcp == null || datos.IdsTcp.Count < 4)
                errores.Add(new FormError
                    { Field = "IdsTcp", Message = "Se requiere un mínimo de 4 tripulantes de cabina (TCP)." });
        }

        if (datos.IdEstado == 2)
        {
            if (string.IsNullOrWhiteSpace(datos.Puerta))
                errores.Add(new FormError { Field = "Puerta", Message = "Debe asignar una puerta de embarque." });
            if (datos.PasajerosConfirmados <= 0)
                errores.Add(new FormError
                    { Field = "PasajerosConfirmados", Message = "Los pasajeros confirmados deben ser mayor a 0." });
            if (datos.PasajerosEmbarcados < 0)
                errores.Add(new FormError
                    { Field = "PasajerosEmbarcados", Message = "El combustible cargado no puede ser negativo." });
            if (datos.PasajerosEmbarcados > datos.PasajerosConfirmados)
                errores.Add(new FormError
                {
                    Field = "PasajerosEmbarcados",
                    Message = "El combustible cargado no puede superar al confirmado."
                });
        }

        return errores;
    }

    public async Task<(bool Success, string Message)> CommitVueloAsync(int idVuelo)
    {
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
                string sqlVuelo = "SP_UPDATE_GESTION_VUELO @id, @est, @ptr, @conf, @emb";
                await _context.Database.ExecuteSqlRawAsync(sqlVuelo,
                    new SqlParameter("@id", datos.IdVuelo),
                    new SqlParameter("@est", datos.IdEstado),
                    new SqlParameter("@ptr", (object)datos.Puerta ?? DBNull.Value),
                    new SqlParameter("@conf", datos.PasajerosConfirmados),
                    new SqlParameter("@emb", datos.PasajerosEmbarcados));

                if (datos.IdCapitan > 0 || datos.IdCopiloto > 0 || (datos.IdsTcp != null && datos.IdsTcp.Count > 0))
                {
                    
                    await _context.Database.ExecuteSqlRawAsync(
                        "DELETE FROM asignacion_tripulacion WHERE vuelo_id = @id",
                        new SqlParameter("@id", idVuelo));

                    string sqlTrip = "SP_ASIGNAR_TRIPULACION @vuelo_id, @tripulante_id";

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
                _memoryCache.Remove($"VUELO_{idVuelo}");
                return (true, "Vuelo actualizado correctamente.");
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return (false, ex.Message);
            }
        }
    }
    
    public async Task InsertarHardVuelosAsync()
    {
        string sql = "EXEC SP_GENERAR_VUELOS_HARD";
        await _context.Database.ExecuteSqlRawAsync(sql);
    } 
    
    public async Task BorrarHardVuelosAsync()
    {
        string sql = "EXEC SP_BORRAR_VUELOS_EN_VUELO";
        await _context.Database.ExecuteSqlRawAsync(sql);
    }

}