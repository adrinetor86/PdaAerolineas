using System.Text.Json.Serialization;

namespace PdaAerolineas.Models;

public class MetarResponse
{
    [JsonPropertyName("results")] public int Results { get; set; }

    [JsonPropertyName("data")] public List<MetarData> Data { get; set; }
}

public class MetarData
{
    [JsonPropertyName("icao")] public string Icao { get; set; }
    [JsonPropertyName("raw_text")] public string RawText { get; set; }
    [JsonPropertyName("observed")] public DateTime Observed { get; set; }
    [JsonPropertyName("flight_category")] public string FlightCategory { get; set; }
    [JsonPropertyName("humidity")] public int? Humidity { get; set; }

    [JsonPropertyName("station")] public StationInfo Station { get; set; }
    [JsonPropertyName("temperature")] public TemperatureInfo Temperature { get; set; }
    [JsonPropertyName("dewpoint")] public TemperatureInfo Dewpoint { get; set; }
    [JsonPropertyName("wind")] public WindInfo Wind { get; set; }
    [JsonPropertyName("visibility")] public VisibilityInfo Visibility { get; set; }
    [JsonPropertyName("pressure")] public PressureInfo Pressure { get; set; }
    [JsonPropertyName("clouds")] public List<CloudInfo> Clouds { get; set; }
    [JsonPropertyName("remarks")] public List<string> Remarks { get; set; }
}

public class StationInfo
{
    [JsonPropertyName("name")] public string Name { get; set; }
    [JsonPropertyName("location")] public string Location { get; set; }
}

public class TemperatureInfo
{
    [JsonPropertyName("celsius")] public double Celsius { get; set; }
}

public class WindInfo
{
    [JsonPropertyName("degrees")] public int Degrees { get; set; }
    [JsonPropertyName("speed")] public WindSpeed Speed { get; set; }
    [JsonPropertyName("direction")] public string Direction { get; set; }
}

public class WindSpeed
{
    [JsonPropertyName("kts")] public int Kts { get; set; }
}

public class VisibilityInfo
{
    [JsonPropertyName("miles")] public double Miles { get; set; }
    [JsonPropertyName("text")] public string Text { get; set; }
}

public class PressureInfo
{
    [JsonPropertyName("hg")] public double Hg { get; set; }
    [JsonPropertyName("mb")] public double Mb { get; set; }
}

public class CloudInfo
{
    [JsonPropertyName("code")] public string Code { get; set; }
    [JsonPropertyName("feet")] public int Feet { get; set; }
    [JsonPropertyName("text")] public string Text { get; set; }
}