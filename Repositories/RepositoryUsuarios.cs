using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Helpers;
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

    
    public async Task<Usuario> LogInUserAsync(string email, string password)
    {
        //BUSCAMOS SI EXISTE EL REGISTRO POR SU CAMPO UNICO
        
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
                var usuarioValido = from datos in _context.Usuarios
                    where datos.Email == email
                    select datos;
                
                return await usuarioValido.FirstOrDefaultAsync();
            }
        }
        return null;
        
    }
    
    public async Task RegisterUserAsync(string nombre,string apellidos,string email,int idAerolinea,string password)
    {
        string salt = HelperTools.GenerateSalt();
        byte[] pass=HelperTools.EncryptPassword(password, salt);
        
        string sql = "SP_Registrar_Usuario @Nombre,@Apellidos,@Email,@Password,@IdAerolinea,@Salt,@Pass";

        SqlParameter PamNombre = new SqlParameter("@Nombre", nombre);
        SqlParameter PamApellidos = new SqlParameter("@Apellidos", apellidos);
        SqlParameter PamEmail = new SqlParameter("@Email", email);
        SqlParameter PamPassword = new SqlParameter("@Password", password);
        SqlParameter PamAerolinea = new SqlParameter("@IdAerolinea", idAerolinea);
        SqlParameter PamSalt = new SqlParameter("@Salt", salt);
        SqlParameter PamPass = new SqlParameter("@Pass", pass);

    //TODO RECOGER ERRORES
       await _context.Database.ExecuteSqlRawAsync(sql, PamNombre, PamApellidos, PamEmail, PamPassword, PamAerolinea, PamSalt, PamPass);

    }


    public async Task<VistaLogedUser> GetLoggedUserData(int idUser)
    {
        var consulta= from datos in _context.VistaLogedUser
            where datos.IdUsuario==idUser
            select datos;

        return await consulta.FirstOrDefaultAsync();
    }


}