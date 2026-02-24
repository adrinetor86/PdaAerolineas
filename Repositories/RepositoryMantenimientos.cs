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
}