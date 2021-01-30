using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContaPagarParcelaPagamentoService
    {
        void Create(ContaPagarParcelaPagamento contPgParcPag);

        ContaPagarParcelaPagamento Get(int id);

        IEnumerable<ContaPagarParcelaPagamento> GetAll();

        IEnumerable<ContaPagarParcelaPagamento> GetByContaPagarParcela(int idContPgParc);

        void Remove(int id);

        void Update(ContaPagarParcelaPagamento contPgParcPag);
    }
}
