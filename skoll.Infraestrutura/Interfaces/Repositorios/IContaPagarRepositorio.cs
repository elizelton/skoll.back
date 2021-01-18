using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContaPagarRepositorio : ICRUDRepositorio<ContaPagar>
    {
        public void GerarParcelas(ContaPagar contaPagar);
        public void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento);
    }
}
