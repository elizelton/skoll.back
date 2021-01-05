using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface ICidadeRepositorio : ICRUDRepositorio<Cidade>
    {
        IEnumerable<Cidade> GetByNome(string nome);

        IEnumerable<Cidade> GetByEstado(string estado);

        Cidade GetByNomeEstado(string nome, string estado);
    }
}
