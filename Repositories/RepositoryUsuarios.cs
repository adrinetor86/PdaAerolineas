using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Views;
using System.Data;

namespace PdaAerolineas.Repositories;

public class RepositoryUsuarios
{
    private DataContext _context;


    public RepositoryUsuarios(DataContext context)
    {
        _context = context;
    }

    
    public async Task<VistaLoggedUser> LogInUserAsync(string email, string password)
    {
        
        var consulta= from datos in _context.VistaUsuarios
            where datos.Email == email
            select datos;
        
        VistaUsuarios user = await consulta.FirstOrDefaultAsync();
        if (user != null)
        {
            //NECESITAMOS EL SALT DEL USUARIO
            string salt= user.Salt;
            //CIFRAMOS EL PASSWORD CON SU SALT A NIVEL DE BYTE[]
            byte[] temp=HelperTools.EncryptPassword(password, salt);
            //RECUPERAMOS LOS BYTES[] DEL PASSWORD DE LA BBDD

            byte[] passBytes = user.Pass;
            
            bool response= HelperTools.CompareArrays(temp, passBytes);
            if (response)
            {
                // var usuarioValido = from datos in _context.Usuarios
                //     where datos.Email == email
                //     select datos;
                
                return  await _context.VistaLogedUser.FirstOrDefaultAsync(z =>z.Email==email);
                // return  await _context.Usuarios.FirstOrDefaultAsync(x =>x.Email==email);
             
            }
        }
        return null;
        
    }
    
    
    
    public async Task<(List<VistaAdministracionUsuarios> datos, int total)> GetUsuariosPaginadosAsync(
        int pagina, int filas, string? busqueda = null, int? aerolineaId = null, bool? activo = null)
    {
        // Paso 1: resolvemos el nombre ANTES de construir el query
        string? nombreAerolinea = null;
        if (aerolineaId.HasValue)
        {
            nombreAerolinea = await _context.Aerolineas
                .Where(a => a.IdAerolinea == aerolineaId.Value)
                .Select(a => a.Nombre)
                .FirstOrDefaultAsync();
        }

        // Paso 2: query sobre la vista (sin FromSqlRaw, sin SP)
        var query = _context.VistaAdministracionUsuarios.AsQueryable();

        if (nombreAerolinea != null)
            query = query.Where(u => u.Aerolinea == nombreAerolinea);

        if (activo.HasValue)
            query = query.Where(u => u.Activo == activo.Value);

        if (!string.IsNullOrEmpty(busqueda))
            query = query.Where(u =>
                u.Nombre.Contains(busqueda)    ||
                u.Apellidos.Contains(busqueda) ||
                u.Email.Contains(busqueda)     ||
                u.Rol.Contains(busqueda)       ||
                u.Aerolinea.Contains(busqueda));

        int total = await query.CountAsync();

        List<VistaAdministracionUsuarios> datos = await query
            .OrderBy(u => u.Apellidos)
            .ThenBy(u => u.Nombre)
            .Skip((pagina - 1) * filas)
            .Take(filas)
            .ToListAsync();

        return (datos, total);
    }
    
    public async Task RegisterUserAsync(string nombre,string apellidos,string email,int idAerolinea,string password,int idRol)
    {
        string salt = HelperTools.GenerateSalt();
        byte[] pass=HelperTools.EncryptPassword(password, salt);
        
        string sql = "SP_Registrar_Usuario @Nombre,@Apellidos,@Email,@Password,@IdAerolinea,@Salt,@Pass,@IdRol";



        SqlParameter PamNombre = new SqlParameter("@Nombre", nombre);
        SqlParameter PamApellidos = new SqlParameter("@Apellidos", apellidos);
        SqlParameter PamEmail = new SqlParameter("@Email", email);
        SqlParameter PamPassword = new SqlParameter("@Password", password);
        SqlParameter PamAerolinea = new SqlParameter("@IdAerolinea", idAerolinea);
        SqlParameter PamSalt = new SqlParameter("@Salt", salt);
        PamSalt.SqlDbType = System.Data.SqlDbType.NVarChar;
        PamSalt.Size = 100;

        //SqlParameter PamPass = new SqlParameter("@Pass", pass);
        //PamPass.SqlDbType = System.Data.SqlDbType.VarBinary;
        //PamPass.Size = -1;
        SqlParameter PamPass = new SqlParameter("@Pass", SqlDbType.VarBinary);
        PamPass.Value = pass; // Tus bytes ya cifrados
        PamPass.Size = -1;    // Esto indica (MAX)
        SqlParameter PamRol = new SqlParameter("@IdRol", idRol);

    //TODO RECOGER ERRORES
       await _context.Database.ExecuteSqlRawAsync(sql, PamNombre, PamApellidos, PamEmail, PamPassword, PamAerolinea, PamSalt, PamPass,PamRol);

    }


    public async Task<VistaLoggedUser> GetLoggedUserData(int idUser)
    {
        var consulta= from datos in _context.VistaLogedUser
            where datos.IdUsuario==idUser
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }


    public async Task<List<RolUsuario>> GetRolesUsuariosAsync()
    {
        var consulta= from datos in _context.RolesUsuario
            select datos;

        return await consulta.ToListAsync();
    }
       public async Task<List<VistaAdministracionUsuarios>> GetUsuariosAsync()
    {
        var consulta= from datos in _context.VistaAdministracionUsuarios
            select datos;

        return await consulta.ToListAsync();
    }
      public async Task<VistaAdministracionUsuarios> FindUsuarioAsync(int idUsuario)
    {
        var consulta= from datos in _context.VistaAdministracionUsuarios
            where datos.Id ==idUsuario
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }

    public async Task UpdateUsuarioAsync(int idUsuario, string nombre, string apellidos, string rol,string aerolinea, bool activo)
    {
        string sql = "SP_UPDATE_USUARIOS @idUsuario,@nombre,@apellidos,@rol,@aerolinea,@activo";

        SqlParameter pamUsuario = new SqlParameter("@idUsuario", idUsuario);
        SqlParameter pamNombre = new SqlParameter("@nombre", nombre);
        SqlParameter pamApellidos = new SqlParameter("@apellidos", apellidos);
        SqlParameter pamRol = new SqlParameter("@rol", rol);
        SqlParameter pamAerolinea = new SqlParameter("@aerolinea", aerolinea);
        SqlParameter pamActivo = new SqlParameter("@activo", activo);

        await _context.Database.ExecuteSqlRawAsync(sql, pamUsuario, pamNombre, pamApellidos, pamRol,pamAerolinea, pamActivo);

    }
    
    
    


}