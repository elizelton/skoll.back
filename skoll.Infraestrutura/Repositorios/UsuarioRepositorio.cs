using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using System;
using System.Collections.Generic;

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

                return new Usuario
                {
                    Id = Convert.ToInt32(reader["idusuario"]),
                    UserName = reader["name"].ToString(),
                    Senha = reader["senha"].ToString(),
                    Ativo = Convert.ToBoolean(reader["ativo"])
                };
            }
        }

        public void Create(Usuario usuario)
        {
            var query = "INSERT INTO public.Usuario(username, nome, senha, ativo) VALUES (@username, @nome, @senha, @ativo)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@username", usuario.UserName);
            command.Parameters.AddWithValue("@nome", usuario.Nome);
            command.Parameters.AddWithValue("@senha", usuario.Senha);
            command.Parameters.AddWithValue("@ativo", usuario.Ativo);

            command.ExecuteNonQuery();
        }

        public Usuario Get(int id)
        {
            var command = CreateCommand("SELECT idusuario, nome, username, senha, ativo FROM public.Usuario WHERE id = @id");
            command.Parameters.AddWithValue("@idusuario", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();

                return new Usuario
                {
                    Id = Convert.ToInt32(reader["idusuario"]),
                    UserName = reader["username"].ToString(),
                    Nome = reader["nome"].ToString(),
                    Senha = reader["senha"].ToString(),
                    Ativo = Convert.ToBoolean(reader["ativo"])
                };
            }
        }

        public IEnumerable<Usuario> GetAll()
        {
            var result = new List<Usuario>();

            var command = CreateCommand("SELECT * FROM public.Usuario");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    result.Add(new Usuario
                    {
                        Id = Convert.ToInt32(reader["idUsuario"]),
                        UserName = reader["username"].ToString(),
                        Nome = reader["nome"].ToString(),
                        Senha = reader["senha"].ToString(),
                        Ativo = Convert.ToBoolean(reader["ativo"])
                    });
                }
            }

            return result;
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM Usuario WHERE idusuario = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Usuario usuario)
        {
            var query = "UPDATE public.Usuario SET  Nome = @nome, UserName = @username, senha = @senha, ativo = @ativo WHERE idusuario = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@nome", usuario.Nome);
            command.Parameters.AddWithValue("@username", usuario.UserName);
            command.Parameters.AddWithValue("@senha", usuario.Senha);
            command.Parameters.AddWithValue("@ativo", usuario.Ativo);
            command.Parameters.AddWithValue("@id", usuario.Id);

            command.ExecuteNonQuery();
        }
    }
}
