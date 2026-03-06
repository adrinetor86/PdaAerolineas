using Microsoft.EntityFrameworkCore;
using PdaAerolineas.Data;
using PdaAerolineas.Repositories;
using PdaAerolineas.Services;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
// builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();
builder.Services.AddMemoryCache();
builder.Services.AddAntiforgery();


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
app.MapControllers();
app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapHub<VueloHub>("/hubs/vuelos");

app.UseSession();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Usuarios}/{action=LogIn}/{id?}")
    .WithStaticAssets();


app.Run();
