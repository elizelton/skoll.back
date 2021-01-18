using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContratoParcelaRepositorio : ICRUDRepositorio<ContratoParcela>
    {
        IEnumerable<ContratoParcela> GetByVencimentoAte(DateTime date);
        IEnumerable<ContratoParcela> GetPendentes();
        IEnumerable<ContratoParcela> GetNaoPagasTotalmente();
        IEnumerable<ContratoParcela> GetByContrato(int idContrato);
    }
}
