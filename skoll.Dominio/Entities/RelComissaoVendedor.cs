using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class RelComissaoVendedor 
    {
        public int idContrato { get; set; }

        public string clienteContrato { get; set; }

        public decimal valorComissao { get; set; }

        public string tipoPagamento { get; set; }

        public string vendedor { get; set; }
    }
}
