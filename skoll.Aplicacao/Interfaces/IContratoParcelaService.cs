using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContratoParcelaService
    {
        void Create(ContratoParcela contParc);

        ContratoParcela Get(int id);

        IEnumerable<ContratoParcela> GetAll();

        IEnumerable<ContratoParcela> GetByContrato(int idContPag);

        IEnumerable<ContratoParcela> GetByVencimentoAte(DateTime date);

        IEnumerable<ContratoParcela> GetNaoPagasTotalmente();

        IEnumerable<ContratoParcela> GetPendentes();

        void Remove(int id);

        void Update(ContratoParcela contParc);
    }
}
