
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
    public class ContratoServicoService : IContratoServicoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContratoServicoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContratoServico contServ)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoServicoRepositorio.Create(contServ);
                context.SaveChanges();
            }
        }

        public ContratoServico Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoServicoRepositorio.Get(id);
            }
        }

        public IEnumerable<ContratoServico> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoServicoRepositorio.GetAll();
            }
        }

        public IEnumerable<ContratoServico> GetByContrato(int idContPag)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContratoServicoRepositorio.GetByContrato(idContPag);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoServicoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContratoServico contServ)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContratoServicoRepositorio.Update(contServ);
                context.SaveChanges();
            }
        }
    }
}
