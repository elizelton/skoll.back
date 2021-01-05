using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IProdutoRepositorio : ICRUDRepositorio<Produto>
    {
        IEnumerable<Produto> GetByNomeLike(string nome);

        IEnumerable<Produto> GetAtivos();
    }
}
