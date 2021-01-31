
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class ContratoParcelaPagamentoService : IContratoParcelaPagamentoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContratoParcelaPagamentoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContratoParcelaPagamento contParcPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaPagamentoRepositorio.Create(contParcPag);
                context.SaveChanges();
            }
        }

        public ContratoParcelaPagamento Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaPagamentoRepositorio.Get(id);
            }
        }

        public IEnumerable<ContratoParcelaPagamento> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaPagamentoRepositorio.GetAll();
            }
        }

        public IEnumerable<ContratoParcelaPagamento> GetByContratoParcela(int idcontParc)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoParcelaPagamentoRepositorio.GetByContratoParcela(idcontParc);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaPagamentoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContratoParcelaPagamento contParcPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoParcelaPagamentoRepositorio.Update(contParcPag);
                context.SaveChanges();
            }
        }
    }
}
