
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
    public class ContaPagarParcelaService : IContaPagarParcelaService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContaPagarParcelaService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContaPagarParcela contPgParc)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaRepositorio.Create(contPgParc);
                context.SaveChanges();
            }
        }

        public ContaPagarParcela Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.Get(id);
            }
        }

        public IEnumerable<ContaPagarParcela> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.GetAll();
            }
        }

        public IEnumerable<ContaPagarParcela> GetByContaPagar(int idContPag)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.GetByContaPagar(idContPag);
            }
        }

        public IEnumerable<ContaPagarParcela> GetByVencimentoAte(DateTime date)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.GetByVencimentoAte(date);
            }
        }

        public IEnumerable<ContaPagarParcela> GetNaoPagasTotalmente()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.GetNaoPagasTotalmente();
            }
        }

        public IEnumerable<ContaPagarParcela> GetPendentes()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaRepositorio.GetPendentes();
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContaPagarParcela contPgParc)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaRepositorio.Update(contPgParc);
                context.SaveChanges();
            }
        }
    }
}
