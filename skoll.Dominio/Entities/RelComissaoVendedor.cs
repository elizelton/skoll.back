using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class RelComissaoVendedor 
    {
        string clienteContrato { get; set; }

        decimal valorComissao { get; set; }

        decimal valorPago { get; set; }
    }
}
