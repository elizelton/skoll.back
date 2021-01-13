using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class ContaPagarParcela : BaseEntity
    {
        public int idContaPagar { get; set; }
        public int numParcela { get; set; }
        public decimal valorParcela { get; set; }
        public DateTime dataVencimento { get; set; }
        public List<ContaPagarParcelaPagamento> pagamentos { get; set; }
    }
}
