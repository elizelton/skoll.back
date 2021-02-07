using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class ReciboParcela
    {
        public Cliente cliente { get; set; }
        public string valorExtenso { get; set; }
        public List<ContratoServico> servicos { get; set; }
        public string vencimento { get; set; }
        public int idContrato { get; set; }
        public int idParcela { get; set; }
        public decimal valor { get; set; }
        public int numParcela { get; set; }
        public string observacoes { get; set; }
    }
}
