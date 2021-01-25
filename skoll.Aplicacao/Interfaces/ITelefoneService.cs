using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface ITelefoneService
    {
        void Create(Telefone tel);

        Telefone Get(int id);

        IEnumerable<Telefone> GetAll();

        IEnumerable<Telefone> GetByPessoa(int idPessoa);

        void Remove(int id);

        void Update(Telefone tel);

    }
}
