namespace PdaAerolineas.Helpers;

public static class HelperSession
{
  public static bool IsAdmin(HttpContext context)
  {
    return context.Session.GetInt32("ROL") == 1;
  }

  public static bool IsGestor(HttpContext context)
    {
      return context.Session.GetInt32("ROL") == 2;
    } 
    public static bool IsMecanico(HttpContext context)
    {
      return context.Session.GetInt32("ROL") == 3;
    }

}