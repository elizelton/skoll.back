using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Telefone : BaseEntity
    {
        public string ddd { get; set; }
        public string telefone { get; set; }
        public int tipoTelefone { get; set; }
        public bool whatsApp { get; set; }
    }
}
