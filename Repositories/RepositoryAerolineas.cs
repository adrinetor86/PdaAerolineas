using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

namespace PdaAerolineas.Repositories;

public class RepositoryAerolineas
{
    private DataContext _context;


    public RepositoryAerolineas(DataContext context)
    {
        _context = context;
    }


    public async Task<List<Aerolinea>> GetAerolineasAsync()
    {
        var consulta= from datos in _context.Aerolineas
            select datos;


        return await consulta.ToListAsync();
    }  
    
    public async Task<VistaDashboard> GetDatosDashboardAsync(int idAerolinea)
    {
        var consulta= from datos in _context.VistaDashboard
            where datos.IdAerolinea==idAerolinea
            select datos;


        return await consulta.FirstOrDefaultAsync();
    }
}