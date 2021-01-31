using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContaPagarRepositorio : RepositorioBase, IContaPagarRepositorio
    {
        public ContaPagarRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContaPagar contaPagar)
        {
            var query = "INSERT INTO public.ContaPagar(valorTotal, valorMensal, mesInicial, diaInicial, diasPagamento, numParcelas, juros, ajuste, fk_IdFornecedor, fk_IdPessoa) " +
                "VALUES (@valorTotal, @valorMensal, @mesInicial, @diaInicial, @diasPagamento, @numParcelas, @juros, @ajuste, @fk_IdFornecedor, @fk_IdPessoa)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorTotal", contaPagar.valorTotal);
            command.Parameters.AddWithValue("@valorMensal", contaPagar.valorMensal);
            command.Parameters.AddWithValue("@mesInicial", contaPagar.mesInicial);
            command.Parameters.AddWithValue("@diaInicial", contaPagar.diaInicial);
            command.Parameters.AddWithValue("@diasPagamento", contaPagar.diasPagamento);
            command.Parameters.AddWithValue("@numParcelas", contaPagar.numParcelas);
            command.Parameters.AddWithValue("@juros", contaPagar.juros);
            command.Parameters.AddWithValue("@ajuste", contaPagar.ajuste);
            command.Parameters.AddWithValue("@fk_IdFornecedor", contaPagar.fornecedor.idFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", contaPagar.fornecedor.Id);

            command.ExecuteNonQuery();

            query = "select currval('contapagar_idcontapagar_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contaPagar.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento)
        {
            if (idConta == 0)
                throw new InvalidOperationException("É necessário informar o ID da Conta");
            else if (valorDif == 0)
                throw new InvalidOperationException("É necessário informar o valor de ajuste para a Conta");

            var query = "select PARCELAAJUSTECONTA(@valor, @idConta, @venc) ";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valor", valorDif);
            command.Parameters.AddWithValue("@idConta", idConta);
            command.Parameters.AddWithValue("@venc", vencimento);

            command.ExecuteNonQuery();
        }

        public void GerarParcelas(ContaPagar contaPagar)
        {
            if (contaPagar.valorTotal == 0 && contaPagar.valorMensal == 0)
                throw new InvalidOperationException("É necessário informar o Valor Total ou Mensal para a Conta");
            else if (contaPagar.valorTotal > 0 && contaPagar.valorMensal > 0)
                throw new InvalidOperationException("Não é possível informar o Valor Total e Mensal para a Conta");
            else if (contaPagar.mesInicial <= 0 || contaPagar.mesInicial > 12)
                throw new InvalidOperationException("O Mês Inicial da Conta deve ser informado");
            else if (contaPagar.numParcelas <= 0)
                throw new InvalidOperationException("O número de parcelas da Conta deve ser informado");

            List<ContaPagarParcela> parcelas = new List<ContaPagarParcela>();
            var ano = (contaPagar.mesInicial < DateTime.Now.Month && (DateTime.Now.Month == 12 && (contaPagar.mesInicial == 1 || contaPagar.mesInicial == 2))) ? DateTime.Now.Year + 1 : DateTime.Now.Year;
            var diasParc = contaPagar.diasPagamento.Split(',');

            if (contaPagar.valorMensal > 0 && !string.IsNullOrEmpty(contaPagar.diasPagamento))
            {
                if (diasParc.Length != contaPagar.numParcelas)
                    throw new InvalidOperationException("Dias de Pagamento não conferem com o número de parcelas");
            }

            for (int i = 0; i < contaPagar.numParcelas; i++)
            {
                ContaPagarParcela contaPagarParcela = new ContaPagarParcela();
                decimal valorParc = 0;
                DateTime data = new DateTime();
                if (contaPagar.valorTotal > 0)
                {
                    data = Convert.ToDateTime(contaPagar.diaInicial + "/" + contaPagar.mesInicial + "/" + ano.ToString()).AddMonths(i);
                    valorParc = contaPagar.valorTotal / contaPagar.numParcelas;
                }
                else if (contaPagar.valorMensal > 0 && !string.IsNullOrEmpty(contaPagar.diasPagamento))
                {
                    valorParc = contaPagar.valorMensal / contaPagar.numParcelas;
                    data = Convert.ToDateTime(diasParc[i].ToString().Trim() + "/" + contaPagar.mesInicial + "/" + ano.ToString());
                }
                else if (contaPagar.valorMensal > 0)
                {
                    valorParc = contaPagar.valorMensal;
                    data = Convert.ToDateTime(contaPagar.diaInicial + "/" + contaPagar.mesInicial + "/" + ano.ToString()).AddMonths(i);
                }

                contaPagarParcela.idContaPagar = contaPagar.Id;
                contaPagarParcela.numParcela = i + 1;
                contaPagarParcela.valorParcela = valorParc;
                contaPagarParcela.dataVencimento = data;
                parcelas.Add(contaPagarParcela);
            }


            foreach (var parc in parcelas)
            {
                new ContaPagarParcelaRepositorio(this._context, this._transaction).Create(parc);
            }
        }

        public ContaPagar Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContaPagar WHERE idContaPagar = @id");
            command.Parameters.AddWithValue("@id", id);
            ContaPagar conta = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    conta = new ContaPagar
                    {
                        Id = Convert.ToInt32(reader["idContaPagar"]),
                        valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                        valorMensal = Convert.ToDecimal(reader["valorMensal"]),
                        mesInicial = Convert.ToInt32(reader["mesInicial"]),
                        diaInicial = Convert.ToInt32(reader["diaInicial"]),
                        diasPagamento = reader["diasPagamento"].ToString(),
                        numParcelas = Convert.ToInt32(reader["numParcelas"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        ajuste = Convert.ToDecimal(reader["ajuste"]),
                        fornecedor = new Fornecedor() { idFornecedor = Convert.ToInt32(reader["fk_IdFornecedor"]) }
                    };
                }
                else
                {
                    return null;
                }
            }

            conta.fornecedor = new FornecedorRepositorio(this._context, this._transaction).Get(conta.fornecedor.idFornecedor);
            conta.parcelas = (List<ContaPagarParcela>)new ContaPagarParcelaRepositorio(this._context, this._transaction).GetByContaPagar(conta.Id);

            return conta;
        }

        public IEnumerable<ContaPagar> GetAll()
        {
            var result = new List<ContaPagar>();

            var command = CreateCommand("SELECT * FROM public.ContaPagar");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagar
                        {
                            Id = Convert.ToInt32(reader["idContaPagar"]),
                            valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                            valorMensal = Convert.ToDecimal(reader["valorMensal"]),
                            mesInicial = Convert.ToInt32(reader["mesInicial"]),
                            diaInicial = Convert.ToInt32(reader["diaInicial"]),
                            diasPagamento = reader["diasPagamento"].ToString(),
                            numParcelas = Convert.ToInt32(reader["numParcelas"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            fornecedor = new Fornecedor() { idFornecedor = Convert.ToInt32(reader["fk_IdFornecedor"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var conta in result)
            {
                conta.fornecedor = new FornecedorRepositorio(this._context, this._transaction).Get(conta.fornecedor.idFornecedor);
                conta.parcelas = (List<ContaPagarParcela>)new ContaPagarParcelaRepositorio(this._context, this._transaction).GetByContaPagar(conta.Id);
            }

            return result;
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM ContaPagar WHERE idContaPagar = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContaPagar contaPagar)
        {
            var query = "UPDATE public.ContaPagar SET valorTotal = @valorTotal, valorMensal = @valorMensal, mesInicial = @mesInicial, diaInicial = @diaInicial, " +
                        "diasPagamento = @diasPagamento, numParcelas = @numParcelas, juros = @juros, ajuste = @ajuste, " +
                        "fk_IdFornecedor = @fk_IdFornecedor, fk_IdPessoa = @fk_IdPessoa WHERE idContaPagar = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorTotal", contaPagar.valorTotal);
            command.Parameters.AddWithValue("@valorMensal", contaPagar.valorMensal);
            command.Parameters.AddWithValue("@mesInicial", contaPagar.mesInicial);
            command.Parameters.AddWithValue("@diaInicial", contaPagar.diaInicial);
            command.Parameters.AddWithValue("@diasPagamento", contaPagar.diasPagamento);
            command.Parameters.AddWithValue("@numParcelas", contaPagar.numParcelas);
            command.Parameters.AddWithValue("@juros", contaPagar.juros);
            command.Parameters.AddWithValue("@ajuste", contaPagar.ajuste);
            command.Parameters.AddWithValue("@fk_IdFornecedor", contaPagar.fornecedor.idFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", contaPagar.fornecedor.Id);
            command.Parameters.AddWithValue("@id", contaPagar.Id);

            command.ExecuteNonQuery();
        }
    }
}
