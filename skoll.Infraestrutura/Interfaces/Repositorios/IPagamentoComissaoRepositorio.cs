using Npgsql;
using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IPagamentoComissaoRepositorio
    {
        List<PagamentoComissao> ComissoesPagar(int idVendedor, DateTime inicio, DateTime fim, int filtroPag);

        void PagarComissao(int idVendedor, List<int> contratos, int filtroPag, DateTime inicio, DateTime fim);
    }
}
