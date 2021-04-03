using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class FormaPagamentoRepositorio : RepositorioBase, IFormaPagamentoRepositorio
    {
        public FormaPagamentoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(FormaPagamento formaPag)
        {
            var query = "INSERT INTO public.FormaPagamento(nome, qtdParcela, ativo) VALUES (@nome, @qtdParcela, @ativo)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", formaPag.nome);
            command.Parameters.AddWithValue("@qtdParcela", formaPag.qtdParcela);
            command.Parameters.AddWithValue("@ativo", formaPag.ativo);

            command.ExecuteNonQuery();

            query = "select currval('formapagamento_idformapag_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    formaPag.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public FormaPagamento Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.FormaPagamento WHERE idFormaPag = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new FormaPagamento
                    {
                        Id = Convert.ToInt32(reader["idFormaPag"]),
                        nome = reader["nome"].ToString(),
                        qtdParcela = Convert.ToInt32(reader["qtdParcela"]),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<FormaPagamento> GetAll()
        {
            var result = new List<FormaPagamento>();

            var command = CreateCommand("SELECT * FROM public.FormaPagamento");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new FormaPagamento
                        {
                            Id = Convert.ToInt32(reader["idFormaPag"]),
                            nome = reader["nome"].ToString(),
                            qtdParcela = Convert.ToInt32(reader["qtdParcela"]),
                            ativo = Convert.ToBoolean(reader["ativo"])
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            return result.OrderBy(r => r.nome);
        }

        public IEnumerable<FormaPagamento> GetAtivos()
        {
            var result = new List<FormaPagamento>();

            var command = CreateCommand("SELECT * FROM public.FormaPagamento where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new FormaPagamento
                        {
                            Id = Convert.ToInt32(reader["idFormaPag"]),
                            nome = reader["nome"].ToString(),
                            qtdParcela = Convert.ToInt32(reader["qtdParcela"]),
                            ativo = Convert.ToBoolean(reader["ativo"])
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

        public IEnumerable<FormaPagamento> GetByNomeLike(string nome)
        {
            var result = new List<FormaPagamento>();

            var command = CreateCommand("SELECT * FROM public.FormaPagamento where nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new FormaPagamento
                        {
                            Id = Convert.ToInt32(reader["idFormaPag"]),
                            nome = reader["nome"].ToString(),
                            qtdParcela = Convert.ToInt32(reader["qtdParcela"]),
                            ativo = Convert.ToBoolean(reader["ativo"])
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
            var command = CreateCommand("DELETE FROM FormaPagamento WHERE idFormaPag = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(FormaPagamento formaPag)
        {
            var query = "UPDATE public.FormaPagamento SET nome = @nome, qtdParcela = @qtdParcela, ativo = @ativo WHERE idFormaPag = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", formaPag.nome);
            command.Parameters.AddWithValue("@qtdParcela", formaPag.qtdParcela);
            command.Parameters.AddWithValue("@ativo", formaPag.ativo);
            command.Parameters.AddWithValue("@id", formaPag.Id);

            command.ExecuteNonQuery();
        }
    }
}
