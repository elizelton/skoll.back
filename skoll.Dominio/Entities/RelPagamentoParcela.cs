using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Entities
{
    public class RelPagamentoParcela
    {
        public string descricao { get; set; }

        public decimal valor { get; set; }

        public string dataPagamento { get; set; }

        public bool isEstrada { get; set; }

        public string nome { get; set; }

        public string numParcela { get; set; }

        public string tipo { get; set; }
    }
}
