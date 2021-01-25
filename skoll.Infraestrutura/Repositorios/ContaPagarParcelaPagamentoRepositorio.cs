using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContaPagarParcelaPagamentoRepositorio : RepositorioBase, IContaPagarParcelaPagamentoRepositorio
    {
        public ContaPagarParcelaPagamentoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContaPagarParcelaPagamento contPgParcPag)
        {
            var query = "INSERT INTO public.ContaPagarParcelaPagamento(dataPagamento, valorPagamento, juros, fk_IdContaPagarParcela) VALUES (@dataPagamento, @valorPagamento, @juros, @fk_IdContaPagarParcela)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataPagamento", contPgParcPag.dataPagamento);
            command.Parameters.AddWithValue("@valorPagamento", contPgParcPag.valorPagamento);
            command.Parameters.AddWithValue("@juros", contPgParcPag.juros);
            command.Parameters.AddWithValue("@fk_IdContaPagarParcela", contPgParcPag.idContaPagarParcela);

            command.ExecuteNonQuery();


            query = "select currval('contapagarparcelapagamento_idcontapagarparcelapgto_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contPgParcPag.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public ContaPagarParcelaPagamento Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContaPagarParcelaPagamento WHERE idContaPagarParcelaPgto = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new ContaPagarParcelaPagamento
                    {
                        Id = Convert.ToInt32(reader["idContaPagarParcelaPgto"]),
                        dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                        valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        idContaPagarParcela = Convert.ToInt32(reader["fk_IdContaPagarParcela"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<ContaPagarParcelaPagamento> GetAll()
        {
            var result = new List<ContaPagarParcelaPagamento>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcelaPagamento");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcelaPagamento
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcelaPgto"]),
                            dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                            valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            idContaPagarParcela = Convert.ToInt32(reader["fk_IdContaPagarParcela"])
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

        public IEnumerable<ContaPagarParcelaPagamento> GetByContaPagarParcela(int idContPgParc)
        {
            var result = new List<ContaPagarParcelaPagamento>();
            var command = CreateCommand("SELECT * FROM public.ContaPagarParcelaPagamento where fk_IdContaPagarParcela = @id");
            command.Parameters.AddWithValue("@id", idContPgParc);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcelaPagamento
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcelaPgto"]),
                            dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                            valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            idContaPagarParcela = Convert.ToInt32(reader["fk_IdContaPagarParcela"])
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
            var command = CreateCommand("DELETE FROM ContaPagarParcelaPagamento WHERE idContaPagarParcelaPgto = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContaPagarParcelaPagamento contPgParcPag)
        {
            var query = "UPDATE public.ContaPagarParcelaPagamento SET dataPagamento = @dataPagamento, valorPagamento = @valorPagamento, " +
                        "juros = @juros, fk_IdContaPagarParcela = @fk_IdContaPagarParcela WHERE idContaPagarParcelaPgto = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataPagamento", contPgParcPag.dataPagamento);
            command.Parameters.AddWithValue("@valorPagamento", contPgParcPag.valorPagamento);
            command.Parameters.AddWithValue("@juros", contPgParcPag.juros);
            command.Parameters.AddWithValue("@fk_IdContaPagarParcela", contPgParcPag.idContaPagarParcela);
            command.Parameters.AddWithValue("@id", contPgParcPag.Id);

            command.ExecuteNonQuery();
        }
    }
}
