namespace PdaAerolineas.Models.FormViews;

public class VueloCache
{
        public int IdVuelo { get; set; }
        public int IdEstado { get; set; }
        public string Puerta { get; set; }
        public int PasajerosConfirmados { get; set; }
        public int PasajerosEmbarcados { get; set; }
        public int IdCapitan { get; set; }
        public int IdCopiloto { get; set; }
        public List<int> IdsTcp { get; set; } = new List<int>();
}