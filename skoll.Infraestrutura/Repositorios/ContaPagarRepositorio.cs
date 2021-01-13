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
            var query = "INSERT INTO public.ContaPagar(valorTotal, mesInicial, diaInicial, diasPagamento, numParcelas, juros, fk_IdFornecedor, fk_IdPessoa) " +
                "VALUES (@valorTotal, @mesInicial, @diaInicial, @diasPagamento, @numParcelas, @juros, @fk_IdFornecedor, @fk_IdPessoa)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorTotal", contaPagar.valorTotal);
            command.Parameters.AddWithValue("@mesInicial", contaPagar.mesInicial);
            command.Parameters.AddWithValue("@diaInicial", contaPagar.diaInicial);
            command.Parameters.AddWithValue("@diasPagamento", contaPagar.diasPagamento);
            command.Parameters.AddWithValue("@numParcelas", contaPagar.numParcelas);
            command.Parameters.AddWithValue("@juros", contaPagar.juros);
            command.Parameters.AddWithValue("@fk_IdFornecedor", contaPagar.fornecedor.idFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", contaPagar.fornecedor.Id);

            command.ExecuteNonQuery();
        }

        public void GerarParcelas(ContaPagar contaPagar)
        {
            throw new NotImplementedException();
        }

        public ContaPagar Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContaPagar WHERE idContaPagar = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new ContaPagar
                    {
                        Id = Convert.ToInt32(reader["idContaPagar"]),
                        valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                        mesInicial = Convert.ToInt32(reader["mesInicial"]),
                        diaInicial = Convert.ToInt32(reader["diaInicial"]),
                        diasPagamento = Convert.ToInt32(reader["diasPagamento"]),
                        numParcelas = Convert.ToInt32(reader["numParcelas"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        fornecedor = new FornecedorRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdFornecedor"])),
                        parcelas = (List<ContaPagarParcela>)new ContaPagarParcelaRepositorio(this._context, this._transaction).GetByContaPagar(Convert.ToInt32(reader["idContaPagar"]))
                    };
                }
                else
                {
                    return null;
                }
            }
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
                            mesInicial = Convert.ToInt32(reader["mesInicial"]),
                            diaInicial = Convert.ToInt32(reader["diaInicial"]),
                            diasPagamento = Convert.ToInt32(reader["diasPagamento"]),
                            numParcelas = Convert.ToInt32(reader["numParcelas"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            fornecedor = new FornecedorRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdFornecedor"])),
                            parcelas = (List<ContaPagarParcela>)new ContaPagarParcelaRepositorio(this._context, this._transaction).GetByContaPagar(Convert.ToInt32(reader["idContaPagar"]))
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
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
            var query = "UPDATE public.ContaPagar SET valorTotal = @valorTotal, mesInicial = @mesInicial, diaInicial = @diaInicial, " +
                        "diasPagamento = @diasPagamento, numParcelas = @numParcelas, juros = @juros, " +
                        "fk_IdFornecedor = @fk_IdFornecedor, fk_IdPessoa = @fk_IdPessoa WHERE idFormaPag = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorTotal", contaPagar.valorTotal);
            command.Parameters.AddWithValue("@mesInicial", contaPagar.mesInicial);
            command.Parameters.AddWithValue("@diaInicial", contaPagar.diaInicial);
            command.Parameters.AddWithValue("@diasPagamento", contaPagar.diasPagamento);
            command.Parameters.AddWithValue("@numParcelas", contaPagar.numParcelas);
            command.Parameters.AddWithValue("@juros", contaPagar.juros);
            command.Parameters.AddWithValue("@fk_IdFornecedor", contaPagar.fornecedor.idFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", contaPagar.fornecedor.Id);
            command.Parameters.AddWithValue("@id", contaPagar.Id);

            command.ExecuteNonQuery();
        }
    }
}
