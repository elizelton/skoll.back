using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class ContaPagar : BaseEntity
    {
        public int numParcelas { get; set; }
        public decimal valorTotal { get; set; }
        public decimal juros { get; set; }
        public int diasPagamento { get; set; }
        public int diaInicial { get; set; }
        public int mesInicial { get; set; }
        public List<ContaPagarParcela> parcelas { get; set; }
        public Fornecedor fornecedor { get; set; }
    }
}
