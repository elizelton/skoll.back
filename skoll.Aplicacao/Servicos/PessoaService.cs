
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class PessoaService : IPessoaService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public PessoaService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Pessoa pessoa)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.PessoaRepositorio.Create(pessoa);
                context.SaveChanges();
            }
        }

        public Pessoa Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.PessoaRepositorio.Get(id);
            }
        }

        public IEnumerable<Pessoa> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.PessoaRepositorio.GetAll();
            }
        }

        public IEnumerable<Pessoa> GetByNomeLike(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.PessoaRepositorio.GetByNomeLike(nome);
            }
        }

        public Pessoa GetByCpfCnpj(string cpfCnpj)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.PessoaRepositorio.GetByCpfCnpj(cpfCnpj);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.PessoaRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Pessoa pessoa)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.PessoaRepositorio.Update(pessoa);
                context.SaveChanges();
            }
        }
    }
}
