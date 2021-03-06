﻿
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
    public class ContaPagarService : IContaPagarService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ContaPagarService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ContaPagar contaPagar)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarRepositorio.Create(contaPagar);
                context.Repositorios.ContaPagarRepositorio.GerarParcelas(contaPagar);
                context.SaveChanges();
            }
        }

        public void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarRepositorio.GerarParcelaAjuste(idConta, valorDif, vencimento);
                context.SaveChanges();
            }
        }

        public void GerarParcelas(ContaPagar contaPagar)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarRepositorio.GerarParcelas(contaPagar);
                context.SaveChanges();
            }
        }

        public ContaPagar Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ContaPagarRepositorio.Get(id);
            }
        }

        public IEnumerable<ContaPagar> GetAll(string search)
        {
            using (var context = _unitOfWork.Create())
            {
                var list = context.Repositorios.ContaPagarRepositorio.GetAll();
                if (!string.IsNullOrEmpty(search))
                    return list.Where(e => e.nomeFornecedor.ToUpper().Contains(search.ToUpper()));
                else
                    return list;
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ContaPagar contaPagar)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ContaPagarRepositorio.Update(contaPagar);
                //context.Repositorios.ContaPagarRepositorio.GerarParcelas(contaPagar);
                context.SaveChanges();
            }
        }
    }
}
