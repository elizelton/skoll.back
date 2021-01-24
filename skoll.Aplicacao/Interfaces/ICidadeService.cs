using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface ICidadeService
    {
        void Create(Cidade cidade);

        Cidade Get(int id);

        IEnumerable<Cidade> GetAll();

        IEnumerable<Cidade> GetByEstado(string estado);

        IEnumerable<Cidade> GetByNome(string nome);

        Cidade GetByNomeEstado(string nome, string estado);

        void Remove(int id);

        void Update(Cidade cidade);
    }
}
