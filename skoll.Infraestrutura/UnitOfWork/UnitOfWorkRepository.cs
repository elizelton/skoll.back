using Npgsql;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using skoll.Infraestrutura.Repositorios;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.UnitOfWork
{
    public class UnitOfWorkRepository : IUnitOfWorkRepository
    {
        public IUsuarioRepositorio UsuarioRepositorio { get; }
        public ICidadeRepositorio CidadeRepositorio { get; }
        public IClienteRepositorio ClienteRepositorio { get; }
        public IContaPagarParcelaPagamentoRepositorio ContaPagarParcelaPagamentoRepositorio { get; }
        public IContaPagarParcelaRepositorio ContaPagarParcelaRepositorio { get; }
        public  IContaPagarRepositorio ContaPagarRepositorio { get; }
        public IContratoParcelaPagamentoRepositorio ContratoParcelaPagamentoRepositorio { get; }
        public IContratoParcelaRepositorio ContratoParcelaRepositorio { get; }
        public IContratoRepositorio ContratoRepositorio { get; }
        public IContratoServicoRepositorio ContratoServicoRepositorio { get; }
        public IFormaPagamentoRepositorio FormaPagamentoRepositorio { get; }
        public IFornecedorRepositorio FornecedorRepositorio { get; }
        public IPessoaRepositorio PessoaRepositorio { get; }
        public IProdutoRepositorio ProdutoRepositorio { get; }
        public IServicoPrestadoRepositorio ServicoPrestadoRepositorio { get; }
        public ITelefoneRepositorio TelefoneRepositorio { get; }
        public IVendedorRepositorio VendedorRepositorio { get; }
        public UnitOfWorkRepository(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            UsuarioRepositorio = new UsuarioRepositorio(context, transaction);
            CidadeRepositorio = new CidadeRepositorio(context, transaction);
            ClienteRepositorio = new ClienteRepositorio(context, transaction);
            ContaPagarParcelaPagamentoRepositorio = new ContaPagarParcelaPagamentoRepositorio(context, transaction);
            ContaPagarParcelaRepositorio = new ContaPagarParcelaRepositorio(context, transaction);
            ContaPagarRepositorio = new ContaPagarRepositorio(context, transaction);
            ContratoParcelaPagamentoRepositorio = new ContratoParcelaPagamentoRepositorio(context, transaction);
            ContratoParcelaRepositorio = new ContratoParcelaRepositorio(context, transaction);
            ContratoRepositorio = new ContratoRepositorio(context, transaction);
            ContratoServicoRepositorio = new ContratoServicoRepositorio(context, transaction);
            FormaPagamentoRepositorio = new FormaPagamentoRepositorio(context, transaction);
            FornecedorRepositorio = new FornecedorRepositorio(context, transaction);
            PessoaRepositorio = new PessoaRepositorio(context, transaction);
            ProdutoRepositorio = new ProdutoRepositorio(context, transaction);
            ServicoPrestadoRepositorio = new ServicoPrestadoRepositorio(context, transaction);
            TelefoneRepositorio = new TelefoneRepositorio(context, transaction);
            VendedorRepositorio = new VendedorRepositorio(context, transaction);
        }
    }
}
