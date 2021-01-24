using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IFornecedorService
    {
        void Create(Fornecedor fornecedor);

        Fornecedor Get(int id);

        IEnumerable<Fornecedor> GetAll();

        IEnumerable<Fornecedor> GetAtivos();

        IEnumerable<Fornecedor> GetByNomeLike(string nome);

        void Remove(int id);

        void Update(Fornecedor fornecedor);
    }
}
