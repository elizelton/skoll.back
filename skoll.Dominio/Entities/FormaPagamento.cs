using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class FormaPagamento : BaseEntity
    {
        public string nome { get; set; }
        public int qtdParcela { get; set; }
        public bool ativo { get; set; }

    }
}
