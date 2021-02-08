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

        public decimal valorComissao { get; set; }
        public decimal percComis { get; set; }
        public int filtro { get; set; }
    }
}
