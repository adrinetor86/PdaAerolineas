using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryAviones
{
    private DataContext _context;


    public RepositoryAviones(DataContext context)
    {
        _context = context;
    }


    public async Task<List<VistaAvion>> GetVistaAvionesAsync(int idAerolinea)
    {
        var consulta = from datos in _context.VistaAviones
            where datos.IdAerolinea==idAerolinea
            select datos;

        return await consulta.ToListAsync();
        
        
    }
}