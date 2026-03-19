using System;
using System.Collections.Generic;
using PdaAerolineas.Models.Views;
using PdaAerolineas.Repositories;

namespace PdaAerolineas.Models.ViewModels;

public class FinanzasDashboardViewModel
{
    public VistaFinanzasResumen? Resumen { get; set; }

    public List<FinanzasVueloDetalle> DetalleVuelos { get; set; } = new();
    
    public string LabelsVuelosJson { get; set; } = "[]";
    public string IngresosVuelosJson { get; set; } = "[]";
    public string CostesVuelosJson { get; set; } = "[]";

    public string LabelsDiasJson { get; set; } = "[]";
    public string BeneficiosDiasJson { get; set; } = "[]";
}

