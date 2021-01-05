using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IFormaPagamentoRepositorio : ICRUDRepositorio<FormaPagamento>
    {
        IEnumerable<FormaPagamento> GetByNomeLike(string nome);

        IEnumerable<FormaPagamento> GetAtivos();
    }
}
