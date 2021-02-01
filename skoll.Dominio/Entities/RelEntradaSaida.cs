using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Entities
{
    public class RelEntradaSaida
    {
        public string descricao { get; set; }

        public decimal valor { get; set; }

        public bool isEstrada { get; set; }
    }
}
