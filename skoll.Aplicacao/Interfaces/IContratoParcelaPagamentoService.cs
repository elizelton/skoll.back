using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContratoParcelaPagamentoService
    {
        void Create(ContratoParcelaPagamento contParcPag);

        ContratoParcelaPagamento Get(int id);

        IEnumerable<ContratoParcelaPagamento> GetAll();

        IEnumerable<ContratoParcelaPagamento> GetByContratoParcela(int idcontParc);

        void Remove(int id);

        void Update(ContratoParcelaPagamento contParcPag);
    }
}
