using PdaAerolineas.Data;

namespace PdaAerolineas.Repositories;

public class RepositoryUsuarios
{
    private DataContext _context;


    public RepositoryUsuarios(DataContext context)
    {
        _context = context;
    }


    
    //TODO VER TEMA AUTORIZACIONES Y HASHEOS PASS
    public async Task Login()
    {
        
    }

}