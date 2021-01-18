using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContratoParcelaPagamentoRepositorio : ICRUDRepositorio<ContratoParcelaPagamento>
    {
        IEnumerable<ContratoParcelaPagamento> GetByContratoParcela(int idContratoParc);
    }
}
