using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories;

public class RepositoryAerolineas
{
    private DataContext _context;
    private HelperPathProvider _helperPath;


    public RepositoryAerolineas(DataContext context,HelperPathProvider helperPath)
    {
        _context = context;
        _helperPath = helperPath;
    }


    public async Task<List<Aerolinea>> GetAerolineasAsync()
    {
        var consulta= from datos in _context.Aerolineas
            select datos;
        
        return await consulta.ToListAsync();
    }  
    
    public async Task<(List<Aerolinea> datos, int total)> GetAerolineasPaginadasAsync(
        int pagina, int filas, string? busqueda = null)
    {
        // Parámetro OUTPUT para el total de registros
        SqlParameter pamTotal = new SqlParameter("@TotalRegistros", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
 
        SqlParameter pamPagina   = new SqlParameter("@PageNumber", pagina);
        SqlParameter pamFilas    = new SqlParameter("@PageSize",   filas);
        SqlParameter pamBusqueda = new SqlParameter("@Busqueda",
            string.IsNullOrEmpty(busqueda) ? DBNull.Value : busqueda);
 
        List<Aerolinea> datos = await _context.Aerolineas
            .FromSqlRaw("EXEC SP_AEROLINEAS_PAGINADO @PageNumber, @PageSize, @Busqueda, @TotalRegistros OUTPUT",
                pamPagina, pamFilas, pamBusqueda, pamTotal)
            .ToListAsync();
 
        int total = pamTotal.Value != DBNull.Value ? (int)pamTotal.Value : 0;
 
        return (datos, total);
    }
    
    public async Task<Aerolinea> FindAerolineaAsync(int idAerolinea)
    {
        var consulta= from datos in _context.Aerolineas
            where datos.IdAerolinea==idAerolinea
            select datos;
        
        return await consulta.FirstOrDefaultAsync();
    }  
    
    
    public async Task<VistaDashboard> GetDatosDashboardAsync(int idAerolinea)
    {
        var consulta= from datos in _context.VistaDashboard
            where datos.IdAerolinea==idAerolinea
            select datos;


        return await consulta.FirstOrDefaultAsync();
    }


    public async Task CreateAerolineaAsync(string nombre,IFormFile? logo,string codIata)
    {
        string sql = "SP_CREATE_AEROLINEA @nombre,@logo,@codIata";
        
        try {
            string fileName = logo != null ? logo.FileName : "";
        
            if (logo != null)
            {
                string path = _helperPath.MapPath(fileName, Folders.Logos);
                using (Stream stream = new FileStream(path, FileMode.Create))
                {
                    await logo.CopyToAsync(stream);
                }
            }
            
            SqlParameter pamNombre = new SqlParameter("@nombre", nombre);
            SqlParameter pamLogo = new SqlParameter("@logo", fileName);
            SqlParameter pamCodIata = new SqlParameter("@codIata", codIata);
            
            await _context.Database.ExecuteSqlRawAsync(sql, pamNombre, pamLogo, pamCodIata);
        }
        catch (SqlException ex) {
            Console.WriteLine(ex);
            throw; 
        }
    } 
    
    public async Task UpdateAerolineaAsync(int idAerolinea,string nombre,IFormFile? logo,string codIata)
    {
        string sql = "SP_UPDATE_AEROLINEA @idAerolinea, @nombre,@logo,@codIata";
        
        try {
            string fileName = logo != null ? logo.FileName : "";
        
            if (logo != null)
            {
                string path = _helperPath.MapPath(fileName, Folders.Logos);
                using (Stream stream = new FileStream(path, FileMode.Create))
                {
                    await logo.CopyToAsync(stream);
                }
            }
            
            SqlParameter pamAerolinea = new SqlParameter("@idAerolinea", idAerolinea);
            SqlParameter pamNombre = new SqlParameter("@nombre", nombre);
            SqlParameter pamLogo = new SqlParameter("@logo", fileName);
            SqlParameter pamCodIata = new SqlParameter("@codIata", codIata);
            
            await _context.Database.ExecuteSqlRawAsync(sql, pamAerolinea,pamNombre, pamLogo, pamCodIata);
        }
        catch (SqlException ex) {
            Console.WriteLine(ex);
            throw; 
        }
  
    }
}