
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

        public RelParcelaVencer RelParcelasVencer(DateTime dataAte)
        {
            var rpt = new RelParcelaVencer();
            rpt.InicializaVariaveis();
            rpt.PageTitle = $"Relatório de Parcelas a Receber até {DateTime.Parse(dataAte.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")}";

            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelParcelasVencer(dataAte);
            }

            return rpt;
        }

        public RelContratoCliente RelContratosPorCliente(int idCliente, DateTime inicio, DateTime fim)
        {
            var rpt = new RelContratoCliente();
            rpt.InicializaVariaveis();            

            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelContratosPorCliente(idCliente, inicio, fim);
            }

            rpt.PageTitle = $"Relatório de Contratos do Cliente {rpt.list.FirstOrDefault().clienteContrato} de {DateTime.Parse(inicio.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")} " +
                $" até {DateTime.Parse(fim.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")}  "; 
            return rpt;
        }

        public RelContratoVendedor RelContratosPorVendedor(int idVendedor, DateTime inicio, DateTime fim)
        {
            var rpt = new RelContratoVendedor();
            rpt.InicializaVariaveis();            

            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelContratosPorVendedor(idVendedor, inicio, fim);
            }

            rpt.PageTitle = $"Relatório de Contratos do Vendedor {rpt.list.FirstOrDefault().vendedor} de {DateTime.Parse(inicio.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")} " +
                $" até {DateTime.Parse(fim.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")}  ";

            return rpt;
        }

        public RelContratoMes RelContratosMes(int mes, int ano)
        {
            var rpt = new RelContratoMes();
            rpt.InicializaVariaveis();
            rpt.PageTitle = $"Relatório de Contratos vendidos em {mes.ToString().PadLeft(2, '0')}/{ ano}";

            using (var context = _unitOfWork.Create())
            {
                rpt.list = context.Repositorios.RelatorioRepositorio.RelVendasMensais(mes, ano);
            }

            return rpt;
        }

        public ReciboParcelaImp ReciboImpParcela(int idParcela, decimal valor, string valorExtenso, bool imprimirObs)
        {
            var rpt = new ReciboParcelaImp();
            rpt.InicializaVariaveis();
            rpt.PageTitle = "Recibo";

            using (var context = _unitOfWork.Create())
            {
                var parc = context.Repositorios.ContratoParcelaRepositorio.Get(idParcela);

                if (parc == null)
                    throw new AppError("Não foi possível gerar o recibo - parcela inexistente");

                var numParcela = parc.numParcela;
                var contrato = context.Repositorios.ContratoRepositorio.Get(parc.idContrato);
                contrato.servicos = context.Repositorios.ContratoServicoRepositorio.GetByContrato(contrato.Id).ToList();
                contrato.parcelas = context.Repositorios.ContratoParcelaRepositorio.GetByContrato(contrato.Id).ToList();

                rpt.recibo = context.Repositorios.ContratoParcelaRepositorio.ImprimirRecibo(contrato, numParcela, valor, valorExtenso, imprimirObs);
            }

            return rpt;
        }
    }
}
