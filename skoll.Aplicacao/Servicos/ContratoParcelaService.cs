
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
    public class ContratoParcelaService : IContratoParcelaService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContratoParcelaService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContratoParcela contParc)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaRepositorio.Create(contParc);
                context.SaveChanges();
            }
        }

        public ContratoParcela Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.Get(id);
            }
        }

        public IEnumerable<ContratoParcela> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.GetAll();
            }
        }

        public IEnumerable<ContratoParcela> GetByContrato(int idContPag)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.GetByContrato(idContPag);
            }
        }

        public IEnumerable<ContratoParcela> GetByVencimentoAte(DateTime date)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.GetByVencimentoAte(date);
            }
        }

        public IEnumerable<ContratoParcela> GetNaoPagasTotalmente()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.GetNaoPagasTotalmente();
            }
        }

        public IEnumerable<ContratoParcela> GetPendentes()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaRepositorio.GetPendentes();
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContratoParcela contParc)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaRepositorio.Update(contParc);
                context.SaveChanges();
            }
        }
    }
}
