using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContaPagarParcelaPagamentoRepositorio : ICRUDRepositorio<ContaPagarParcelaPagamento>
    {
        IEnumerable<ContaPagarParcelaPagamento> GetByContaPagarParcela(int idContPgParc);
    }
}
