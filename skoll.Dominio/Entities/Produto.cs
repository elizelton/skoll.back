using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Produto : BaseEntity
    {
        public string nome { get; set; }
        public bool ativo { get; set; }

    }
}
