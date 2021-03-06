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
    public class ProdutoService : IProdutoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ProdutoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Produto produto)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ProdutoRepositorio.Create(produto);
                context.SaveChanges();
            }
        }

        public Produto Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ProdutoRepositorio.Get(id);
            }
        }

        public IEnumerable<Produto> GetAll(string search)
        {
            using (var context = _unitOfWork.Create())
            {
                var list = context.Repositorios.ProdutoRepositorio.GetAll();
                if (!string.IsNullOrEmpty(search))
                    return list.Where(e => e.nome.ToUpper().Contains(search.ToUpper()));
                else
                    return list;
            }
        }

        public IEnumerable<Produto> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ProdutoRepositorio.GetAtivos();
            }
        }

        public IEnumerable<Produto> GetAtivosComServico()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ProdutoRepositorio.GetAtivosComServico();
            }
        }

        public IEnumerable<Produto> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ProdutoRepositorio.GetByNomeLike(nome);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ProdutoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Produto produto)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ProdutoRepositorio.Update(produto);
                context.SaveChanges();
            }
        }
    }
}
