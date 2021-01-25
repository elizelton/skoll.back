
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class VendedorService : IVendedorService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public VendedorService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Vendedor vendedor)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.VendedorRepositorio.Create(vendedor);
                context.SaveChanges();
            }
        }

        public Vendedor Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.VendedorRepositorio.Get(id);
            }
        }

        public IEnumerable<Vendedor> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.VendedorRepositorio.GetAll();
            }
        }

        public IEnumerable<Vendedor> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.VendedorRepositorio.GetByNomeLike(nome);
            }
        }

        public IEnumerable<Vendedor> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.VendedorRepositorio.GetAtivos();
            }
        }

        public Vendedor GetByCodigo(string codigo)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.VendedorRepositorio.GetByCodigo(codigo);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.VendedorRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Vendedor vendedor)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.VendedorRepositorio.Update(vendedor);
                context.SaveChanges();
            }
        }
    }
}
