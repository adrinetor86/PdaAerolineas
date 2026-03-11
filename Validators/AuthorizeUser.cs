using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PdaAerolineas.Extensions;

public class AuthorizeUser : AuthorizeAttribute,IAuthorizationFilter
{
    public void OnAuthorization(AuthorizationFilterContext context)
    {

        var user = context.HttpContext.User;

        if (user.Identity.IsAuthenticated==false)
        {
            context.Result = GetRoute("Usuarios", "LogIn");
            

        }
        // else
        // {
        //         context.Result=GetRoute("Dashboard", "Index");
        // }
    }
    
    private RedirectToRouteResult GetRoute(string controller, string action)
    {
        RouteValueDictionary ruta =
            new RouteValueDictionary(new
            {
                Controller = controller,
                Action = action
            });
        RedirectToRouteResult result = new RedirectToRouteResult(ruta);
        return result;
    }
}