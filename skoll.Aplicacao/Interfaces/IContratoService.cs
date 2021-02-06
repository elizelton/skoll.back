using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContratoService
    {
        void Create(Contrato Contrato);

        void GerarParcelas(Contrato Contrato, int diaVencimentoDemais, bool isPrimeiraVigencia);

        void CancelarContrato(Contrato contrato, int novoCliente, decimal multa);

        Contrato Get(int id);

        IEnumerable<Contrato> GetAll();

        void Remove(int id);

        void Update(Contrato Contrato);
    }
}
