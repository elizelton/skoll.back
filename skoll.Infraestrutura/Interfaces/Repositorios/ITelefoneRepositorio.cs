using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface ITelefoneRepositorio : ICRUDRepositorio<Telefone>
    {
        IEnumerable<Telefone> GetByPessoa(int idPessoa);
    }
}
