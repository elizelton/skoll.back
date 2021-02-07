using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ClienteRepositorio : RepositorioBase, IClienteRepositorio
    {
        public ClienteRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Cliente cliente)
        {
            var idPessoa = cliente.Id;
            if (idPessoa > 0)
                new PessoaRepositorio(this._context, this._transaction).Update(cliente.ToPessoa());
            else
            {
                new PessoaRepositorio(this._context, this._transaction).Create(cliente.ToPessoa());
                var pessoaInsert = new PessoaRepositorio(this._context, this._transaction).GetByCpfCnpj(cliente.cpfCnpj);

                if (pessoaInsert != null)
                {
                    idPessoa = pessoaInsert.Id;
                    cliente.Id = idPessoa;
                }
            }

            var query = "INSERT INTO public.Cliente(tipoCliente, ativo, nascimento, fk_IdPessoa) " +
                        " VALUES (@tipoCliente, @ativo, @nascimento, @fk_IdPessoa) ";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@tipoCliente", cliente.tipoCliente);
            command.Parameters.AddWithValue("@ativo", cliente.ativo);
            command.Parameters.AddWithValue("@nascimento", cliente.nascimento);
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);

            command.ExecuteNonQuery();


            query = "select currval('cliente_idcliente_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    cliente.idCliente = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public Cliente Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Cliente WHERE idCliente = @id");
            command.Parameters.AddWithValue("@id", id);
            Cliente cliente = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    cliente = new Cliente
                    {
                        Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                        idCliente = Convert.ToInt32(reader["idCliente"]),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        nascimento = Convert.ToDateTime(reader["nascimento"]),
                        tipoCliente = Convert.ToInt32(reader["tipoCliente"])
                    };                    
                }
                else
                {
                    return null;
                }
            }

            cliente.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(cliente.Id));

            return cliente;
        }

        public IEnumerable<Cliente> GetAll()
        {
            var result = new List<Cliente>();

            var command = CreateCommand("SELECT * FROM public.Cliente");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var cliente = new Cliente
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idCliente = Convert.ToInt32(reader["idCliente"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            nascimento = Convert.ToDateTime(reader["nascimento"]),
                            tipoCliente = Convert.ToInt32(reader["tipoCliente"])
                        };                       

                        result.Add(cliente);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var cli in result)
            {
                cli.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(cli.Id));
                cli.cpfCnpj = cli.tipoCliente == 1 ? Convert.ToUInt64(cli.cpfCnpj).ToString(@"000\.000\.000\-00")
                                                   : Convert.ToUInt64(cli.cpfCnpj).ToString(@"00\.000\.000\/0000\-00");
            }

            return result;
        }

        public IEnumerable<Cliente> GetAtivos()
        {
            var result = new List<Cliente>();

            var command = CreateCommand("SELECT * FROM public.Cliente where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var cliente = new Cliente
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idCliente = Convert.ToInt32(reader["idCliente"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            nascimento = Convert.ToDateTime(reader["nascimento"]),
                            tipoCliente = Convert.ToInt32(reader["tipoCliente"])
                        };

                        result.Add(cliente);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var cli in result)
                cli.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(cli.Id));

            return result;
        }

        public IEnumerable<Cliente> GetByNomeLike(string nome)
        {
            var result = new List<Cliente>();

            var command = CreateCommand("SELECT * FROM cliente c inner join pessoa p on c.fk_idPessoa = p.idPessoa where p.nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var cliente = new Cliente
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idCliente = Convert.ToInt32(reader["idCliente"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            nascimento = Convert.ToDateTime(reader["nascimento"]),
                            tipoCliente = Convert.ToInt32(reader["tipoCliente"])
                        };

                        result.Add(cliente);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var cli in result)
                cli.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(cli.Id));

            return result;
        }

        public int GetIdPessoa(int idCliente)
        {
            var command = CreateCommand("SELECT fk_IdPessoa FROM public.Cliente WHERE idCliente = @id");
            command.Parameters.AddWithValue("@id", idCliente);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return Convert.ToInt32(reader["fk_IdPessoa"]);
                }
                else
                {
                    return 0;
                }
            }
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM Cliente WHERE idCliente = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Cliente cliente)
        {
            var idPessoa = cliente.Id;
            if (idPessoa > 0)
                new PessoaRepositorio(this._context, this._transaction).Update(cliente.ToPessoa());
            else
            {
                new PessoaRepositorio(this._context, this._transaction).Create(cliente.ToPessoa());
                var pessoaInsert = new PessoaRepositorio(this._context, this._transaction).GetByCpfCnpj(cliente.cpfCnpj);

                if (pessoaInsert != null)
                    idPessoa = pessoaInsert.Id;
            }

            var query = "UPDATE public.Cliente SET ativo = @ativo, tipoCliente = @tipoCliente, nascimento = @nascimento, fk_IdPessoa = @fk_IdPessoa WHERE idCliente = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@tipoCliente", cliente.tipoCliente);
            command.Parameters.AddWithValue("@ativo", cliente.ativo);
            command.Parameters.AddWithValue("@nascimento", cliente.nascimento);
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);
            command.Parameters.AddWithValue("@id", cliente.Id);

            command.ExecuteNonQuery();
        }
    }
}
