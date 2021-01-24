using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IClienteRepositorio : ICRUDRepositorio<Cliente>
    {
        IEnumerable<Cliente> GetAtivos();

        IEnumerable<Cliente> GetByNomeLike(string nome);
    }
}
