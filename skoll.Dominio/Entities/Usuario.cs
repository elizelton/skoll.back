
using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Usuario : BaseEntity
    {
        public string Nome { get; set; }
        public string UserName { get; set; }
        public string Senha { get; set; }
        public bool Ativo { get; set; }

    }
}
