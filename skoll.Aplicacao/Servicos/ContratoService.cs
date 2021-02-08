
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class ContratoService : IContratoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContratoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Contrato Contrato)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoRepositorio.Create(Contrato);
                context.SaveChanges();
            }
        }

        public void GerarParcelas(Contrato Contrato, int diaVencimentoDemais, bool isPrimeiraVigencia)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoRepositorio.GerarParcelas(Contrato, diaVencimentoDemais, isPrimeiraVigencia);
                context.SaveChanges();
            }
        }

        public void CancelarContrato(Contrato contrato, int novoCliente)
        {
            using (var context = _unitOfWork.Create())
            {
                contrato.servicos = context.Repositorios.ContratoServicoRepositorio.GetByContrato(contrato.Id).ToList();
                contrato.parcelas = context.Repositorios.ContratoParcelaRepositorio.GetByContrato(contrato.Id).ToList();
                context.Repositorios.ContratoRepositorio.CancelarContrato(contrato, novoCliente);
                context.SaveChanges();
            }
        }

        public Contrato Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoRepositorio.Get(id);
            }
        }

        public IEnumerable<Contrato> GetAll(string search)
        {
            using (var context = _unitOfWork.Create())
            {
                var list = context.Repositorios.ContratoRepositorio.GetAll();
                if (!string.IsNullOrEmpty(search))
                    return list.Where(e => e.nomeCliente.ToUpper().Contains(search) || e.nomeVendedor.Contains(search.ToUpper()));
                else
                    return list;
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Contrato Contrato)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoRepositorio.Update(Contrato);
                context.SaveChanges();
            }
        }
    }
}
