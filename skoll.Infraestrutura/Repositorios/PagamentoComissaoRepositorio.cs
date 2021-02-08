using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class PagamentoComissaoRepositorio : RepositorioBase, IPagamentoComissaoRepositorio
    {
        public PagamentoComissaoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public List<PagamentoComissao> ComissoesPagar(int idVendedor, DateTime inicio, DateTime fim, int filtroPag)
        {
            throw new NotImplementedException();
        }

        public void PagarComissao(int idVendedor, List<int> contratos, int filtroPag)
        {
            throw new NotImplementedException();
        }
    }        
}
