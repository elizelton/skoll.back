﻿
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class FormaPagamentoService : IFormaPagamentoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public FormaPagamentoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(FormaPagamento formaPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FormaPagamentoRepositorio.Create(formaPag);
                context.SaveChanges();
            }
        }

        public FormaPagamento Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FormaPagamentoRepositorio.Get(id);
            }
        }

        public IEnumerable<FormaPagamento> GetAll()
        {
            using(var context = _unitOfWork.Create())
            {
                return context.Repositorios.FormaPagamentoRepositorio.GetAll();
            }
        }

        public IEnumerable<FormaPagamento> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FormaPagamentoRepositorio.GetAtivos();
            }
        }

        public IEnumerable<FormaPagamento> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FormaPagamentoRepositorio.GetByNomeLike(nome);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FormaPagamentoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(FormaPagamento formaPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FormaPagamentoRepositorio.Update(formaPag);
                context.SaveChanges();
            }
        }
    }
}