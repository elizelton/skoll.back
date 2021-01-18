using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContratoParcelaRepositorio : RepositorioBase, IContratoParcelaRepositorio
    {
        public ContratoParcelaRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContratoParcela contParc)
        {
            var query = "INSERT INTO public.ContratoParcela(numParcela, valorParcela, dataVencimento, situacao, comissao, fk_IdContrato) " +
                        "VALUES (@numParcela, @valorParcela, @dataVencimento, @situacao, @comissao, @fk_IdContrato)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@numParcela", contParc.numParcela);
            command.Parameters.AddWithValue("@valorParcela", contParc.valorParcela);
            command.Parameters.AddWithValue("@dataVencimento", contParc.dataVencimento);
            command.Parameters.AddWithValue("@situacao", contParc.situacao);
            command.Parameters.AddWithValue("@comissao", contParc.comissao);
            command.Parameters.AddWithValue("@fk_IdContrato", contParc.idContrato);

            command.ExecuteNonQuery();
        }

        public ContratoParcela Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContratoParcela WHERE idContratoParcela = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new ContratoParcela
                    {
                        Id = Convert.ToInt32(reader["idContratoParcela"]),
                        dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                        valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                        numParcela = Convert.ToInt32(reader["numParcela"]),
                        idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                        situacao = Convert.ToInt32(reader["situacao"]),
                        comissao = Convert.ToDecimal(reader["comissao"]),
                        pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<ContratoParcela> GetAll()
        {
            var result = new List<ContratoParcela>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcela");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcela
                        {
                            Id = Convert.ToInt32(reader["idContratoParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            situacao = Convert.ToInt32(reader["situacao"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
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

        public IEnumerable<ContratoParcela> GetByContrato(int idContPag)
        {
            var result = new List<ContratoParcela>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcela where fk_idContrato = @id");
            command.Parameters.AddWithValue("@id", idContPag);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcela
                        {
                            Id = Convert.ToInt32(reader["idContratoParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            situacao = Convert.ToInt32(reader["situacao"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
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

        public IEnumerable<ContratoParcela> GetByVencimentoAte(DateTime date)
        {
            var result = new List<ContratoParcela>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcela where dataVencimento <= @date");
            command.Parameters.AddWithValue("@date", date);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcela
                        {
                            Id = Convert.ToInt32(reader["idContratoParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            situacao = Convert.ToInt32(reader["situacao"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
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

        public IEnumerable<ContratoParcela> GetNaoPagasTotalmente()
        {
            var result = new List<ContratoParcela>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcela where situacao <> 1");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcela
                        {
                            Id = Convert.ToInt32(reader["idContratoParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            situacao = Convert.ToInt32(reader["situacao"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
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

        public IEnumerable<ContratoParcela> GetPendentes()
        {
            var result = new List<ContratoParcela>();

            var command = CreateCommand("SELECT * FROM public.ContratoParcela where situacao = 1 ");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoParcela
                        {
                            Id = Convert.ToInt32(reader["idContratoParcela"]),
                            dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                            valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                            numParcela = Convert.ToInt32(reader["numParcela"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            situacao = Convert.ToInt32(reader["situacao"]),
                            comissao = Convert.ToDecimal(reader["comissao"]),
                            pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(Convert.ToInt32(reader["idContratoParcela"]))
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
            var command = CreateCommand("DELETE FROM ContratoParcela WHERE idContratoParcela = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContratoParcela contParc)
        {
            var query = "UPDATE public.ContratoParcela SET numParcela = @numParcela, valorParcela = @valorParcela, dataVencimento = @dataVencimento, " +
                        "situacao = @situacao, comissao = @comissao, fk_IdContrato = @fk_IdContrato WHERE idContratoParcela = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@numParcela", contParc.numParcela);
            command.Parameters.AddWithValue("@valorParcela", contParc.valorParcela);
            command.Parameters.AddWithValue("@dataVencimento", contParc.dataVencimento);
            command.Parameters.AddWithValue("@situacao", contParc.situacao);
            command.Parameters.AddWithValue("@comissao", contParc.comissao);
            command.Parameters.AddWithValue("@fk_IdContrato", contParc.idContrato);
            command.Parameters.AddWithValue("@id", contParc.Id);

            command.ExecuteNonQuery();
        }
    }
}
