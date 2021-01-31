using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IFornecedorRepositorio : ICRUDRepositorio<Fornecedor>
    {
        IEnumerable<Fornecedor> GetAtivos();

        IEnumerable<Fornecedor> GetByNomeLike(string nome);

        int GetIdPessoa(int idFornecedor);
    }
}
