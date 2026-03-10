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

    public async Task<List<VistaTripulante>> GetTripulantesAsync(int idAerolinea)
    {
        var consulta = from datos in _context.VistaTripulantes
            where datos.IdAerolinea == idAerolinea
            select datos;

        return await consulta.ToListAsync();
    }   
    
     public async Task<List<string>> GetRolesAsync()
    {
        var consulta = (from datos in _context.VistaTripulantes
            select datos.Rol).Distinct();

        return await consulta.ToListAsync();
    }   
    
    public async Task<Tripulante?> FindTripulanteAsync(int idTripulante)
    {
        var consulta = from datos in _context.Tripulantes
            where datos.IdTripulante == idTripulante
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }
    
    
    
    public async Task UpdateTripulantesAsync(int idTripulante,int idAerolinea,string nombre, string apellido,string rol,bool activo=true )
    {
        
        string sql = "SP_UPDATE_TRIPULACION @idTripulacion,@idAerolinea,@nombre,@apellido,@rol,@activo";


        SqlParameter pamTripu = new SqlParameter("@idTripulacion", idTripulante);
        SqlParameter pamAerolinea = new SqlParameter("@idAerolinea", idAerolinea);
        SqlParameter pamNombre= new SqlParameter("@nombre", nombre);
        SqlParameter pamApellido = new SqlParameter("@apellido", apellido);
        SqlParameter pamRol = new SqlParameter("@rol", rol);
        SqlParameter pamActivo = new SqlParameter("@activo", activo);

        await _context.Database.ExecuteSqlRawAsync(sql, pamTripu, pamAerolinea, pamNombre, pamApellido, pamRol,
            pamActivo);
        
    } 
    
    public async Task CreateTripulantesAsync(int idAerolinea,string nombre, string apellido,string rol,bool activo=true )
    {
        
        string sql = "SP_CREATE_TRIPULACION @idAerolinea,@nombre,@apellido,@rol,@activo";

        
        SqlParameter pamAerolinea = new SqlParameter("@idAerolinea", idAerolinea);
        SqlParameter pamNombre= new SqlParameter("@nombre", nombre);
        SqlParameter pamApellido = new SqlParameter("@apellido", apellido);
        SqlParameter pamRol = new SqlParameter("@rol", rol);
        SqlParameter pamActivo = new SqlParameter("@activo", activo);

        await _context.Database.ExecuteSqlRawAsync(sql, pamAerolinea, pamNombre, pamApellido, pamRol, pamActivo);
        
    }
    
    public async Task<(List<Tripulante> Tripulantes, int TotalRegistros)> GetTripulantesPaginadosAsync(
        int numPag,
        int numFilas,
        string? rol,
        int? idAerolinea,
        bool? activo,
        string? busqueda)
    {
        string sql = "EXEC SP_TRIPULANTES_PAGINADO @PageNumber, @PageSize, @Rol, @IdAerolinea, @Activo, @Busqueda, @TotalRegistros OUTPUT";

        var pamNumPagina = new SqlParameter("@PageNumber", numPag);
        var pamNumFilas = new SqlParameter("@PageSize", numFilas);
        var pamRol = new SqlParameter("@Rol", string.IsNullOrWhiteSpace(rol) ? DBNull.Value : rol.Trim());
        var pamAerolinea = new SqlParameter("@IdAerolinea", idAerolinea.HasValue ? idAerolinea.Value : DBNull.Value);
        var pamActivo = new SqlParameter("@Activo", activo.HasValue ? activo.Value : DBNull.Value);
        var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda.Trim());
    
        var pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };

        // Suponiendo que tu DbSet en el contexto se llama "Tripulantes"
        var lista = await _context.Tripulantes
            .FromSqlRaw(sql, pamNumPagina, pamNumFilas, pamRol, pamAerolinea, pamActivo, pamBusqueda, pamTotal)
            .ToListAsync();

        int total = pamTotal.Value != DBNull.Value && pamTotal.Value != null ? (int)pamTotal.Value : 0;

        return (lista, total);
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
    // Comandante
            while (await reader.ReadAsync())
                resultado.Comandante = MapTripulante(reader);

            Console.WriteLine($"Comandante: {resultado.Comandante?.Nombre}");

    //Primer Oficial
            bool haySegundo = await reader.NextResultAsync();
            Console.WriteLine($"NextResult para Oficial: {haySegundo}");  

            while (await reader.ReadAsync())
                resultado.Oficial = MapTripulante(reader);

            Console.WriteLine($"Oficial: {resultado.Oficial?.Nombre}");

        // TCPs
            bool hayTercero = await reader.NextResultAsync();
            Console.WriteLine($"NextResult para TCPs: {hayTercero}"); 

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
    
    public async Task<List<Tripulante>> GetTripulantesDisponiblesAsync(int idVuelo,int idAerolinea ,string rol)
{
    var resultado = new List<Tripulante>();

    using DbCommand cmd = _context.Database.GetDbConnection().CreateCommand();
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.CommandText = "SP_GET_TRIPULANTES_DISPONIBLES";
    cmd.Parameters.Add(new SqlParameter("@vuelo_id", idVuelo));
    cmd.Parameters.Add(new SqlParameter("@aerolinea_id", idAerolinea));
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