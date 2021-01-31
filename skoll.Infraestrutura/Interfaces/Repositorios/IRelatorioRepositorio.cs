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

        List<RelComissaoVendedor> RelComissaoMensalVendedor(int idVendedor, DateTime inicio, DateTime fim, bool porRecebimento);

        List<RelParcelasVencer> RelParcelasVencer(DateTime dataAte);

        List<RelParcelasPagar> RelParcelasPagar(DateTime dataAte);

        List<RelEntradaSaida> RelEntradaSaida(DateTime inicio, DateTime fim);

        List<RelContrato> RelVendasMensais(int mes);
    }
}
