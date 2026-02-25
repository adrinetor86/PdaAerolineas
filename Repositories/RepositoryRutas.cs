using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryRutas
{
    private DataContext _context;

    public RepositoryRutas(DataContext context)
    {
        _context = context;
    }

    

    public async Task<List<VistaRuta>> GetRutasAerolinea(int idBase)
    {
        
        var consulta= from datos in _context.VistaRutas
            .Where(r => r.IdDestino != idBase)
            select datos;

        return await consulta.ToListAsync();
    }
}