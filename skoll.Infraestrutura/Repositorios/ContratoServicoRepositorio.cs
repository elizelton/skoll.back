using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContratoServicoRepositorio : RepositorioBase, IContratoServicoRepositorio
    {
        public ContratoServicoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ContratoServico contServ)
        {
            var query = "INSERT INTO public.ContratoServico(valorUnitario, quantidade, valorTotal, fk_IdServicoPrestado, fk_IdContrato) " +
                        "VALUES (@valorUnitario, @quantidade, @valorTotal, @fk_IdServicoPrestado, @fk_IdContrato)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorUnitario", contServ.valorUnitario);
            command.Parameters.AddWithValue("@quantidade", contServ.quantidade);
            command.Parameters.AddWithValue("@valorTotal", contServ.valorTotal);
            command.Parameters.AddWithValue("@fk_IdServicoPrestado", contServ.servicoPrestado.Id);
            command.Parameters.AddWithValue("@fk_IdContrato", contServ.idContrato);

            command.ExecuteNonQuery();
        }

        public ContratoServico Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ContratoServico WHERE idContratoServicoPrestado = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new ContratoServico
                    {
                        Id = Convert.ToInt32(reader["idContratoServicoPrestado"]),
                        valorUnitario = Convert.ToDecimal(reader["valorUnitario"]),
                        quantidade = Convert.ToInt32(reader["quantidade"]),
                        valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                        idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                        servicoPrestado = new ServicoPrestadoRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdServicoPrestado"]))
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<ContratoServico> GetAll()
        {
            var result = new List<ContratoServico>();

            var command = CreateCommand("SELECT * FROM public.ContratoServico");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoServico
                        {
                            Id = Convert.ToInt32(reader["idContratoServicoPrestado"]),
                            valorUnitario = Convert.ToDecimal(reader["valorUnitario"]),
                            quantidade = Convert.ToInt32(reader["quantidade"]),
                            valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            servicoPrestado = new ServicoPrestadoRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdServicoPrestado"]))
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

        public IEnumerable<ContratoServico> GetByContrato(int idContPag)
        {
            var result = new List<ContratoServico>();

            var command = CreateCommand("SELECT * FROM public.ContratoServico where fk_idContrato = @id");
            command.Parameters.AddWithValue("@id", idContPag);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ContratoServico
                        {
                            Id = Convert.ToInt32(reader["idContratoServicoPrestado"]),
                            valorUnitario = Convert.ToDecimal(reader["valorUnitario"]),
                            quantidade = Convert.ToInt32(reader["quantidade"]),
                            valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                            idContrato = Convert.ToInt32(reader["fk_IdContrato"]),
                            servicoPrestado = new ServicoPrestadoRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdServicoPrestado"]))
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
            var command = CreateCommand("DELETE FROM ContratoServico WHERE idContratoServicoPrestado = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ContratoServico contServ)
        {
            var query = "UPDATE public.ContratoServico SET valorUnitario = @valorUnitario, quantidade = @quantidade, valorTotal = @valorTotal, " +
                        "fk_IdServicoPrestado = @fk_IdServicoPrestado, fk_IdContrato = @fk_IdContrato WHERE idContratoServicoPrestado = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@valorUnitario", contServ.valorUnitario);
            command.Parameters.AddWithValue("@quantidade", contServ.quantidade);
            command.Parameters.AddWithValue("@valorTotal", contServ.valorTotal);
            command.Parameters.AddWithValue("@fk_IdServicoPrestado", contServ.servicoPrestado.Id);
            command.Parameters.AddWithValue("@fk_IdContrato", contServ.idContrato);
            command.Parameters.AddWithValue("@id", contServ.Id);

            command.ExecuteNonQuery();
        }
    }
}
