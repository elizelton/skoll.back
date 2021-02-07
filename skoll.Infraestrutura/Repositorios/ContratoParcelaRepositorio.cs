using Npgsql;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Globalization;
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

            query = "select currval('contratoparcela_idcontratoparcela_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contParc.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public ContratoParcela Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContratoParcela WHERE idContratoParcela = @id");
            command.Parameters.AddWithValue("@id", id);
            ContratoParcela contrato = null; 

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contrato = new ContratoParcela
                    {
                        Id = Convert.ToInt32(reader["idContratoParcela"]),
                        dataVencimento = Convert.ToDateTime(reader["dataVencimento"]),
                        valorParcela = Convert.ToDecimal(reader["valorParcela"]),
                        numParcela = Convert.ToInt32(reader["numParcela"]),
                        idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                        situacao = Convert.ToInt32(reader["situacao"]),
                        comissao = Convert.ToDecimal(reader["comissao"])
                    };
                }
                else
                {
                    return null;
                }
            }

            contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

            return contrato;
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
                            comissao = Convert.ToDecimal(reader["comissao"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var contrato in result)
                contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

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
                            comissao = Convert.ToDecimal(reader["comissao"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var contrato in result)
                contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

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
                            comissao = Convert.ToDecimal(reader["comissao"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var contrato in result)
                contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

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
                            comissao = Convert.ToDecimal(reader["comissao"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var contrato in result)
                contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

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
                            comissao = Convert.ToDecimal(reader["comissao"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var contrato in result)
                contrato.pagamentos = (List<ContratoParcelaPagamento>)new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(contrato.Id);

            return result;
        }

        public ReciboParcela ImprimirRecibo(Contrato contrato, int numParcela, decimal valor, string valorExtenso, bool imprimirObs)
        {
            ReciboParcela recibo = new ReciboParcela();
            var parc = contrato.parcelas.Where(e => e.numParcela == numParcela).FirstOrDefault();
            if (parc == null)
                throw new AppError("Não foi possível gerar o recibo - número de parcela inexistente");

            recibo.cliente = contrato.cliente;
            recibo.idContrato = contrato.Id;
            recibo.idParcela = parc.Id;
            recibo.servicos = contrato.servicos;
            recibo.valor = valor;
            recibo.valorExtenso = valorExtenso;
            recibo.vencimento = DateTime.Parse(parc.dataVencimento.ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy");
            if (imprimirObs)
                recibo.observacoes = contrato.observacoes;
            else
                recibo.observacoes = "FALSE";

            return recibo;
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
