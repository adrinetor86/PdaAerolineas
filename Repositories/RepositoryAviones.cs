using Microsoft.Data.SqlClient;
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
        return await _context.VistaAviones
            .Where(a => a.IdAerolinea == idAerolinea)
            .ToListAsync();
    }

    public async Task<List<EstadoAvion>> GetEstadosAviones()
    {
        return await _context.EstadosAviones.ToListAsync();
    }

    public async Task<VistaHistorialVuelo> GetHistorialVueloByVueloIdAsync(int idVuelo)
    {
        return await _context.VistaHistorialVuelos
            .FirstOrDefaultAsync(v => v.VueloId == idVuelo);
    }
    

    // Historial de vuelos por avión
    public async Task<List<VistaHistorialVuelo>> GetHistorialByAvionIdAsync(int idAvion)
    {
        return await _context.VistaHistorialVuelos
            .Where(v => v.AvionId == idAvion && v.EstadoId !=5)
            .OrderByDescending(v => v.FechaSalida)
            .ToListAsync();
    }

    public async Task<List<ModeloAvion>> GetModelosAvionAsync()
    {
        return await _context.ModelosAvion.ToListAsync();
    }

    public async Task<List<Aeropuerto>> GetAeropuertosAsync()
    {
        return await _context.Aeropuertos.OrderBy(a => a.Cod_Iata).ToListAsync();
    }

    public async Task<Avion?> GetAvionByIdAsync(int idAvion)
    {
        return await _context.Aviones.FirstOrDefaultAsync(a => a.IdAvion == idAvion);
    }

    // Crear avión usando SP
    public async Task<(bool Success, string Message)> CreateAvionAsync(
        string matricula, int modeloId, int aerolineaId, int aeropuertoActualId, int horasVuelo, int ciclos)
    {
        try
        {
            var sql = "EXEC SP_CREATE_AVION @matricula, @modelo, @aerolinea, @estado, @aeropuertoactual, @horasvuelo, @ciclos";
            await _context.Database.ExecuteSqlRawAsync(sql,
                new SqlParameter("@matricula", matricula),
                new SqlParameter("@modelo", modeloId),
                new SqlParameter("@aerolinea", aerolineaId),
                new SqlParameter("@estado", 1), // Operativo por defecto
                new SqlParameter("@aeropuertoactual", aeropuertoActualId),
                new SqlParameter("@horasvuelo", horasVuelo),
                new SqlParameter("@ciclos", ciclos));

            return (true, "Aeronave registrada correctamente.");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
    }

    // Actualizar avión (EF)
    public async Task<(bool Success, string Message)> UpdateAvionAsync(
        int idAvion, int estadoId, int aeropuertoActualId)
    {
        try
        {
            var avion = await _context.Aviones.FindAsync(idAvion);
            if (avion == null)
                return (false, "Aeronave no encontrada.");

            avion.IdEstado = estadoId;
            avion.IdAeropuertoActual = aeropuertoActualId;

            await _context.SaveChangesAsync();
            return (true, "Aeronave actualizada correctamente.");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }

    // Eliminar avión (con validación de vuelos activos)
    public async Task<(bool Success, string Message)> DeleteAvionAsync(int idAvion)
    {
        try
        {
            // Verificar que no tiene vuelos activos
            var tieneVuelos = await _context.Vuelos
                .AnyAsync(v => v.IdAvion == idAvion && (v.IdEstado == 1 || v.IdEstado == 2 || v.IdEstado == 3));

            if (tieneVuelos)
                return (false, "No se puede eliminar la aeronave porque tiene vuelos activos (programados, embarcando o en vuelo).");

            var avion = await _context.Aviones.FindAsync(idAvion);
            if (avion == null)
                return (false, "Aeronave no encontrada.");

            _context.Aviones.Remove(avion);
            await _context.SaveChangesAsync();
            return (true, "Aeronave eliminada correctamente.");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }

    public async Task<(bool Success, string Message)> CreateModeloAvionAsync(string fabricante, string nombre, int capacidad, int alcance)
    {
        try
        {
            var modelo = new ModeloAvion
            {
                Fabricante = fabricante,
                Nombre = nombre,
                Capacidad = capacidad,
                Alcance = alcance
            };

            _context.ModelosAvion.Add(modelo);
            await _context.SaveChangesAsync();
            return (true, "Modelo registrado correctamente.");
        }
        catch (Exception ex)
        {
            return (false, ex.Message);
        }
    }
}