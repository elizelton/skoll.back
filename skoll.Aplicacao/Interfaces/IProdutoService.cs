using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IProdutoService
    {
        void Create(Produto produto);

        Produto Get(int id);

        IEnumerable<Produto> GetAll();

        IEnumerable<Produto> GetAtivos();

        IEnumerable<Produto> GetAtivosComServico();

        IEnumerable<Produto> GetByNomeLike(string nome);

        void Remove(int id);

        void Update(Produto produto);

    }
}
