using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContaPagarParcelaRepositorio : RepositorioBase, IContaPagarParcelaRepositorio
    {
        public ContaPagarParcelaRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContaPagarParcela contPgParc)
        {
            var query = "INSERT INTO public.ContaPagarParcela(dataVencimento, valorParcela, ajuste, numParcela, fk_IdContaPagar) VALUES (@dataVencimento, @valorParcela, @ajuste, @numParcela, @fk_IdContaPagar)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataVencimento", contPgParc.dataVencimento);
            command.Parameters.AddWithValue("@valorParcela", contPgParc.valorParcela);
            command.Parameters.AddWithValue("@ajuste", contPgParc.ajuste);
            command.Parameters.AddWithValue("@numParcela", contPgParc.numParcela);
            command.Parameters.AddWithValue("@fk_IdContaPagar", contPgParc.idContaPagar);

            command.ExecuteNonQuery();

            query = "select currval('contapagarparcela_idcontapagarparcela_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contPgParc.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public ContaPagarParcela Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela WHERE idContaPagarParcela = @id");
            command.Parameters.AddWithValue("@id", id);
            ContaPagarParcela conta = null; 

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    conta = new ContaPagarParcela
                    {
                        Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                        dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                        valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                        ajuste = Convert.ToDecimal(reader["ajuste"]),
                        numParcela = Convert.ToInt32(reader["numParcela"]),
                        idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"])
                    };
                }
                else
                {
                    return null;
                }
            }
            conta.pagamentos = (List<ContaPagarParcelaPagamento>)new ContaPagarParcelaPagamentoRepositorio(this._context, this._transaction).GetByContaPagarParcela(conta.Id);
            return conta;
        }

        public IEnumerable<ContaPagarParcela> GetAll()
        {
            var result = new List<ContaPagarParcela>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcela
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"])
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
                conta.pagamentos = (List<ContaPagarParcelaPagamento>)new ContaPagarParcelaPagamentoRepositorio(this._context, this._transaction).GetByContaPagarParcela(conta.Id);

            return result;
        }

        public IEnumerable<ContaPagarParcela> GetByContaPagar(int idContPag)
        {
            var result = new List<ContaPagarParcela>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela where fk_idContaPagar = @id");
            command.Parameters.AddWithValue("@id", idContPag);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcela
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"])
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
                conta.pagamentos = (List<ContaPagarParcelaPagamento>)new ContaPagarParcelaPagamentoRepositorio(this._context, this._transaction).GetByContaPagarParcela(conta.Id);

            return result;
        }

        public IEnumerable<ContaPagarParcela> GetByVencimentoAte(DateTime date)
        {
            var result = new List<ContaPagarParcela>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela where dataVencimento <= @date");
            command.Parameters.AddWithValue("@date", date);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcela
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"])
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
                conta.pagamentos = (List<ContaPagarParcelaPagamento>)new ContaPagarParcelaPagamentoRepositorio(this._context, this._transaction).GetByContaPagarParcela(conta.Id);

            return result;
        }

        public IEnumerable<ContaPagarParcela> GetNaoPagasTotalmente()
        {
            var result = new List<ContaPagarParcela>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela where valorParcela < (select sum(valorPagamento) from ContaPagarParcelaPagamento where fk_idContaPagarParcela = idContaPagarParcela) ");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcela
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"])
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
                conta.pagamentos = (List<ContaPagarParcelaPagamento>)new ContaPagarParcelaPagamentoRepositorio(this._context, this._transaction).GetByContaPagarParcela(conta.Id);

            return result;
        }

        public IEnumerable<ContaPagarParcela> GetPendentes()
        {
            var result = new List<ContaPagarParcela>();

            var command = CreateCommand("SELECT * FROM public.ContaPagarParcela where not exists (select 1 from ContaPagarParcelaPagamento where fk_idContaPagarParcela = idContaPagarParcela) ");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContaPagarParcela
                        {
                            Id = Convert.ToInt32(reader["idContaPagarParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContaPagar = Convert.ToInt32(reader["fk_IdContaPagar"]),
                            pagamentos = new List<ContaPagarParcelaPagamento>()
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
            var command = CreateCommand("DELETE FROM ContaPagarParcela WHERE idContaPagarParcela = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContaPagarParcela contPgParc)
        {
            var query = "UPDATE public.ContaPagarParcela SET dataVencimento = @dataVencimento, valorParcela = @valorParcela, " +
                        "numParcela = @numParcela, ajuste = @ajuste, fk_IdContaPagar = @fk_IdContaPagar WHERE idContaPagarParcela = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@dataVencimento", contPgParc.dataVencimento);
            command.Parameters.AddWithValue("@valorParcela", contPgParc.valorParcela);
            command.Parameters.AddWithValue("@numParcela", contPgParc.numParcela);
            command.Parameters.AddWithValue("@ajuste", contPgParc.ajuste);
            command.Parameters.AddWithValue("@fk_IdContaPagar", contPgParc.idContaPagar);
            command.Parameters.AddWithValue("@id", contPgParc.Id);

            command.ExecuteNonQuery();
        }
    }
}
