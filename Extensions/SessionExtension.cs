using System.Text.Json;

namespace PdaAerolineas.Extensions;

public static class SessionExtension
{
    public static void SetObject(this ISession session, string key, object value)
    {
        string json= JsonSerializer.Serialize(value);
        session.SetString(key,json);
    }

    public static T GetObject<T>(this ISession session, string key)
    {
        string data= session.GetString(key);
        
        if (data == null)
        {
            return default(T);
        }
        
        return JsonSerializer.Deserialize<T>(data);
    }

}