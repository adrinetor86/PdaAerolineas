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
    
    public async Task<List<TripulantesDisponibles>> GetTripulantesDisponiblesAsync(int idVuelo)
    {

        using (DbCommand com = _context.Database.GetDbConnection().CreateCommand())
        {
            string sql = "SP_GET_TRIPULANTES_DISPONIBLES";

            com.CommandType = CommandType.StoredProcedure;
            com.CommandText = sql;
            SqlParameter pamVuelo = new SqlParameter("@vuelo_id", idVuelo);

            com.Parameters.Add(pamVuelo);
            await com.Connection.OpenAsync();
            DbDataReader reader = await com.ExecuteReaderAsync();
            
            List<TripulantesDisponibles> tripulantes = new List<TripulantesDisponibles>();
            
            
            while (await reader.ReadAsync())
            {
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    Console.WriteLine($"[{reader.GetName(i)}] = '{reader[i]}' | IsNull: {reader[i] == DBNull.Value}");
                }
                Console.WriteLine("---");
                
                TripulantesDisponibles tripulante = new TripulantesDisponibles();
                tripulante.TripulanteId = int.Parse(reader["TRIPULANTE_ID"].ToString());
                tripulante.Nombre = reader["NOMBRE_COMPLETO"].ToString();
                tripulante.Licencia = reader["LICENCIA"].ToString();
                tripulante.Rol =reader["ROL"].ToString();
                // tripulante.YaAsignado = int.Parse(reader["YA_ASIGNADO"].ToString());
                
                tripulantes.Add(tripulante);
            }

            await com.Connection.CloseAsync();
            await reader.CloseAsync();
            com.Parameters.Clear();
            return tripulantes;
        }
        
    }
}