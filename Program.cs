using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Helpers;
using PdaAerolineas.Repositories;
using PdaAerolineas.Services;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllersWithViews
    (options=> options.EnableEndpointRouting=false);

builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();

builder.Services.AddAuthentication
    (options =>
    {
        options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = CookieAuthenticationDefaults.AuthenticationScheme;
     
    }).AddCookie(options =>
        {
            options.LoginPath = "/Usuarios/Login";           // Ruta de login
            options.LogoutPath = "/Usuarios/Logout";         // Ruta de logout
            options.AccessDeniedPath = "/Usuarios/AccessDenied"; // Sin permisos
            options.SlidingExpiration = true; 
        });
    builder.Services.AddAuthorization(options =>
    {
        //ADMINISTRADOR
        options.AddPolicy("AdminOnly", policy => policy.RequireRole("Administrador"));
        
        options.AddPolicy("GestorOnly", policy => policy.RequireRole("Gestor"));
        
        options.AddPolicy("MecanicoOnly", policy => policy.RequireRole("Mecanico"));
        
        options.AddPolicy("AdminOrGestor", policy => policy.RequireRole("Administrador","Gestor"));
        
    });



builder.Services.AddMemoryCache();
builder.Services.AddSingleton<HelperPathProvider>();

builder.Services.AddAntiforgery();

builder.Services.AddHttpContextAccessor(); 

string connectionString = builder.Configuration.GetConnectionString("SqlPda");

builder.Services.AddTransient<RepositoryFlotas>();
builder.Services.AddTransient<RepositoryVuelos>();
builder.Services.AddTransient<RepositoryTripulantes>();
builder.Services.AddTransient<RepositoryMantenimientos>();
builder.Services.AddTransient<RepositoryRutas>();
builder.Services.AddTransient<RepositoryRetrasos>();
builder.Services.AddTransient<RepositoryAviones>();
builder.Services.AddTransient<RepositoryUsuarios>();
builder.Services.AddTransient<RepositoryAerolineas>();
builder.Services.AddTransient<RepositoryAeropuertos>();
builder.Services.AddTransient<RepositoryDashboard>();

builder.Services.AddDbContext<DataContext>
    (options => options.UseSqlServer(connectionString));


builder.Services.AddHttpClient<ServiceMetar>();

builder.Services.AddSignalR();
builder.Services.AddHostedService<RepositorySimulador>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// app.MapControllers();

app.UseHttpsRedirection();

app.UseStaticFiles();

// app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

// app.MapStaticAssets();

app.MapHub<VueloHub>("/hubs/vuelos");

app.UseSession();

app.UseMvc(routes =>
    routes.MapRoute(name : "default",
        template: "{controller=Dashboard}/{action=Index}/{id?}"));

// app.MapControllerRoute(
//     name: "default",
//     pattern: "{controller=Usuarios}/{action=LogIn}/{id?}")
//     .WithStaticAssets();
//

app.Run();
