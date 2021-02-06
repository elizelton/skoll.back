using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IContratoRepositorio : ICRUDRepositorio<Contrato>
    {
        public void GerarParcelas(Contrato Contrato, int diaVencimentoDemais, bool isPrimeiraVigencia);
        public void CancelarContrato(Contrato contrato, int novoCliente, decimal multa);
    }
}
