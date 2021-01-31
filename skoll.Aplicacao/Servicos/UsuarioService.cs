
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
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

            usuario.senha = GetSHA1(usuario.senha);

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

        public void Remove(List<Usuario> usuarios)
        {
            if (usuarios.Any(u => u.Id == 0))
                throw new AppError("Campo Id obrigratório");

            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Remove(usuarios);
                context.SaveChanges();
            }
        }

        public void Update(Usuario usuario)
        {
            if (!string.IsNullOrEmpty(usuario.senha))
                usuario.senha = GetSHA1(usuario.senha);

            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Update(usuario);
                context.SaveChanges();
            }
        }

        public Usuario GetByUserNameESenha(string username, string senha)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.GetByUserNameESenha(username, senha);
            }
        }

        public Usuario GetByUserName(string username)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.GetByUserName(username);
            }
        }

        public Usuario GetByEmail(string email)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.GetByEmail(email);
            }
        }
    }
}
