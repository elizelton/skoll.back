using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class Vendedor : BaseEntity
    {
        public string nome { get; set; }
        public string cpf { get; set; }
        public string codigo { get; set; }
        public decimal percComis { get; set; }
        public bool ativo { get; set; }
    }
}
