
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class FornecedorService : IFornecedorService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public FornecedorService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Fornecedor fornecedor)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FornecedorRepositorio.Create(fornecedor);
                context.SaveChanges();
            }
        }

        public Fornecedor Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FornecedorRepositorio.Get(id);
            }
        }

        public IEnumerable<Fornecedor> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FornecedorRepositorio.GetAll();
            }
        }

        public IEnumerable<Fornecedor> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FornecedorRepositorio.GetAtivos();
            }
        }

        public IEnumerable<Fornecedor> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.FornecedorRepositorio.GetByNomeLike(nome);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FornecedorRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Fornecedor fornecedor)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.FornecedorRepositorio.Update(fornecedor);
                context.SaveChanges();
            }
        }
    }
}
