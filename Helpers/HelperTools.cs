using System.Security.Cryptography;
using System.Text;

namespace PdaAerolineas.Helpers;

public class HelperTools
{
    //public static string GenerateSalt()
    //{
    //    Random random = new Random();
    //    string salt = "";
    //    for (int i = 1; i <= 50; i++)
    //    {
    //        int num =random.Next(1, 255);
    //        char letra = Convert.ToChar(num);
    //        salt += letra;
    //    }
    //    return salt;
    //}


    public static string GenerateSalt()
        {
        // Generamos 32 bytes reales de aleatoriedad
        byte[] saltBytes = RandomNumberGenerator.GetBytes(32);
        // Convertimos a una cadena de texto segura que NO tiene caracteres invisibles
        return Convert.ToBase64String(saltBytes);
        }

    public static bool CompareArrays(byte[] a, byte[] b)
    {
        bool iguales = true;
        
        if (a.Length != b.Length)
        {
            iguales = false;
        }
        else
        {
            //COMPARAMOS BYTE A BYTE
            for (int i = 0; i < a.Length; i++)
            {
                if (a[i].Equals(b[i])==false)
                {
                    iguales = false;
                    break;
                }
            }
        }
        return iguales;
    }
    
    public static byte[] EncryptPassword(string password, string salt)
    {
        string contenido = password + salt;
        SHA512 managed=SHA512.Create();
        byte[] salida= Encoding.UTF8.GetBytes(contenido);

        for (int i = 1; i <= 20; i++)
        {
            salida = managed.ComputeHash(salida);
                
        }
        managed.Clear();
        return salida;
    }
    
}