using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
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
            throw new NotImplementedException();
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
