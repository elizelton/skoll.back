using skoll.Infraestrutura.Interfaces.Repositorios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.UnitOfWork
{
    public interface IUnitOfWorkRepository
    {
        IUsuarioRepositorio UsuarioRepositorio { get; }
        ICidadeRepositorio CidadeRepositorio { get; }
        IClienteRepositorio ClienteRepositorio { get; }
        IContaPagarParcelaPagamentoRepositorio ContaPagarParcelaPagamentoRepositorio { get; }
        IContaPagarParcelaRepositorio ContaPagarParcelaRepositorio { get; }
        IContaPagarRepositorio ContaPagarRepositorio { get; }
        IContratoParcelaPagamentoRepositorio ContratoParcelaPagamentoRepositorio { get; }
        IContratoParcelaRepositorio ContratoParcelaRepositorio { get; }
        IContratoRepositorio ContratoRepositorio { get; }
        IContratoServicoRepositorio ContratoServicoRepositorio { get; }
        IFormaPagamentoRepositorio FormaPagamentoRepositorio { get; }
        IFornecedorRepositorio FornecedorRepositorio { get; }
        IPessoaRepositorio PessoaRepositorio { get; }
        IProdutoRepositorio ProdutoRepositorio { get; }
        IServicoPrestadoRepositorio ServicoPrestadoRepositorio { get; }
        ITelefoneRepositorio TelefoneRepositorio { get; }
        IVendedorRepositorio VendedorRepositorio { get; }
        IRelatorioRepositorio RelatorioRepositorio { get; }
        IPagamentoComissaoRepositorio PagamentoComissaoRepositorio { get; }
    }
}
