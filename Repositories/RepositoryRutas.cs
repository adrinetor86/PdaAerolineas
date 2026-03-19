using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories;

public class RepositoryRutas
{
    private DataContext _context;

    public RepositoryRutas(DataContext context)
    {
        _context = context;
    }

    // Rutas que opera la aerolínea (vista V_RUTAS_AEROLINEAS)
    public async Task<List<VistaRutaAerolinea>> GetRutasAerolineaAsync(int idAerolinea)
    {
        return await _context.VistaRutasAerolinea
            .Where(r => r.AerolineaId == idAerolinea)
            .OrderBy(r => r.CodigoRuta)
            .ToListAsync();
    }
    
        public async Task<List<VistaRuta>> GetRutasAsync()
    {
        return await _context.VistaRutas.ToListAsync();
    }
    
        
    public async Task<List<VistaRuta>> GetRutasMapaAerolineaAsync(int idAerolinea)
    {
        var rutasActivasIds = await _context.RutasAerolinea
            .Where(ra => ra.AerolineaId == idAerolinea && ra.Activa)
            .Select(ra => ra.RutaId)
            .ToListAsync();

        return await _context.VistaRutas
            .Where(r => rutasActivasIds.Contains(r.Id))
            .ToListAsync();
    }


    public async Task<List<VistaRuta>> GetRutasNoOperadasAsync(int idAerolinea)
    {
       
        var rutasOperadas = await _context.RutasAerolinea
            .Where(ra => ra.AerolineaId == idAerolinea)
            .Select(ra => ra.RutaId)
            .ToListAsync();
        
        var rutasDisponibles = await _context.VistaRutas
            .Where(r => !rutasOperadas.Contains(r.Id))
            .OrderBy(r => r.CodOrigen)
            .ThenBy(r => r.CodDestino)
            .ToListAsync();


        return rutasDisponibles.DistinctBy(r => r.Id).ToList();
    }

    
    private async Task<int> GetOrCreateRutaInversaAsync(int idRuta)
    {
        var rutaOriginal = await _context.Rutas.FindAsync(idRuta);
        if (rutaOriginal == null)
            throw new Exception("La ruta original no existe.");

        // Buscar ruta inversa
        var rutaInversa = await _context.Rutas
            .FirstOrDefaultAsync(r =>
                r.IdAeropuertoOrigen == rutaOriginal.IdAeropuertoDestino &&
                r.IdAeropuertoDestino == rutaOriginal.IdAeropuertoOrigen);

        if (rutaInversa != null)
            return rutaInversa.IdRuta;

        // Crear la ruta inversa
        rutaInversa = new Ruta
        {
            IdAeropuertoOrigen = rutaOriginal.IdAeropuertoDestino,
            IdAeropuertoDestino = rutaOriginal.IdAeropuertoOrigen,
            Distancia = rutaOriginal.Distancia
        };
        _context.Rutas.Add(rutaInversa);
        await _context.SaveChangesAsync();
        return rutaInversa.IdRuta;
    }

    public async Task<(bool Success, string Message)> AsignarRutaAsync(int idRuta, int idAerolinea,
        decimal? precioBase = null, int? frecuenciaSemanal = null)
    {
        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var sql = "EXEC SP_ASIGNAR_RUTA_AEROLINEA @ruta_id, @aerolinea_id, @precio_base, @frecuencia_semanal";

            // Asignar ruta principal
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@ruta_id", idRuta),
                new SqlParameter("@aerolinea_id", idAerolinea),
                new SqlParameter("@precio_base", (object?)precioBase ?? DBNull.Value),
                new SqlParameter("@frecuencia_semanal", (object?)frecuenciaSemanal ?? DBNull.Value));

