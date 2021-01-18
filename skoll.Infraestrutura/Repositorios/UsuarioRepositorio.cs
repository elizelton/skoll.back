using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class UsuarioRepositorio : RepositorioBase, IUsuarioRepositorio
    {
        public UsuarioRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public Usuario GetByUserNameESenha(string username, string senha)
        {
            var command = CreateCommand("SELECT idusuario, nome, username, senha, ativo FROM public.Usuario " +
                "WHERE UserName = @username " +
                "AND Senha = @senha " +
                "AND ativo = true");

            command.Parameters.AddWithValue("@username", username);
            command.Parameters.AddWithValue("@senha", senha);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();

                if (reader.HasRows)
                {
                    return new Usuario
                    {
                        Id = Convert.ToInt32(reader["idusuario"]),
                        userName = reader["username"].ToString(),
                        nome = reader["nome"].ToString(),
                        senha = reader["senha"].ToString(),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public void Create(Usuario usuario)
        {
            var query = "INSERT INTO public.Usuario(username, nome, senha, ativo) VALUES (@username, @nome, @senha, @ativo)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@username", usuario.userName);
            command.Parameters.AddWithValue("@nome", usuario.nome);
            command.Parameters.AddWithValue("@senha", usuario.senha);
            command.Parameters.AddWithValue("@ativo", usuario.ativo);

            command.ExecuteNonQuery();
        }

        public Usuario Get(int id)
        {
            var command = CreateCommand("SELECT idusuario, nome, username, senha, ativo FROM public.Usuario WHERE idusuario = @id");
            command.Parameters.AddWithValue("@idusuario", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Usuario
                    {
                        Id = Convert.ToInt32(reader["idusuario"]),
                        userName = reader["username"].ToString(),
                        nome = reader["nome"].ToString(),
                        senha = reader["senha"].ToString(),
                        ativo = Convert.ToBoolean(reader["ativo"])
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Usuario> GetAll()
        {
            var result = new List<Usuario>();

            var command = CreateCommand("SELECT * FROM public.Usuario and username <> 'skolladmin' ");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Usuario
                        {
                            Id = Convert.ToInt32(reader["idUsuario"]),
                            userName = reader["username"].ToString(),
                            nome = reader["nome"].ToString(),
                            senha = reader["senha"].ToString(),
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
            var command = CreateCommand("DELETE FROM Usuario WHERE idusuario = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Remove(List<Usuario> usuarios)
        {
            //var command = CreateCommand("DELETE FROM Usuario WHERE idusuario IN (@ids)");

            //var parameters = new string[usuarios.Count];
            //for (int i = 0;  i < usuarios.Count; i++)
            //{
            //    parameters[i] = string.Format("@idUsuario{0}", i);
            //    cmd.Parameters.AddWithValue(parameters[i], items[i]);
            //}

            //command.Parameters.Add("@ids", String.Join(",", usuarios.Select(u => u.Id)).ToString());

            //command.ExecuteNonQuery();
        }

        public void Update(Usuario usuario)
        {
            var query = "UPDATE public.Usuario SET  Nome = @nome, UserName = @username, senha = @senha, ativo = @ativo WHERE idusuario = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", usuario.nome);
            command.Parameters.AddWithValue("@username", usuario.userName);
            command.Parameters.AddWithValue("@senha", usuario.senha);
            command.Parameters.AddWithValue("@ativo", usuario.ativo);
            command.Parameters.AddWithValue("@id", usuario.Id);

            command.ExecuteNonQuery();
        }
    }
}
