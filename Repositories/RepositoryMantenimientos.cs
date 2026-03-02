using System.Data;
using System.Runtime.InteropServices.JavaScript;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryMantenimientos
{
    private DataContext _context;


    public RepositoryMantenimientos(DataContext context)
    {
        _context = context;
    }


    public async Task<List<VistaMantenimientos>> GetMantenimientosAsync()
    {
        var consulta = from datos in _context.VistaMantenimientos
            select datos;

        return await consulta.ToListAsync();
    }

    public async Task<(List<VistaMantenimientos> datos, int total)> GetMantenimientosPaginadosAsync(
        int numPag = 1,
        int numFilas = 10,
        int idAerolinea = 1,
        string? estado = null,
        DateTime? fechaProgramada = null,
        string? busqueda = null)
    {
        try
        {
            // 1. String SQL idéntico a Vuelos (usando EXEC y OUTPUT)
            string sql = "EXEC SP_MANTENIMIENTOS_PAGINADO @PageNumber, @PageSize, @AerolineaId, @Estado, @FechaProgramada, @Busqueda, @TotalRegistros OUTPUT";

            var pamPageNum = new SqlParameter("@PageNumber", numPag);
            var pamNumFilas = new SqlParameter("@PageSize", numFilas);
            var pamAerolinea = new SqlParameter("@AerolineaId", idAerolinea);
        
            // 2. Control estricto de nulos igual que en Vuelos
            var pamEstado = new SqlParameter("@Estado", string.IsNullOrWhiteSpace(estado) ? DBNull.Value : estado.Trim());
            var pamFecha = new SqlParameter("@FechaProgramada", fechaProgramada.HasValue ? fechaProgramada.Value.Date : DBNull.Value);
            var pamBusqueda = new SqlParameter("@Busqueda", string.IsNullOrWhiteSpace(busqueda) ? DBNull.Value : busqueda.Trim());

            var pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int);
            pamTotal.Direction = System.Data.ParameterDirection.Output;

            // 3. Pasamos todos los parámetros a FromSqlRaw (¡incluido pamTotal!)
            var lista = await _context.VistaMantenimientos
                .FromSqlRaw(sql, pamPageNum, pamNumFilas, pamAerolinea, pamEstado, pamFecha, pamBusqueda, pamTotal)
                .ToListAsync();

            int total = 0;
            if (pamTotal.Value != DBNull.Value && pamTotal.Value != null)
            {
                total = (int)pamTotal.Value;
            }

            return (lista, total);
        }
        catch (Exception e)
        {
            Console.WriteLine("Error SP_MANTENIMIENTOS_PAGINADO: " + e.Message);
            return (new List<VistaMantenimientos>(), 0);
        }
    }

    public async Task ProgramarMantenimientoAsync(int idAvion, int idTipoMantenimiento, DateTime fechaProgramada)
    {
        string sql = "SP_PROGRAMAR_MANTENIMIENTO @avion_id,@mantenimiento_tipo_id,@fecha_programada";

        SqlParameter pamAvion = new SqlParameter("@avion_id", idAvion);
        SqlParameter pamTipoMant = new SqlParameter("@mantenimiento_tipo_id", idTipoMantenimiento);
        SqlParameter pamFecha = new SqlParameter("@fecha_programada", fechaProgramada);


        await _context.Database.ExecuteSqlRawAsync(sql, pamAvion, pamTipoMant, pamFecha);
    }

    public async Task<List<MantenimientoTipo>> GetTiposMantenimientoAsync()
    {
        var consulta = from datos in _context.MantenimientosTipos
            select datos;

        return await consulta.ToListAsync();
    }


    public async Task<VistaMantenimientos?> GetMantenimientoByIdAsync(int idMantenimiento)
    {
        var consulta = from datos in _context.VistaMantenimientos
            where datos.Id == idMantenimiento
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }

    public async Task<(bool ok, string mensaje)> IniciarMantenimientoAsync(int idMantenimiento)
    {
        string sql = "SP_MANTENIMIENTO_INICIAR @IdMantenimiento";

        try
        {
            SqlParameter pamMant = new SqlParameter("@IdMantenimiento", idMantenimiento);


            await _context.Database.ExecuteSqlRawAsync(sql, pamMant);

            return (true, $"Mantenimiento {idMantenimiento} iniciado");
        }
        catch (SqlException e)
        {
            return (false, e.Message);
        }
    }

    public async Task UpdateDescripcionAsync(int idMantenimiento, string? descripcion)
    {
        string sql = "SP_MANTENIMIENTO_COMPLETAR @IdMantenimiento,@Descripcion";

        SqlParameter pamMant = new SqlParameter("@IdMantenimiento", idMantenimiento);
        SqlParameter pamDescripcion = new SqlParameter("@Descripcion", descripcion);

        await _context.Database.ExecuteSqlRawAsync(sql, pamMant, pamDescripcion);
    }
}