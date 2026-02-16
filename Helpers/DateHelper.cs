using System;
using System.Globalization;

namespace PdaAerolineas.Helpers;

public static class DateHelper
{
    private static readonly CultureInfo CulturaEspanol = new CultureInfo("es-ES");


    public static string ToFomatoCorto(this DateTime fecha)
    {
        return fecha.ToString("dd MMM HH:mm", new CultureInfo("es-ES"));  
    }
    
    public static string ToFormatoCompleto(this DateTime fecha)
    {
        return fecha.ToString("dd MMM yyyy HH:mm", new CultureInfo("es-ES"));
    }
}