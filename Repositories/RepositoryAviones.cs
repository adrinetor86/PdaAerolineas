using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Views;

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

    public async Task<List<EstadoAvion>> GetEstadosAviones()
    {
        var consuta= from datos in _context.EstadosAviones
            select datos;

        return await consuta.ToListAsync();
    }

    public async Task<VistaHistorialVuelo> GetHistorialVueloByVueloIdAsync(int idVuelo)
    {
        var consulta = from datos in _context.VistaHistorialVuelos
            where datos.VueloId == idVuelo
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }
}