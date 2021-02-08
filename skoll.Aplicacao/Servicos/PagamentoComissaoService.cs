
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class PagamentoComissaoService : IPagamentoComissaoService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public PagamentoComissaoService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public List<PagamentoComissao> ComissoesPagar(int idVendedor, DateTime inicio, DateTime fim, int filtroPag)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.PagamentoComissaoRepositorio.ComissoesPagar(idVendedor, inicio, fim, filtroPag);
            }
        }

        public void PagarComissao(int idVendedor, List<int> contratos, int filtroPag)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.PagamentoComissaoRepositorio.PagarComissao(idVendedor, contratos, filtroPag);
                context.SaveChanges();
            }
        }
    }
}
