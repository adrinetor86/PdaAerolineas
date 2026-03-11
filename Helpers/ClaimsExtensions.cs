using System.Security.Claims;

namespace PdaAerolineas.Helpers;

public static class ClaimsExtensions
{
    
    public static int GetUserId(this ClaimsPrincipal user)
    {
        var userIdClaim = user.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(userIdClaim, out int userId) ? userId : 0;
    }
        
    public static int GetAerolineaId(this ClaimsPrincipal user)
    {
        var aerolineaIdClaim = user.FindFirstValue("Aerolinea");
        return int.TryParse(aerolineaIdClaim, out int aerolineaId) ? aerolineaId : 0;
    }
        
    public static string GetRol(this ClaimsPrincipal user)
    {
        return user.FindFirstValue(ClaimTypes.Role) ?? "";
    }
        
    public static bool IsAdmin(this ClaimsPrincipal user)
    {
        return user.IsInRole("Administrador");
    }
        
    public static bool IsGestor(this ClaimsPrincipal user)
    {
        return user.IsInRole("Gestor");
    }
        
    public static bool IsMecanico(this ClaimsPrincipal user)
    {
        return user.IsInRole("Mecanico");
    }
}