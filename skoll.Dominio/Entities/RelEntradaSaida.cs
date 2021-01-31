using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Entities
{
    public class RelEntradaSaida
    {
        string descricao { get; set; }

        decimal valor { get; set; }

        bool isEstrada { get; set; }
    }
}
