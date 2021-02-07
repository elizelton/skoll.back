using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContaPagarService
    {
        void Create(ContaPagar contaPagar);

        void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento);

        void GerarParcelas(ContaPagar contaPagar);

        ContaPagar Get(int id);

        IEnumerable<ContaPagar> GetAll(string search);

        void Remove(int id);

        void Update(ContaPagar contaPagar);
    }
}
