using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContratoParcelaPagamentoRepositorio : RepositorioBase, IContratoParcelaPagamentoRepositorio
    {
        public ContratoParcelaPagamentoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContratoParcelaPagamento contParcPag)
        {
            var query = "INSERT INTO public.ContratoParcelaPagamento(dataPagamento, comissao, valorPagamento, juros, fk_IdContratoParcela) VALUES (@dataPagamento, @comissao, @valorPagamento, @juros, @fk_IdContratoParcela)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataPagamento", contParcPag.dataPagamento);
            command.Parameters.AddWithValue("@comissao", contParcPag.comissao);
            command.Parameters.AddWithValue("@valorPagamento", contParcPag.valorPagamento);
            command.Parameters.AddWithValue("@juros", contParcPag.juros);
            command.Parameters.AddWithValue("@fk_IdContratoParcela", contParcPag.idContratoParcela);

            command.ExecuteNonQuery();
        }

        public ContratoParcelaPagamento Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContratoParcelaPagamento WHERE idContratoParcelaPgto = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new ContratoParcelaPagamento
                    {
                        Id = Convert.ToInt32(reader["idContratoParcelaPgto"]),
                        dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                        valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                        comissao = Convert.ToDecimal(reader["comissao"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        idContratoParcela = Convert.ToInt32(reader["fk_IdContratoParcela"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<ContratoParcelaPagamento> GetAll()
        {
            var result = new List<ContratoParcelaPagamento>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcelaPagamento");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcelaPagamento
                        {
                            Id = Convert.ToInt32(reader["idContratoParcelaPgto"]),
                            dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                            valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            idContratoParcela = Convert.ToInt32(reader["fk_IdContratoParcela"])
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

        public IEnumerable<ContratoParcelaPagamento> GetByContratoParcela(int idcontParc)
        {
            var result = new List<ContratoParcelaPagamento>();
            var command = CreateCommand("SELECT * FROM public.ContratoParcelaPagamento where fk_IdContratoParcela = @id");
            command.Parameters.AddWithValue("@id", idcontParc);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcelaPagamento
                        {
                            Id = Convert.ToInt32(reader["idContratoParcelaPgto"]),
                            dataPagamento = Convert.ToDateTime(reader["dataPagamento"]),
                            valorPagamento = Convert.ToDecimal(reader["valorPagamento"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            idContratoParcela = Convert.ToInt32(reader["fk_IdContratoParcela"])
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
            var command = CreateCommand("DELETE FROM ContratoParcelaPagamento WHERE idContratoParcelaPgto = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContratoParcelaPagamento contParcPag)
        {
            var query = "UPDATE public.ContratoParcelaPagamento SET dataPagamento = @dataPagamento, comissao = @comissao, valorPagamento = @valorPagamento, " +
                        "juros = @juros, fk_IdContratoParcela = @fk_IdContratoParcela WHERE idContratoParcelaPgto = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataPagamento", contParcPag.dataPagamento);
            command.Parameters.AddWithValue("@comissao", contParcPag.comissao);
            command.Parameters.AddWithValue("@valorPagamento", contParcPag.valorPagamento);
            command.Parameters.AddWithValue("@juros", contParcPag.juros);
            command.Parameters.AddWithValue("@fk_IdContratoParcela", contParcPag.idContratoParcela);
            command.Parameters.AddWithValue("@id", contParcPag.Id);

            command.ExecuteNonQuery();
        }
    }
}
