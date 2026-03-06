using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Models;

namespace PdaAerolineas.Repositories;

public class RepositoryAeropuertos
{
    private DataContext _context;



    public RepositoryAeropuertos(DataContext context)
    {
        _context = context;
    }
    
    
    // public async Task<List<Aeropuerto>> GetAeropuertosAsync(){}
    
    
    public async Task<(List<Aeropuerto> Aeropuertos, int TotalRegistros)> GetAeropuertosPaginadosAsync(
        int numPag, int pageSize, string busqueda)
    {
        var consulta = _context.Aeropuertos.AsQueryable();

        if (!string.IsNullOrEmpty(busqueda))
        {
            consulta = consulta.Where(x => x.Ciudad.Contains(busqueda) 
                                           || x.Nombre.Contains(busqueda) 
                                           || x.Ciudad.Contains(busqueda));
        }

        int total = await consulta.CountAsync();
        var lista = await consulta
            .OrderBy(x => x.Nombre)
            .Skip((numPag - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return (lista, total);
    }
}