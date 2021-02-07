using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IVendedorService
    {
        void Create(Vendedor vendedor);

        Vendedor Get(int id);

        IEnumerable<Vendedor> GetAll(string search);

        IEnumerable<Vendedor> GetByNomeLike(string nome);

        IEnumerable<Vendedor> GetAtivos();

        Vendedor GetByCodigo(string codigo);

        void Remove(int id);

        void Update(Vendedor vendedor);
    }
}
