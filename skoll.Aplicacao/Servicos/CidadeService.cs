
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class CidadeService : ICidadeService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public CidadeService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public void Create(Cidade cidade)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.CidadeRepositorio.Create(cidade);
                context.SaveChanges();
            }
        }

        public Cidade Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.CidadeRepositorio.Get(id);
            }
        }

        public IEnumerable<Cidade> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.CidadeRepositorio.GetAll();
            }
        }

        public IEnumerable<Cidade> GetByEstado(string estado)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.CidadeRepositorio.GetByEstado(estado);
            }
        }

        public IEnumerable<Cidade> GetByNome(string nome)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.CidadeRepositorio.GetByNome(nome);
            }
        }

        public Cidade GetByNomeEstado(string nome, string estado)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.CidadeRepositorio.GetByNomeEstado(nome, estado);
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.CidadeRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Cidade cidade)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.CidadeRepositorio.Update(cidade);
                context.SaveChanges();
            }
        }
    }
}
