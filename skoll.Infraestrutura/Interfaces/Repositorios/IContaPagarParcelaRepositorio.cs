using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContaPagarParcelaRepositorio : ICRUDRepositorio<ContaPagarParcela>
    {
        IEnumerable<ContaPagarParcela> GetByVencimentoAte(DateTime date);
        IEnumerable<ContaPagarParcela> GetPendentes();
        IEnumerable<ContaPagarParcela> GetNaoPagasTotalmente();
        IEnumerable<ContaPagarParcela> GetByContaPagar(int idContPag);
    }
}
