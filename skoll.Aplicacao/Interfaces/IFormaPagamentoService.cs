using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IFormaPagamentoService
    {
        void Create(FormaPagamento formaPag);

        FormaPagamento Get(int id);

        IEnumerable<FormaPagamento> GetAll(string search);

        IEnumerable<FormaPagamento> GetAtivos();

        IEnumerable<FormaPagamento> GetByNomeLike(string nome);

        void Remove(int id);

        void Update(FormaPagamento formaPag);
    }
}
