using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class TelefoneRepositorio : RepositorioBase, ITelefoneRepositorio
    {
        public TelefoneRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Telefone telefone)
        {
            var query = "INSERT INTO public.Telefone(ddd, telefone, tipoTelefone, whatsApp, fk_IdPessoa)" +
                        "VALUES (@ddd, @telefone, @tipoTelefone, @whatsApp, @fk_IdPessoa)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ddd", telefone.ddd);
            command.Parameters.AddWithValue("@telefone", telefone.telefone);
            command.Parameters.AddWithValue("@tipoTelefone", telefone.tipoTelefone);
            command.Parameters.AddWithValue("@whatsApp", telefone.whatsApp);
            command.Parameters.AddWithValue("@fk_IdPessoa", telefone.idPessoa);

            command.ExecuteNonQuery();
        }

        public Telefone Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Telefone WHERE idTelefone = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Telefone
                    {
                        Id = Convert.ToInt32(reader["idTelefone"]),
                        ddd = reader["ddd"].ToString(),
                        telefone = reader["telefone"].ToString(),
                        tipoTelefone = Convert.ToInt32(reader["tipoTelefone"]),
                        whatsApp = Convert.ToBoolean(reader["whatsApp"]),
                        idPessoa = Convert.ToInt32(reader["fk_IdPessoa"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Telefone> GetAll()
        {
            var result = new List<Telefone>();

            var command = CreateCommand("SELECT * FROM public.Cidades");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Telefone
                        {
                            Id = Convert.ToInt32(reader["idTelefone"]),
                            ddd = reader["ddd"].ToString(),
                            telefone = reader["telefone"].ToString(),
                            tipoTelefone = Convert.ToInt32(reader["tipoTelefone"]),
                            whatsApp = Convert.ToBoolean(reader["whatsApp"]),
                            idPessoa = Convert.ToInt32(reader["fk_IdPessoa"])
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

        public IEnumerable<Telefone> GetByPessoa(int idPessoa)
        {
            var result = new List<Telefone>();

            var command = CreateCommand("SELECT * FROM public.Telefone where fk_IdPessoa = @fk_IdPessoa");
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Telefone
                        {
                            Id = Convert.ToInt32(reader["idTelefone"]),
                            ddd = reader["ddd"].ToString(),
                            telefone = reader["telefone"].ToString(),
                            tipoTelefone = Convert.ToInt32(reader["tipoTelefone"]),
                            whatsApp = Convert.ToBoolean(reader["whatsApp"]),
                            idPessoa = Convert.ToInt32(reader["fk_IdPessoa"])
                        });
                    }
                }
                reader.Close();
            }
            return result;
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM Telefone WHERE idTelefone = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Telefone telefone)
        {
            var query = "UPDATE public.Telefone SET ddd = @ddd, telefone = @telefone, tipoTelefone = @tipoTelefone, whatsApp = @whatsApp, fk_IdPessoa = @fk_IdPessoa WHERE idTelefone = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ddd", telefone.ddd);
            command.Parameters.AddWithValue("@telefone", telefone.telefone);
            command.Parameters.AddWithValue("@tipoTelefone", telefone.tipoTelefone);
            command.Parameters.AddWithValue("@whatsApp", telefone.whatsApp);
            command.Parameters.AddWithValue("@fk_IdPessoa", telefone.idPessoa);
            command.Parameters.AddWithValue("@id", telefone.Id);

            command.ExecuteNonQuery();
        }
    }
}
