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

        public List<RelComissaoVendedor> RelComissaoMensalVendedor(int idVendedor, DateTime inicio, DateTime fim, bool porRecebimento)
        {
            throw new NotImplementedException();
        }

        public List<RelContrato> RelContratosPorCliente(int idCliente, DateTime inicio, DateTime fim)
        {
            throw new NotImplementedException();
        }

        public List<RelContrato> RelContratosPorVendedor(int idCliente, DateTime inicio, DateTime fim)
        {
            throw new NotImplementedException();
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
                                        "GROUP BY t1.Nome,t2.valorParcela,t2.numParcela,t2.dataVencimento ");
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
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            return result;
        }

        public List<RelParcelasVencer> RelParcelasVencer(DateTime dataAte)
        {
            throw new NotImplementedException();
        }

        public List<RelContrato> RelVendasMensais(int mes)
        {
            throw new NotImplementedException();
        }
    }
}