            // Asignar ruta inversa (ida/vuelta)
            int idRutaInversa = await GetOrCreateRutaInversaAsync(idRuta);
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@ruta_id", idRutaInversa),
                new SqlParameter("@aerolinea_id", idAerolinea),
                new SqlParameter("@precio_base", (object?)precioBase ?? DBNull.Value),
                new SqlParameter("@frecuencia_semanal", (object?)frecuenciaSemanal ?? DBNull.Value));

            await transaction.CommitAsync();
            return (true, "Ruta asignada correctamente (ida y vuelta).");
        }
        catch (SqlException ex)
        {
            await transaction.RollbackAsync();
            return (false, ex.Message);
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return (false, ex.Message);
        }
    }

    // Desactivar ruta de aerolínea (SP) + ruta inversa
    public async Task<(bool Success, string Message)> DesactivarRutaAsync(int idRuta, int idAerolinea)
    {
        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var sql = "EXEC SP_DESACTIVAR_RUTA_AEROLINEA @ruta_id, @aerolinea_id";

            // Desactivar ruta principal
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@ruta_id", idRuta),
                new SqlParameter("@aerolinea_id", idAerolinea));

            // Desactivar ruta inversa si existe
            var rutaOriginal = await _context.Rutas.FindAsync(idRuta);
            if (rutaOriginal != null)
            {
                var rutaInversa = await _context.Rutas
                    .FirstOrDefaultAsync(r =>
                        r.IdAeropuertoOrigen == rutaOriginal.IdAeropuertoDestino &&
                        r.IdAeropuertoDestino == rutaOriginal.IdAeropuertoOrigen);

                if (rutaInversa != null)
                {
                    // Verificar que la aerolínea tiene la inversa asignada
                    var asignacion = await _context.RutasAerolinea
                        .FirstOrDefaultAsync(ra =>
                            ra.RutaId == rutaInversa.IdRuta &&
                            ra.AerolineaId == idAerolinea &&
                            ra.Activa);

                    if (asignacion != null)
                    {
                        try
                        {
                            await _context.Database.ExecuteSqlRawAsync(sql,
                                new SqlParameter("@ruta_id", rutaInversa.IdRuta),
                                new SqlParameter("@aerolinea_id", idAerolinea));
                        }
                        catch
                        {
                            // La inversa puede tener vuelos activos, continuamos sin error
                        }
                    }
                }
            }

            await transaction.CommitAsync();
            return (true, "Ruta desactivada correctamente (ida y vuelta).");
        }
        catch (SqlException ex)
        {
            await transaction.RollbackAsync();
            return (false, ex.Message);
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return (false, ex.Message);
        }
    }

    // Reactivar ruta (usa el mismo SP_ASIGNAR que ya maneja la reactivación)
    public async Task<(bool Success, string Message)> ReactivarRutaAsync(int idRuta, int idAerolinea)
    {
        return await AsignarRutaAsync(idRuta, idAerolinea);
    }

    // Actualizar detalles de la asignación (EF)
    public async Task<(bool Success, string Message)> UpdateRutaAerolineaAsync(int idRuta, int idAerolinea,
        decimal? precioBase, int? frecuenciaSemanal)
    {
        try
        {
            var ra = await _context.RutasAerolinea
                .FirstOrDefaultAsync(r => r.RutaId == idRuta && r.AerolineaId == idAerolinea);

            if (ra == null)
                return (false, "No se encontró la asignación de ruta.");

            ra.PrecioBase = precioBase;
            ra.FrecuenciaSemanal = frecuenciaSemanal;

            await _context.SaveChangesAsync();
            return (true, "Ruta actualizada correctamente.");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }

    public async Task<(List<VistaRutaAerolinea> Rutas, int TotalRegistros)> GetRutasAerolineaPaginadasAsync(int aerolineaId, int numPag, int numFilas, string? busqueda)
    {
        string sql = "EXEC SP_RUTAS_POR_AEROLINEA @AerolineaId, @PageNumber, @PageSize, @Busqueda, @TotalRegistros OUTPUT";

        var pamId = new SqlParameter("@AerolineaId", aerolineaId);
        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);
        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda.Trim());
        var pamTotal = new SqlParameter("@TotalRegistros", System.Data.SqlDbType.Int) { Direction = System.Data.ParameterDirection.Output };


        var lista = await _context.VistaRutasAerolinea
            .FromSqlRaw(sql, pamId, pamNumPagina, pamNumFilas, pamBusqueda, pamTotal)
            .ToListAsync();

        int total = (pamTotal.Value != DBNull.Value) ? (int)pamTotal.Value : 0;

        return (lista, total);
    }

    public async Task<(List<VistaRuta> Rutas, int TotalRegistros)> GetRutasPaginadasAsync(int numPag, int numFilas, string? busqueda)
    {
        string sql = "EXEC SP_RUTAS_PAGINADO @PageNumber, @PageSize, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);
        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda.Trim());
        var pamTotal = new SqlParameter("@TotalRegistros", System.Data.SqlDbType.Int) { Direction = System.Data.ParameterDirection.Output };

        var lista = await _context.VistaRutas
            .FromSqlRaw(sql, pamNumPagina, pamNumFilas, pamBusqueda, pamTotal)
            .ToListAsync();

        int total = 0;
        if (pamTotal.Value != DBNull.Value && pamTotal.Value != null)
        {
            total = (int)pamTotal.Value;
        }

        return (lista.DistinctBy(r => r.Id).ToList(), total);
    }

    public async Task<(bool Success, string Message)> CreateRutaAsync(int idOrigen, int idDestino, int distanciaKm)
    {
        if (idOrigen <= 0 || idDestino <= 0)
            return (false, "Debe seleccionar aeropuertos válidos.");
        if (idOrigen == idDestino)
            return (false, "El origen y el destino no pueden ser el mismo aeropuerto.");
        if (distanciaKm <= 0)
            return (false, "La distancia debe ser mayor que cero.");

        // Evitar duplicados exactos
        bool existeRuta = await _context.Rutas.AnyAsync(r => r.IdAeropuertoOrigen == idOrigen && r.IdAeropuertoDestino == idDestino);
        if (existeRuta)
            return (false, "Ya existe una ruta con ese origen y destino.");

        var ruta = new Ruta
        {
            IdAeropuertoOrigen = idOrigen,
            IdAeropuertoDestino = idDestino,
            Distancia = distanciaKm
        };

        await using var tx = await _context.Database.BeginTransactionAsync();
        try
        {
            _context.Rutas.Add(ruta);
            await _context.SaveChangesAsync();

            // Crear inversa si no existe
            bool existeInversa = await _context.Rutas.AnyAsync(r => r.IdAeropuertoOrigen == idDestino && r.IdAeropuertoDestino == idOrigen);
            if (!existeInversa)
            {
                var inversa = new Ruta
                {
                    IdAeropuertoOrigen = idDestino,
                    IdAeropuertoDestino = idOrigen,
                    Distancia = distanciaKm
                };
                _context.Rutas.Add(inversa);
                await _context.SaveChangesAsync();
            }

            await tx.CommitAsync();
            return (true, "Ruta creada correctamente (ida y vuelta)." );
        }
        catch (DbUpdateException dbEx)
        {
            await tx.RollbackAsync();
            var msg = dbEx.InnerException?.Message ?? dbEx.Message;
            return (false, msg);
        }
        catch (Exception ex)
        {
            await tx.RollbackAsync();
            return (false, ex.Message);
        }
    }

}
