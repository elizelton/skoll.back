using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;

namespace skoll.Dominio.Entities
{
    public class PagamentoComissao
    {
        public int idContrato { get; set; }

        public string cliente { get; set; }

        public string vendedor { get; set; }

        public DateTime dataPagamento { get; set; }

        public decimal valorComissao { get; set; }
    }
}
