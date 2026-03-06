using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PdaAerolineas.Extensions;



//ROLES QUE NO SON MECANICOS
public class HighRolesAttribute: ActionFilterAttribute
{
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var roleId = context.HttpContext.Session.GetObject<int>("ROL");
            
            if (roleId == 1 || roleId== 2)
            {
                base.OnActionExecuting(context);
              
            }
            else
            {
                context.Result = new RedirectToActionResult("Index", "Dashboard", null);         
            }
    }
}


