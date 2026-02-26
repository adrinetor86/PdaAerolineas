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


    public async Task<TripulanteAsignado> GetTripulantesVueloAsync(int idVuelo)
    {
        
        var resultado = new TripulanteAsignado
        {
            Tcps = new List<Tripulante>()
        };
        SqlParameter pamVuelo = new SqlParameter("@vuelo_id", idVuelo);
        using (DbCommand com = _context.Database.GetDbConnection().CreateCommand())
        {
            
            string sql = "SP_GET_TRIPULANTES_VUELO";
            com.CommandType = CommandType.StoredProcedure;
            com.CommandText = sql;
            com.Parameters.Add(pamVuelo);
            await com.Connection.OpenAsync();
            DbDataReader reader = await com.ExecuteReaderAsync();
// 1️⃣ Comandante
            while (await reader.ReadAsync())
                resultado.Comandante = MapTripulante(reader);

            Console.WriteLine($"Comandante: {resultado.Comandante?.Nombre}");

// 2️⃣ Primer Oficial
            bool haySegundo = await reader.NextResultAsync();
            Console.WriteLine($"NextResult para Oficial: {haySegundo}");  // debe ser True

            while (await reader.ReadAsync())
                resultado.Oficial = MapTripulante(reader);

            Console.WriteLine($"Oficial: {resultado.Oficial?.Nombre}");

// 3️⃣ TCPs
            bool hayTercero = await reader.NextResultAsync();
            Console.WriteLine($"NextResult para TCPs: {hayTercero}");  // debe ser True

            while (await reader.ReadAsync())
                resultado.Tcps.Add(MapTripulante(reader));

            Console.WriteLine($"TCPs: {resultado.Tcps.Count}");

            await reader.CloseAsync();
            await com.Connection.CloseAsync();
             com.Parameters.Clear();

            return resultado;
        }
    }
    
    private Tripulante MapTripulante(DbDataReader reader) => new()
    {
        IdTripulante = int.Parse(reader["ID"].ToString()),
        Nombre       = reader["NOMBRE"].ToString(),
        Apellido       = reader["APELLIDO"].ToString(),
        Rol          = reader.IsDBNull(reader.GetOrdinal("ROL")) ? null : reader["ROL"].ToString(),
        Activo = reader["activo"] != DBNull.Value && Convert.ToBoolean(reader["activo"])    };
    
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

    public async Task<(bool Valido, List<string> Errores)> ValidarTripulacionAsync(int idVuelo)
    {
        var errores = new List<string>();
        SqlParameter pamVuelo = new SqlParameter("@vuelo_id",idVuelo);
        using (DbCommand com = _context.Database.GetDbConnection().CreateCommand())
        {
            string sql = "SP_VALIDAR_TRIPULACION_VUELO";
            com.CommandType = CommandType.StoredProcedure;
            com.CommandText = sql;
            
            com.Parameters.Add(pamVuelo);

            await com.Connection.OpenAsync();
            DbDataReader reader = await com.ExecuteReaderAsync();

            bool valido = true;
            while (await reader.ReadAsync())
            {
                valido = int.Parse(reader["valido"].ToString()) == 1;
                if (!valido)
                    errores.Add(reader["mensaje"].ToString());
            }

            await reader.CloseAsync();
            await com.Connection.CloseAsync();
            com.Parameters.Clear();
            return (valido, errores);
        }
        
    }
}