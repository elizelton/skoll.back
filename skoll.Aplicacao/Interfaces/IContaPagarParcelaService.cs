using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContaPagarParcelaService
    {
        void Create(ContaPagarParcela contPgParc);

        ContaPagarParcela Get(int id);

        IEnumerable<ContaPagarParcela> GetAll();

        IEnumerable<ContaPagarParcela> GetByContaPagar(int idContPag);

        IEnumerable<ContaPagarParcela> GetByVencimentoAte(DateTime date);

        IEnumerable<ContaPagarParcela> GetNaoPagasTotalmente();

        IEnumerable<ContaPagarParcela> GetPendentes();

        void Remove(int id);

        void Update(ContaPagarParcela contPgParc);
    }
}
