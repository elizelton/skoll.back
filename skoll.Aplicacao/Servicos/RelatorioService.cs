
using skoll.Aplicacao.Interfaces;
using skoll.Aplicacao.Relatorios;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using static skoll.Aplicacao.Util.StringUtil;
namespace skoll.Aplicacao.Servicos
{
    public class RelatorioService : IRelatorioService
    {
        private IUnitOfWorkFactory _unitOfWork;

        public RelatorioService(IUnitOfWorkFactory unitOfWorkFactory)
        {
            _unitOfWork = unitOfWorkFactory;
        }

        public RelCidadesEstado RelCidadesEstado(string estado)
        {
            var rpt = new RelCidadesEstado();
            rpt.InicializaVariaveis();
            rpt.PageTitle = $"Relatório de Cidades do Estado de {estado}";
                        
            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelCidadesEstado(estado);
            }

            return rpt;
        }

        public RelParcelaPagar RelParcelasPagar(DateTime dataAte)
        {
            var rpt = new RelParcelaPagar();
            rpt.InicializaVariaveis();
            rpt.PageTitle = $"Relatório de Parcelas a Pagar até {DateTime.Parse(dataAte.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")}";

            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelParcelasPagar(dataAte);
            }

            return rpt;
        }
    }
}
