using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class VendedorRepositorio : RepositorioBase, IVendedorRepositorio
    {
        public VendedorRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Vendedor vendedor)
        {
            var query = "INSERT INTO public.Vendedor(codigo, cpf, ativo, nome, percComis) VALUES (@codigo, @cpf, @ativo, @nome, @percComis)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@codigo", vendedor.codigo);
            command.Parameters.AddWithValue("@cpf", vendedor.cpf);
            command.Parameters.AddWithValue("@ativo", vendedor.ativo);
            command.Parameters.AddWithValue("@nome", vendedor.nome);
            command.Parameters.AddWithValue("@percComis", vendedor.percComis);

            command.ExecuteNonQuery();
        }

        public Vendedor Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Vendedor WHERE idVendedor = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Vendedor
                    {
                        Id = Convert.ToInt32(reader["idVendedor"]),
                        codigo = reader["codigo"].ToString(),
                        cpf = reader["cpf"].ToString(),
                        nome = reader["nome"].ToString(),
                        percComis = Convert.ToDecimal(reader["percComis"]),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Vendedor> GetAll()
        {
            var result = new List<Vendedor>();

            var command = CreateCommand("SELECT * FROM public.Vendedor");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Vendedor
                        {
                            Id = Convert.ToInt32(reader["idVendedor"]),
                            codigo = reader["codigo"].ToString(),
                            cpf = reader["cpf"].ToString(),
                            nome = reader["nome"].ToString(),
                            percComis = Convert.ToDecimal(reader["percComis"]),
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

        public IEnumerable<Vendedor> GetAtivos()
        {
            var result = new List<Vendedor>();

            var command = CreateCommand("SELECT * FROM public.Vendedor where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Vendedor
                        {
                            Id = Convert.ToInt32(reader["idVendedor"]),
                            codigo = reader["codigo"].ToString(),
                            cpf = reader["cpf"].ToString(),
                            nome = reader["nome"].ToString(),
                            percComis = Convert.ToDecimal(reader["percComis"]),
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

        public IEnumerable<Vendedor> GetByNomeLike(string nome)
        {
            var result = new List<Vendedor>();

            var command = CreateCommand("SELECT * FROM public.Vendedor where nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Vendedor
                        {
                            Id = Convert.ToInt32(reader["idVendedor"]),
                            codigo = reader["codigo"].ToString(),
                            cpf = reader["cpf"].ToString(),
                            nome = reader["nome"].ToString(),
                            percComis = Convert.ToDecimal(reader["percComis"]),
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

        public Vendedor GetByCodigo(string codigo)
        {
            var command = CreateCommand("SELECT * FROM public.Vendedor where codigo = @codigo");
            command.Parameters.AddWithValue("@codigo", codigo);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Vendedor
                    {
                        Id = Convert.ToInt32(reader["idVendedor"]),
                        codigo = reader["codigo"].ToString(),
                        cpf = reader["cpf"].ToString(),
                        nome = reader["nome"].ToString(),
                        percComis = Convert.ToDecimal(reader["percComis"]),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM Vendedor WHERE idVendedor = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Vendedor vendedor)
        {
            var query = "UPDATE public.Vendedor SET codigo = @codigo, cpf = @cpf, ativo = @ativo, nome = @nome, percComis = @percComis WHERE idFormaPag = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@codigo", vendedor.codigo);
            command.Parameters.AddWithValue("@cpf", vendedor.cpf);
            command.Parameters.AddWithValue("@ativo", vendedor.ativo);
            command.Parameters.AddWithValue("@nome", vendedor.nome);
            command.Parameters.AddWithValue("@percComis", vendedor.percComis);
            command.Parameters.AddWithValue("@id", vendedor.Id);

            command.ExecuteNonQuery();
        }
    }
}
