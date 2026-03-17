using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryAeropuertos
{
    private DataContext _context;



    public RepositoryAeropuertos(DataContext context)
    {
        _context = context;
    }
    
    
    public async Task<List<Aeropuerto>> GetAeropuertosAsync()
    {
        return await _context.Aeropuertos
            .OrderBy(a => a.Ciudad)
            .ThenBy(a => a.Nombre)
            .ToListAsync();
    }
    
    // public async Task<List<Aeropuerto>> GetAeropuertosAsync(){}
    
    
    public async Task<(List<Aeropuerto> Aeropuertos, int TotalRegistros)> GetAeropuertosPaginadosAsync(
        int numPag, int pageSize, string? busqueda)
    {
        string sql = "EXEC SP_AEROPUERTOS_PAGINADO @PageNumber, @PageSize, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", pageSize);
        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda.Trim());
        var pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int) { Direction = ParameterDirection.Output };

        var lista = await _context.Aeropuertos
            .FromSqlRaw(sql, pamNumPagina, pamNumFilas, pamBusqueda, pamTotal)
            .ToListAsync();

        int total = 0;
        if (pamTotal.Value != DBNull.Value && pamTotal.Value != null)
        {
            total = (int)pamTotal.Value;
        }

        return (lista, total);
    }

    public async Task<(bool Success, string Message)> CreateAeropuertoAsync(string nombre, string iata, string icao, string ciudad, int idPais, decimal latitud, decimal longitud)
    {
        try
        {
            var sql = "EXEC SP_CREATE_AEROPUERTO @Nombre,@IATA,@ICAO,@Ciudad,@PaisId,@Latitud,@Longitud";
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@Nombre", nombre),
                new SqlParameter("@IATA", iata),
                new SqlParameter("@ICAO", icao),
                new SqlParameter("@Ciudad", ciudad),
                new SqlParameter("@PaisId", idPais),
                new SqlParameter("@Latitud", latitud),
                new SqlParameter("@Longitud", longitud));
            return (true, "Aeropuerto creado correctamente.");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }
    public async Task<List<Pais>> GetPaisesAsync()
    {
        
        return await _context.Paises.OrderBy(p => p.Nombre).ToListAsync();
    }

    public async Task<(bool Success, string Message)> UpdateAeropuertoAsync(int id, string nombre, string iata, string icao, string ciudad, int idPais, decimal latitud, decimal longitud)
    {
        try
        {
            var sql = "EXEC SP_UPDATE_AEROPUERTO @Id,@Nombre,@IATA,@ICAO,@Ciudad,@PaisId,@Latitud,@Longitud";
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@Id", id),
                new SqlParameter("@Nombre", nombre),
                new SqlParameter("@IATA", iata),
                new SqlParameter("@ICAO", icao),
                new SqlParameter("@Ciudad", ciudad),
                new SqlParameter("@PaisId", idPais),
                new SqlParameter("@Latitud", latitud),
                new SqlParameter("@Longitud", longitud));
            return (true, "");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }

    public async Task<Aeropuerto> FindAeropuertoAsync(int id)
    {
        return await _context.Aeropuertos.FirstOrDefaultAsync(a => a.IdAeropuerto == id);
    }
}