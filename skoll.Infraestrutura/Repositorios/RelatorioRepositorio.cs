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

        public void Create(Usuario t)
        {
            throw new NotImplementedException();
        }

        public Usuario Get(int id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Usuario> GetAll()
        {
            throw new NotImplementedException();
        }

        public List<Cidade> RelCidadesEstado(string estado)
        {
            var result = new List<Cidade>();
            var command = CreateCommand("SELECT * FROM public.Cidades where estado = @estado LIMIT 10");
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

        public void Remove(int id)
        {
            throw new NotImplementedException();
        }

        public void Update(Usuario t)
        {
            throw new NotImplementedException();
        }
    }
}
