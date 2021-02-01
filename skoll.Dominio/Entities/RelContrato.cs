using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class RelContrato
    {
        public string clienteContrato { get; set; }

        public string inicio { get; set; }

        public string vendedor { get; set; }

        public int numParcelas { get; set; }

        public decimal valorTotal { get; set; }

        public string formaPagamento { get; set; }

        public string status { get; set; }
    }
}
