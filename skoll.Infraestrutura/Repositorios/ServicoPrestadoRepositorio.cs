using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ServicoPrestadoRepositorio : RepositorioBase, IServicoPrestadoRepositorio
    {
        public ServicoPrestadoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(ServicoPrestado servPrest)
        {
            var query = "INSERT INTO public.ServicoPrestado(nome, valorUnitario, ativo, fk_IdProduto) VALUES (@nome, @valorUnitario, @ativo, @fk_IdProduto)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", servPrest.nome);
            command.Parameters.AddWithValue("@valorUnitario", servPrest.valorUnitario);
            command.Parameters.AddWithValue("@ativo", servPrest.ativo);
            command.Parameters.AddWithValue("@fk_IdProduto", servPrest.produto.Id);

            command.ExecuteNonQuery();

            query = "select currval('servicoprestado_idservprest_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    servPrest.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public ServicoPrestado Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.ServicoPrestado WHERE idServPrest = @id");
            command.Parameters.AddWithValue("@id", id);
            ServicoPrestado serv = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    serv = new ServicoPrestado
                    {
                        Id = Convert.ToInt32(reader["idServPrest"]),
                        nome = reader["nome"].ToString(),
                        valorUnitario = Convert.ToInt32(reader["valorUnitario"]),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        produto = new Produto() { Id = Convert.ToInt32(reader["fk_IdProduto"])}
                    };
                }
                else
                {
                    return null;
                }
            }

            serv.produto = new ProdutoRepositorio(this._context, this._transaction).Get(serv.produto.Id);

            return serv;
        }

        public IEnumerable<ServicoPrestado> GetAll()
        {
            var result = new List<ServicoPrestado>();

            var command = CreateCommand("SELECT * FROM public.ServicoPrestado");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ServicoPrestado
                        {
                            Id = Convert.ToInt32(reader["idServPrest"]),
                            nome = reader["nome"].ToString(),
                            valorUnitario = Convert.ToInt32(reader["valorUnitario"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            produto = new Produto() { Id = Convert.ToInt32(reader["fk_IdProduto"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var serv in result)
                serv.produto = new ProdutoRepositorio(this._context, this._transaction).Get(serv.produto.Id);

            return result;
        }

        public IEnumerable<ServicoPrestado> GetAtivos()
        {
            var result = new List<ServicoPrestado>();

            var command = CreateCommand("SELECT * FROM public.ServicoPrestado where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ServicoPrestado
                        {
                            Id = Convert.ToInt32(reader["idServPrest"]),
                            nome = reader["nome"].ToString(),
                            valorUnitario = Convert.ToInt32(reader["valorUnitario"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            produto = new Produto() { Id = Convert.ToInt32(reader["fk_IdProduto"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var serv in result)
                serv.produto = new ProdutoRepositorio(this._context, this._transaction).Get(serv.produto.Id);

            return result;
        }

        public IEnumerable<ServicoPrestado> GetByProduto(int idProduto)
        {
            var result = new List<ServicoPrestado>();

            var command = CreateCommand("SELECT * FROM public.ServicoPrestado where fk_idProduto = @idProduto");
            command.Parameters.AddWithValue("@idProduto", idProduto);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ServicoPrestado
                        {
                            Id = Convert.ToInt32(reader["idServPrest"]),
                            nome = reader["nome"].ToString(),
                            valorUnitario = Convert.ToInt32(reader["valorUnitario"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            produto = new Produto() { Id = Convert.ToInt32(reader["fk_IdProduto"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var serv in result)
                serv.produto = new ProdutoRepositorio(this._context, this._transaction).Get(serv.produto.Id);

            return result;
        }

        public IEnumerable<ServicoPrestado> GetByNomeLike(string nome)
        {
            var result = new List<ServicoPrestado>();

            var command = CreateCommand("SELECT * FROM public.ServicoPrestado where nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new ServicoPrestado
                        {
                            Id = Convert.ToInt32(reader["idServPrest"]),
                            nome = reader["nome"].ToString(),
                            valorUnitario = Convert.ToInt32(reader["valorUnitario"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            produto = new Produto() { Id = Convert.ToInt32(reader["fk_IdProduto"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var serv in result)
                serv.produto = new ProdutoRepositorio(this._context, this._transaction).Get(serv.produto.Id);

            return result;
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM ServicoPrestado WHERE idServPrest = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(ServicoPrestado servPrest)
        {
            var query = "UPDATE public.ServicoPrestado SET nome = @nome, valorUnitario = @valorUnitario, ativo = @ativo, fk_IdProduto = @fk_IdProduto WHERE idServPrest = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", servPrest.nome);
            command.Parameters.AddWithValue("@valorUnitario", servPrest.valorUnitario);
            command.Parameters.AddWithValue("@ativo", servPrest.ativo);
            command.Parameters.AddWithValue("@fk_IdProduto", servPrest.produto.Id);
            command.Parameters.AddWithValue("@id", servPrest.Id);

            command.ExecuteNonQuery();
        }
    }
}
