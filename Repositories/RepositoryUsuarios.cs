using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Helpers;
using PdaAerolineas.Models;
using PdaAerolineas.Models.Auth;
using PdaAerolineas.Models.Views;

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
        SqlParameter PamPass = new SqlParameter("@Pass", pass);
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