using PdaAerolineas.Data;

namespace PdaAerolineas.Repositories;

public class RepositoryRutas
{
    private DataContext _context;

    public RepositoryRutas(DataContext context)
    {
        _context = context;
    }
    
}