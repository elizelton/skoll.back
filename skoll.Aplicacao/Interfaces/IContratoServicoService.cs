using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IContratoServicoService
    {
        void Create(ContratoServico contServ);

        ContratoServico Get(int id);

        IEnumerable<ContratoServico> GetAll();

        IEnumerable<ContratoServico> GetByContrato(int idContPag);

        void Remove(int id);

        void Update(ContratoServico contServ);
    }
}
