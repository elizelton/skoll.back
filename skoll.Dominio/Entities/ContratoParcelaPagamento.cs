using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;

namespace skoll.Dominio.Entities
{
    public class ContratoParcelaPagamento : BaseEntity
    {
        public decimal valorPagamento { get; set; }
        public decimal juros { get; set; }
        public decimal comissao { get; set; }
        public DateTime dataPagamento { get; set; }
        public int idContratoParcela { get; set; }
    }
}
