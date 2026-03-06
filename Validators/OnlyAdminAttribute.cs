using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PdaAerolineas.Extensions;

public class OnlyAdminAttribute :ActionFilterAttribute
{

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var roleId = context.HttpContext.Session.GetObject<int>("ROL");

            // Si no hay RoleId o no es el ID de administrador (ej: 1)
            if (roleId == null || roleId != 1) 
            {
                // Redirigir a una página de "No autorizado" o al Dashboard
                context.Result = new RedirectToActionResult("Index", "Dashboard", new { msg = "NoTienesPermiso" });
            }

            base.OnActionExecuting(context);
        
    }

}