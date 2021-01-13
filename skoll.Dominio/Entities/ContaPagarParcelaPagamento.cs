using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;

namespace skoll.Dominio.Entities
{
    public class ContaPagarParcelaPagamento : BaseEntity
    {
        public decimal valorPagamento { get; set; }
        public decimal juros { get; set; }
        public DateTime dataPagamento { get; set; }
        public int idContaPagarParcela { get; set; }
    }
}
