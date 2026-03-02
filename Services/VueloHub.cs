using Microsoft.AspNetCore.SignalR;

namespace PdaAerolineas.Services;

public class VueloHub : Hub
{
    private static string VueloGroupName(int idVuelo) => $"vuelo:{idVuelo}";

    public async Task JoinVueloGroup(int idVuelo)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, VueloGroupName(idVuelo));
    }

    public async Task LeaveVueloGroup(int idVuelo)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, VueloGroupName(idVuelo));
    }
}