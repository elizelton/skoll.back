
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class ClienteService : IClienteService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ClienteService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Cliente cliente)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ClienteRepositorio.Create(cliente);
                context.SaveChanges();
            }
        }

        public Cliente Get(int id)
        {
            using(var context = _unitOfWork.Create())
            {
                return context.Repositorios.ClienteRepositorio.Get(id);
            }
        }

        public IEnumerable<Cliente> GetAll(string search)
        {
            using (var context = _unitOfWork.Create())
            {
                var list = context.Repositorios.ClienteRepositorio.GetAll();
                if (!string.IsNullOrEmpty(search))
                    return list.Where(e => e.nome.Contains(search) || e.cpfCnpj.Contains(search));
                else
                    return list;
            }
        }

        public IEnumerable<Cliente> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ClienteRepositorio.GetAtivos();
            }
        }

        public IEnumerable<Cliente> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ClienteRepositorio.GetByNomeLike(nome);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ClienteRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Cliente cliente)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ClienteRepositorio.Update(cliente);
                context.SaveChanges();
            }
        }
    }
}
