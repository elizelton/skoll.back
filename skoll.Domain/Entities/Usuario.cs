
using skoll.Domain.Common;
using skoll.Dominio.Enums;

namespace skoll.Domain.Entities
{
    public class Usuario : BaseEntity
    {
        public string Nome { get; set; }
        public string UserName { get; set; }
        public string Senha { get; set; }
        public bool Ativo { get; set; }

    }
}
