using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IVendedorRepositorio : ICRUDRepositorio<Vendedor>
    {
        IEnumerable<Vendedor> GetByNomeLike(string nome);

        IEnumerable<Vendedor> GetAtivos();

        Vendedor GetByCodigo(string codigo);
    }
}
