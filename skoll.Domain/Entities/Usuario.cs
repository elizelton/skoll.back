
using skoll.Domain.Common;

namespace skoll.Domain.Entities
{
    public class Usuario : BaseEntity
    {
        public string Nome { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public bool Situacao { get; set; }

    }
}
