using Microsoft.AspNetCore.Hosting.Server;

namespace PdaAerolineas.Helpers;



public enum Folders {Images,Logos}
public  class HelperPathProvider
{
    
    
    private IWebHostEnvironment _hostEnvironment;
    private IHttpContextAccessor _httpContext;
    private IServer _server;

    public HelperPathProvider(IWebHostEnvironment hostEnvironment,IHttpContextAccessor httpContext,IServer server)
    {
        _hostEnvironment = hostEnvironment;
        _httpContext = httpContext;
        _server = server;
    }
    
    public string MapPath(string fileName, Folders folder)
    {
        string carpeta = "";
        if (folder == Folders.Images)
        {
            carpeta = "images";
        }else if (folder == Folders.Logos)
        {
            carpeta= Path.Combine("images","logos");
        }

        string rootPath = _hostEnvironment.WebRootPath;
        string path = Path.Combine(rootPath, carpeta, fileName);

        return path;
    }

    public string MapUrlPath(string fileName, Folders folder)
    {
        string carpeta = "";
        if (folder == Folders.Images)
        {
            carpeta = "images";
        }
       else if (folder == Folders.Logos){
     
            carpeta = "images/logos";

        };
        //MANERA CON ACCESSOR
        var request = _httpContext.HttpContext.Request;
        string path = $"{request.Scheme}://{request.Host}/{carpeta}/{fileName}";
        return path;
    }

    
}