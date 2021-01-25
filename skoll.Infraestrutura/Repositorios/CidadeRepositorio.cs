using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class CidadeRepositorio : RepositorioBase, ICidadeRepositorio
    {
        public CidadeRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Cidade cidade)
        {
            var query = "INSERT INTO public.Cidades(cidade, estado) VALUES (@cidade, @estado)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@cidade", cidade.cidade);
            command.Parameters.AddWithValue("@estado", cidade.estado);

            command.ExecuteNonQuery();


            query = "select currval('cidades_idcidade_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    cidade.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public Cidade Get(int id)
        {
            var command = CreateCommand("SELECT idCidade, cidade, estado FROM public.Cidades WHERE idCidade = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Cidade
                    {
                        Id = Convert.ToInt32(reader["idCidade"]),
                        cidade = reader["cidade"].ToString(),
                        estado = reader["estado"].ToString()
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Cidade> GetAll()
        {
            var result = new List<Cidade>();

            var command = CreateCommand("SELECT * FROM public.Cidades");

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

        public IEnumerable<Cidade> GetByEstado(string estado)
        {
            var result = new List<Cidade>();
            var command = CreateCommand("SELECT * FROM public.Cidades where estado = @estado");
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

        public IEnumerable<Cidade> GetByNome(string nome)
        {
            var result = new List<Cidade>();
            var command = CreateCommand("SELECT * FROM public.Cidades where cidade = @cidade");
            command.Parameters.AddWithValue("@cidade", nome);

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

        public Cidade GetByNomeEstado(string nome, string estado)
        {
            var result = new List<Cidade>();
            var command = CreateCommand("SELECT TOP 1 * FROM public.Cidades where cidade = @cidade and estado = @estado");
            command.Parameters.AddWithValue("@cidade", nome);
            command.Parameters.AddWithValue("@estado", estado);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Cidade
                    {
                        Id = Convert.ToInt32(reader["idCidade"]),
                        cidade = reader["cidade"].ToString(),
                        estado = reader["estado"].ToString()
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
            var command = CreateCommand("DELETE FROM Cidades WHERE idCidade = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Cidade cidade)
        {
            var query = "UPDATE public.Cidades SET cidade = @cidade, estado = @estado WHERE idCidade = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@cidade", cidade.cidade);
            command.Parameters.AddWithValue("@estado", cidade.estado);
            command.Parameters.AddWithValue("@id", cidade.Id);

            command.ExecuteNonQuery();
        }
    }
}
