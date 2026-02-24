using System.Data;
using System.Data.Common;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryTripulantes
{
    private DataContext _context;


    public RepositoryTripulantes(DataContext context)
    {
        _context = context;
    }

    public async Task<List<VistaTripulante>> GetTripulantesAsync()
    {
        var consulta = from datos in _context.VistaTripulantes
            select datos;

        return await consulta.ToListAsync();
    }


    public async Task<List<Tripulante>> GetTripulantesVueloAsync(int idVuelo)
    {
        string sql = "SP_GET_TRIPULANTES_VUELO @vuelo_id";

        SqlParameter pamVuelo = new SqlParameter("@vuelo_id", idVuelo);

        var consulta= _context.Tripulantes.FromSqlRaw(sql, pamVuelo);

        return await consulta.ToListAsync();
    }
    
    public async Task<List<Tripulante>> GetTripulantesDisponiblesAsync(int idVuelo, string rol)
{
    var resultado = new List<Tripulante>();

    using DbCommand cmd = _context.Database.GetDbConnection().CreateCommand();
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.CommandText = "SP_GET_TRIPULANTES_DISPONIBLES";
    cmd.Parameters.Add(new SqlParameter("@vuelo_id", idVuelo));
    cmd.Parameters.Add(new SqlParameter("@rol", (object?)rol ?? DBNull.Value));

    await cmd.Connection.OpenAsync();
    DbDataReader reader = await cmd.ExecuteReaderAsync();

    while (await reader.ReadAsync())
    {
        resultado.Add(new Tripulante
        {
            IdTripulante = int.Parse(reader["tripulante_id"].ToString()),
            Nombre       = reader["nombre_completo"].ToString(),
            Rol          = reader["rol"].ToString(),
        });
    }

    await reader.CloseAsync();
    await cmd.Connection.CloseAsync();
    cmd.Parameters.Clear();

    return resultado;
}
}