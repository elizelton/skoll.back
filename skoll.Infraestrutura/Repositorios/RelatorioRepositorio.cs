using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class RelatorioRepositorio : RepositorioBase, IRelatorioRepositorio
    {
        public RelatorioRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public List<Cidade> RelCidadesEstado(string estado)
        {
            var result = new List<Cidade>();
            var command = CreateCommand("SELECT * FROM public.Cidades where estado = @estado ");
            command.Parameters.AddWithValue("@estado", estado);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Cidade
                        {
                            Id = Convert.ToInt32(reader["idCidade"]),
                            cidade = reader["cidade"].ToString(),
                            estado = reader["estado"].ToString()
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

        public List<RelComissaoVendedor> RelComissaoPagaVendedor(int idVendedor, DateTime inicio, DateTime fim)
        {
            throw new NotImplementedException();
        }

        public List<RelContrato> RelContratosPorCliente(int idCliente, DateTime inicio, DateTime fim)
        {
            var result = new List<RelContrato>();
            var command = CreateCommand("select t1.nome as nomePes, t2.datainicio, t3.nome as nomeVen, t2.numparcelas, " +
                                        "t2.valortotal, t4.nome as forma, case when t2.ativo then 'ATIVO' else 'INATIVO' END as status " +
                                        "from pessoa t1 inner join contrato t2 on t2.fk_idpessoa = t1.idpessoa " +
                                        "inner join vendedor t3 on t3.idvendedor = t2.fk_idvendedor " +
                                        "inner join formapagamento t4 on t4.idformapag = t2.fk_idformapag " +
                                        "inner join cliente t5 on t5.fk_idpessoa = t1.idpessoa " +
                                        "where t5.idcliente = @cli and t2.datainicio >= @ini " +
                                        "and t2.datatermino <= @term order by t2.datainicio ");
            command.Parameters.AddWithValue("@cli", idCliente);
            command.Parameters.AddWithValue("@ini", inicio);
            command.Parameters.AddWithValue("@term", fim);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new RelContrato
                        {
                            clienteContrato = reader["nomePes"].ToString(),
                            vendedor = reader["nomeVen"].ToString(),
                            formaPagamento = reader["forma"].ToString(),
                            valorTotal = Convert.ToDecimal(reader["valortotal"]),
                            status = Convert.ToString(reader["status"]),
                            numParcelas = Convert.ToInt32(reader["numparcelas"]),
                            inicio = DateTime.Parse(reader["datainicio"].ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")
                        });
                    }
                }
                reader.Close();
            }

            return result;
        }

        public List<RelContrato> RelContratosPorVendedor(int idVendedor, DateTime inicio, DateTime fim)
        {
            var result = new List<RelContrato>();
            var command = CreateCommand("select t1.nome as nomePes, t2.datainicio, t3.nome as nomeVen, t2.numparcelas, " +
                                        "t2.valortotal, t4.nome as forma, case when t2.ativo then 'ATIVO' else 'INATIVO' END as status " +
                                        "from pessoa t1 inner join contrato t2 on t2.fk_idpessoa = t1.idpessoa " +
                                        "inner join vendedor t3 on t3.idvendedor = t2.fk_idvendedor " +
                                        "inner join formapagamento t4 on t4.idformapag = t2.fk_idformapag " +
                                        "inner join cliente t5 on t5.fk_idpessoa = t1.idpessoa " +
                                        "where t3.idvendedor = @vend and t2.datainicio >= @ini " +
                                        "and t2.datatermino <= @term order by t2.datainicio ");
            command.Parameters.AddWithValue("@vend", idVendedor);
            command.Parameters.AddWithValue("@ini", inicio);
            command.Parameters.AddWithValue("@term", fim);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new RelContrato
                        {
                            clienteContrato = reader["nomePes"].ToString(),
                            vendedor = reader["nomeVen"].ToString(),
                            formaPagamento = reader["forma"].ToString(),
                            valorTotal = Convert.ToDecimal(reader["valortotal"]),
                            status = Convert.ToString(reader["status"]),
                            numParcelas = Convert.ToInt32(reader["numparcelas"]),
                            inicio = DateTime.Parse(reader["datainicio"].ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")
                        });
                    }
                }
                reader.Close();
            }

            return result;
        }

        public List<RelEntradaSaida> RelEntradaSaida(DateTime inicio, DateTime fim)
        {
            throw new NotImplementedException();
        }

        public List<RelParcelasPagar> RelParcelasPagar(DateTime dataAte)
        {
            var result = new List<RelParcelasPagar>();
            var command = CreateCommand("Select t1.Nome, t2.valorParcela, t2.numParcela, COALESCE(sum(t3.valorPagamento),0) as pago, t2.dataVencimento " +
                                        "from Pessoa t1 inner join contapagar c on c.fk_idPessoa = t1.idPessoa " +
                                        "inner join contapagarparcela t2 on t2.fk_idContaPagar = c.idContaPagar " +
                                        "left join contapagarparcelapagamento t3 on t3.fk_idcontapagarparcela = t2.idcontapagarparcela " +
                                        "where t2.datavencimento <= @data " +
                                        "and t2.valorParcela <> (select COALESCE(sum(t4.valorPagamento),0) from contapagarparcelapagamento t4 where t4.fk_idcontapagarparcela = t2.idContaPagarParcela) " +
                                        "GROUP BY t1.Nome,t2.numParcela,t2.dataVencimento,t2.valorParcela " +
                                        "Order by t2.datavencimento ");
            command.Parameters.AddWithValue("@data", dataAte);


            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new RelParcelasPagar
                        {
                            fornecedorConta = reader["nome"].ToString(),
                            valorPagar = Convert.ToDecimal(reader["valorparcela"]),
                            valorPago = Convert.ToDecimal(reader["pago"]),
                            numParcela = Convert.ToInt32(reader["numparcela"]),
                            dataVencimento = DateTime.Parse(reader["datavencimento"].ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")
                        });
                    }

                }
                reader.Close();
            }

            return result;
        }

        public List<RelParcelasVencer> RelParcelasVencer(DateTime dataAte)
        {
            var result = new List<RelParcelasVencer>();
            var command = CreateCommand("select t3.nome, t1.datavencimento, t1.valorparcela, t1.numparcela, COALESCE(sum(t4.valorPagamento),0) as pago " +
                                        "from contratoparcela t1 inner join contrato t2 on t1.fk_idcontrato = t2.idcontrato " +
                                        "inner join pessoa t3 on t2.fk_idpessoa = t3.idpessoa " +
                                        "left join contratoparcelapagamento t4 on t4.fk_idcontratoparcela = t1.idcontratoparcela " +
                                        "where t1.datavencimento <= @data and t1.situacao <> 3 " +
                                        "GROUP BY t3.Nome,t1.numParcela,t1.dataVencimento,t1.valorParcela " +
                                        "Order by t1.datavencimento ");
            command.Parameters.AddWithValue("@data", dataAte);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new RelParcelasVencer
                        {
                            clienteContrato = reader["nome"].ToString(),
                            dataVencimento = DateTime.Parse(reader["datavencimento"].ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy"),
                            valorPagar = Convert.ToDecimal(reader["valorparcela"]),
                            numParcela = Convert.ToInt32(reader["numparcela"]),
                            valorPago = Convert.ToDecimal(reader["pago"])
                        }); ;
                    }

                }
                reader.Close();
            }

            return result;
        }

        public List<RelContrato> RelVendasMensais(int mes , int ano)
        {
            var result = new List<RelContrato>();
            var command = CreateCommand("select t1.nome as nomePes, t2.datainicio, t3.nome as nomeVen, t2.numparcelas, " +
                                        "t2.valortotal, t4.nome as forma, case when t2.ativo then 'ATIVO' else 'INATIVO' END as status " +
                                        "from pessoa t1 inner join contrato t2 on t2.fk_idpessoa = t1.idpessoa " +
                                        "inner join vendedor t3 on t3.idvendedor = t2.fk_idvendedor " +
                                        "inner join formapagamento t4 on t4.idformapag = t2.fk_idformapag " +
                                        "inner join cliente t5 on t5.fk_idpessoa = t1.idpessoa " +
                                        "where extract (month from t2.datainicio) = @mes " +
                                        "and extract (year from t2.datainicio) = @ano " +
                                        "order by t2.datainicio ");
            command.Parameters.AddWithValue("@mes", mes);
            command.Parameters.AddWithValue("@ano", ano);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new RelContrato
                        {
                            clienteContrato = reader["nomePes"].ToString(),
                            vendedor = reader["nomeVen"].ToString(),
                            formaPagamento = reader["forma"].ToString(),
                            valorTotal = Convert.ToDecimal(reader["valortotal"]),
                            status = Convert.ToString(reader["status"]),
                            numParcelas = Convert.ToInt32(reader["numparcelas"]),
                            inicio = DateTime.Parse(reader["datainicio"].ToString(), new CultureInfo("pt-BR")).ToString("dd/MM/yyyy")
                        });
                    }
                }
                reader.Close();
            }

            return result;
        }
    }
}
