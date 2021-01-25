
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class TelefoneService : ITelefoneService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public TelefoneService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Telefone tel)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.TelefoneRepositorio.Create(tel);
                context.SaveChanges();
            }
        }

        public Telefone Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.TelefoneRepositorio.Get(id);
            }
        }

        public IEnumerable<Telefone> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.TelefoneRepositorio.GetAll();
            }
        }

        public IEnumerable<Telefone> GetByPessoa(int idPessoa)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.TelefoneRepositorio.GetByPessoa(idPessoa);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.TelefoneRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Telefone tel)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.TelefoneRepositorio.Update(tel);
                context.SaveChanges();
            }
        }
    }
}
