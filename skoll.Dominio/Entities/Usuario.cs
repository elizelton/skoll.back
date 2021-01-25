using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Usuario : BaseEntity
    {
        public string nome { get; set; }
        public string userName { get; set; }
        public string email { get; set; }
        public string senha { get; set; }
        public bool ativo { get; set; }

    }
}
