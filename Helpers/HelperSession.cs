using PdaAerolineas.Extensions;

namespace PdaAerolineas.Helpers;

public static class HelperSession
{
  public static bool IsAdmin(HttpContext context)
  {
    Console.WriteLine("**********************************************************");
    Console.WriteLine(context.Session.GetObject<int>("ROL"));
    return context.Session.GetObject<int>("ROL") == 1;
  }

  public static bool IsGestor(HttpContext context)
    {
      return context.Session.GetObject<int>("ROL") == 2;
    } 
    public static bool IsMecanico(HttpContext context)
    {
      return context.Session.GetObject<int>("ROL") == 3;
    }

}