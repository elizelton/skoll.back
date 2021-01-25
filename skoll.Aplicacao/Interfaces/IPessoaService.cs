using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IPessoaService
    {
        void Create(Pessoa pessoa);
        Pessoa Get(int id);
        IEnumerable<Pessoa> GetAll();
        IEnumerable<Pessoa> GetByNomeLike(string nome);
        Pessoa GetByCpfCnpj(string cpfCnpj);
        void Remove(int id);
        void Update(Pessoa pessoa);
    }
}
