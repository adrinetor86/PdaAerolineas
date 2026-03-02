using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PdaAerolineas.Extensions;

public class SessionCheckAttribute : ActionFilterAttribute
{
    public override void OnActionExecuting(ActionExecutingContext context)
    {
        // Comprobamos la sesión
        if (context.HttpContext.Session.GetString("LOGGED") == null)
        {
            // Redirigir al Login o Dashboard si no hay sesión
            context.Result = new RedirectToActionResult("LogIn", "Usuarios", null);
        }
        
        base.OnActionExecuting(context);
    }
}