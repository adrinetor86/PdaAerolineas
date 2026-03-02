using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryRetrasos
{
    private DataContext _context;

    public RepositoryRetrasos(DataContext context)
    {
        _context = context;
    }
    
    
    
    
    public async Task<(bool Success, string Message)> RegistrarRetrasoAsync(int idVuelo, int minutos, int idCodRetraso)
    {
        if (idVuelo <= 0) return (false, "Vuelo inválido");
        if (minutos <= 0) return (false, "Los minutos deben ser mayor que 0");

        string sql = "SP_REGISTRAR_RETRASO @vuelo_id,@codigo_retraso_id,@minutos";


        SqlParameter pamVuelo = new SqlParameter("@vuelo_id", idVuelo);
        SqlParameter pamCodRetraso = new SqlParameter("@codigo_retraso_id", idCodRetraso);
        SqlParameter pamMinutos = new SqlParameter("@minutos", minutos);

        try
        {
            await _context.Database.ExecuteSqlRawAsync(sql, pamVuelo, pamCodRetraso, pamMinutos);

            return (true, $"Retraso registrado: +{minutos} min");
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
    
    public async Task<VistaRetraso> GetDetalleRetrasoAsync(int idVuelo)
    {

        var consulta = from datos in _context.VistaRetrasos
                .Where(datos => datos.IdVuelo == idVuelo)
            select datos;
        
         return await consulta.FirstOrDefaultAsync();
    }
    
    public async Task<List<CodigoRetrasoIata>> GetCodigosRetrasoAsync()
    {
        var consulta = from datos in _context.CodigosRetrasos
            select datos;

        return await consulta.ToListAsync();
    }
}