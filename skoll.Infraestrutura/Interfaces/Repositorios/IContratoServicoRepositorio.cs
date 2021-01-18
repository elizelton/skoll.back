using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContratoServicoRepositorio : ICRUDRepositorio<ContratoServico>
    {
        IEnumerable<ContratoServico> GetByContrato(int idContrato);
    }
}
