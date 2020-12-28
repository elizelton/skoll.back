using skoll.Dominio.Common;
using skoll.Dominio.Enums;

namespace skoll.Dominio.Entities
{
    public class ServicoPrestado : BaseEntity
    {
        public string nome { get; set; }
        public decimal valorUnitario { get; set; }
        public bool ativo { get; set; }
        public Produto produto { get; set; }
    }
}
