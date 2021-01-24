using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace skoll.Aplicacao.Common.Interfaces
{
    public interface IUnitOfWork
    {
        IRepositorio<Usuario> UsuarioRepositorio { get; }
        IRepositorio<Cidade> CidadeRepositorio { get; }
        IRepositorio<Cliente> ClienteRepositorio { get; }
        IRepositorio<ContaPagarParcelaPagamento> ContaPagarParcelaPagamentoRepositorio { get; }
        IRepositorio<ContaPagarParcela> ContaPagarParcelaRepositorio { get; }
        IRepositorio<ContaPagar> ContaPagarRepositorio { get; }
        IRepositorio<ContratoParcelaPagamento> ContratoParcelaPagamentoRepositorio { get; }
        IRepositorio<ContratoParcela> ContratoParcelaRepositorio { get; }
        IRepositorio<Contrato> ContratoRepositorio { get; }
        IRepositorio<ContratoServico> ContratoServicoRepositorio { get; }
        IRepositorio<FormaPagamento> FormaPagamentoRepositorio { get; }
        IRepositorio<Fornecedor> FornecedorRepositorio { get; }
        IRepositorio<Pessoa> PessoaRepositorio { get; }
        IRepositorio<Produto> ProdutoRepositorio { get; }
        IRepositorio<ServicoPrestado> ServicoPrestadoRepositorio { get; }
        IRepositorio<Telefone> TelefoneRepositorio { get; }
        IRepositorio<Vendedor> VendedorRepositorio { get; }

        void Commit();
        void RollBack();
    }
}
