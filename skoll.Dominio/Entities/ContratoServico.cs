using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class ContratoServico : BaseEntity
    {
        public int idContrato { get; set; }
        public int quantidade { get; set; }
        public decimal valorUnitario { get; set; }
        public decimal valorTotal { get; set; }
        public ServicoPrestado servicoPrestado { get; set; }
    }
}
