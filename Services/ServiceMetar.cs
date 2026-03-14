using System.Net.Http.Headers;
using System.Text.Json;
using PdaAerolineas.Models;

namespace PdaAerolineas.Services;

public class ServiceMetar
{
    private readonly HttpClient _client;
    private readonly string _apiKey;
    private readonly string _baseUrl;
    
    
    public ServiceMetar(HttpClient client, IConfiguration configuration)
    {
        _client = client;
        // Leemos desde la sección "CheckWxApi" del appsettings
        _apiKey = configuration.GetValue<string>("CheckWxApi:ApiKey") ?? "";
        _baseUrl = configuration.GetValue<string>("CheckWxApi:BaseUrl") ?? "";
    }

    public async Task<MetarData?> GetMetarAsync(string iata)
    {
          _client.DefaultRequestHeaders.Clear();
          _client.DefaultRequestHeaders.Add("X-API-Key", _apiKey);
        
        
        string url = $"{_baseUrl}metar/{iata}/decoded";

        try 
        {
            var response = await _client.GetAsync(url);
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var result = JsonSerializer.Deserialize<MetarResponse>(content);
                return result?.Data?.FirstOrDefault();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error API CheckWX: {ex.Message}");
        }
        
        return null;
    }
    
}