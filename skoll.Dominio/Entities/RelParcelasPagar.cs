using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Entities
{
    public class RelParcelasPagar
    {
        public string fornecedorConta { get; set; }

        public decimal valorPagar { get; set; }

        public int numParcela { get; set; }

        public decimal valorPago { get; set; }

        public string dataVencimento { get; set; }
    }
}
