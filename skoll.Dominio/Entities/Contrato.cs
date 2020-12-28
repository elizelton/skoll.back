using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class Contrato : BaseEntity
    {
        public int qntdExemplares { get; set; }
        public int tipoDocumento { get; set; }
        public int numParcelas { get; set; }
        public decimal valorTotal { get; set; }
        public decimal juros { get; set; }
        public string observacoes { get; set; }
        public bool ativo { get; set; }
        public int periodoMeses { get; set; }
        public DateTime dataInicio { get; set; }
        public DateTime dataTermino { get; set; }
        public List<ContratoParcela> parcelas { get; set; }
        public List<ContratoServico> servicos { get; set; }
        public FormaPagamento formaPagamento { get; set; }
        public Vendedor vendedor { get; set; }
        public Usuario usuario { get; set; }
        public Cliente cliente { get; set; }
    }
}
