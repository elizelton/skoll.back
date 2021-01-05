using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ProdutoRepositorio : RepositorioBase, IProdutoRepositorio
    {
        public ProdutoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Produto produto)
        {
            var query = "INSERT INTO public.Produto(nome, ativo) VALUES (@nome, @ativo)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", produto.nome);
            command.Parameters.AddWithValue("@ativo", produto.ativo);

            command.ExecuteNonQuery();
        }

        public Produto Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Produto WHERE idProduto = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Produto
                    {
                        Id = Convert.ToInt32(reader["idProduto"]),
                        nome = reader["nome"].ToString(),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Produto> GetAll()
        {
            var result = new List<Produto>();

            var command = CreateCommand("SELECT * FROM public.Produto");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Produto
                        {
                            Id = Convert.ToInt32(reader["idProduto"]),
                            nome = reader["nome"].ToString(),
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

        public IEnumerable<Produto> GetAtivos()
        {
            var result = new List<Produto>();

            var command = CreateCommand("SELECT * FROM public.Produto where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Produto
                        {
                            Id = Convert.ToInt32(reader["idProduto"]),
                            nome = reader["nome"].ToString(),
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

        public IEnumerable<Produto> GetByNomeLike(string nome)
        {
            var result = new List<Produto>();

            var command = CreateCommand("SELECT * FROM public.Produto where nome like '%@nome%'");
            command.Parameters.AddWithValue("@nome", nome);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Produto
                        {
                            Id = Convert.ToInt32(reader["idProduto"]),
                            nome = reader["nome"].ToString(),
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
            var command = CreateCommand("DELETE FROM Produto WHERE idProduto = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Produto produto)
        {
            var query = "UPDATE public.Produto SET nome = @nome, ativo = @ativo WHERE idProduto = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", produto.nome);
            command.Parameters.AddWithValue("@ativo", produto.ativo);
            command.Parameters.AddWithValue("@id", produto.Id);

            command.ExecuteNonQuery();
        }
    }
}
