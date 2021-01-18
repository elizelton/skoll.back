using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class ContratoParcela : BaseEntity
    {
        public int idContrato { get; set; }
        public int numParcela { get; set; }
        public decimal valorParcela { get; set; }
        public DateTime dataVencimento { get; set; }
        public int situacao { get; set; }
        public decimal comissao { get; set; }
        public List<ContratoParcelaPagamento> pagamentos { get; set; }
    }
}
