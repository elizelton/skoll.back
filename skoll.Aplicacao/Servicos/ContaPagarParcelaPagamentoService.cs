
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class ContaPagarParcelaPagamentoService : IContaPagarParcelaPagamentoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContaPagarParcelaPagamentoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContaPagarParcelaPagamento contPgParcPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaPagamentoRepositorio.Create(contPgParcPag);
                context.SaveChanges();
            }
        }

        public ContaPagarParcelaPagamento Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaPagamentoRepositorio.Get(id);
            }
        }

        public IEnumerable<ContaPagarParcelaPagamento> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaPagamentoRepositorio.GetAll();
            }
        }

        public IEnumerable<ContaPagarParcelaPagamento> GetByContaPagarParcela(int idContPgParc)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarParcelaPagamentoRepositorio.GetByContaPagarParcela(idContPgParc);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaPagamentoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContaPagarParcelaPagamento contPgParcPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarParcelaPagamentoRepositorio.Update(contPgParcPag);
                context.SaveChanges();
            }
        }
    }
}
