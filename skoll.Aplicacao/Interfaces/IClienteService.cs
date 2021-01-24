using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IClienteService
    {
        void Create(Cliente cliente);

        Cliente Get(int id);

        IEnumerable<Cliente> GetAll();

        IEnumerable<Cliente> GetAtivos();

        IEnumerable<Cliente> GetByNomeLike(string nome);

        void Remove(int id);

        void Update(Cliente cliente);

    }
}
