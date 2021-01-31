using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Entities
{
    public class RelParcelasVencer
    {
        string clienteContrato { get; set; }

        decimal valorPagar { get; set; }

        decimal valorPago { get; set; }

        DateTime dataVencimento { get; set; }
    }
}
