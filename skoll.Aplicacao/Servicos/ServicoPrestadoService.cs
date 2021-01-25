
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class ServicoPrestadoService : IServicoPrestadoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public ServicoPrestadoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(ServicoPrestado servPrest)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ServicoPrestadoRepositorio.Create(servPrest);
                context.SaveChanges();
            }
        }

        public ServicoPrestado Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ServicoPrestadoRepositorio.Get(id);
            }
        }

        public IEnumerable<ServicoPrestado> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ServicoPrestadoRepositorio.GetAll();
            }
        }

        public IEnumerable<ServicoPrestado> GetAtivos()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ServicoPrestadoRepositorio.GetAtivos();
            }
        }

        public IEnumerable<ServicoPrestado> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.ServicoPrestadoRepositorio.GetByNomeLike(nome);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ServicoPrestadoRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(ServicoPrestado servPrest)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.ServicoPrestadoRepositorio.Update(servPrest);
                context.SaveChanges();
            }
        }
    }
}
