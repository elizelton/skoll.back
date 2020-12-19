
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;

namespace skoll.Aplicacao.Servicos
{
    public class UsuarioService : IUsuarioService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public UsuarioService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Usuario usuario)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Create(usuario);
                context.SaveChanges();
            }
        }

        public Usuario Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.Get(id);
            }
        }

        public IEnumerable<Usuario> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.GetAll();
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Usuario usuario)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Update(usuario);
                context.SaveChanges();
            }
        }
    }
}
