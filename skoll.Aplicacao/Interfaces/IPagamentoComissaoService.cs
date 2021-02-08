using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IPagamentoComissaoService
    {
        List<PagamentoComissao> ComissoesPagar(int idVendedor, DateTime inicio, DateTime fim, int filtroPag);

        void PagarComissao(int idVendedor, List<int> contratos, int filtroPag);

    }
}
