using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Fornecedor : BaseEntity
    {
        public int idFornecedor { get; set; }
        public bool ativo { get; set; }
        public int tipoFornecedor { get; set; }
        public Pessoa pessoa { get; set; }
    }
}
