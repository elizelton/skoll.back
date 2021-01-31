using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class RelContrato
    {
        string clienteContrato { get; set; }

        DateTime inicio { get; set; }

        string vendedor { get; set; }

        int numParcelas { get; set; }

        decimal valorTotal { get; set; }

        string formaPagamento { get; set; }

        string status { get; set; }
    }
}
