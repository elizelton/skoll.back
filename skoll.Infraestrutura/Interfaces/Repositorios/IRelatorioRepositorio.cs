using Npgsql;
using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IRelatorioRepositorio
    {
        List<Cidade> RelCidadesEstado(string estado);

        List<RelContrato> RelContratosPorCliente(int idCliente, DateTime inicio, DateTime fim);

        List<RelContrato> RelContratosPorVendedor(int idCliente, DateTime inicio, DateTime fim);

        List<RelComissaoVendedor> RelComissaoPagaVendedor(int idVendedor, DateTime inicio, DateTime fim);

        List<RelParcelasVencer> RelParcelasVencer(DateTime dataAte);

        List<RelParcelasPagar> RelParcelasPagar(DateTime dataAte);

        List<RelPagamentoParcela> RelPagamentosParc(DateTime inicio, DateTime fim);

        List<RelContrato> RelVendasMensais(int mes, int ano);
    }
}
