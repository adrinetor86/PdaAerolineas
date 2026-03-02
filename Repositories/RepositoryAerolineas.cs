using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

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
}