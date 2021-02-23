using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class FornecedorRepositorio : RepositorioBase, IFornecedorRepositorio
    {
        public FornecedorRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Fornecedor fornecedor)
        {
            bool inseriuNovo = false;
            var idPessoa = fornecedor.Id;
            if (idPessoa > 0)
                new PessoaRepositorio(this._context, this._transaction).Update(fornecedor.ToPessoa());
            else
            {
                var pessoaInsert = new PessoaRepositorio(this._context, this._transaction).GetByCpfCnpj(fornecedor.ToPessoa().cpfCnpj);
                if (pessoaInsert == null)
                {
                    inseriuNovo = true;
                    new PessoaRepositorio(this._context, this._transaction).Create(fornecedor.ToPessoa());
                    pessoaInsert = new PessoaRepositorio(this._context, this._transaction).GetByCpfCnpj(fornecedor.cpfCnpj);
                }

                if (pessoaInsert != null)
                {
                    idPessoa = pessoaInsert.Id;
                    fornecedor.Id = idPessoa;
                    if (!inseriuNovo)
                        new PessoaRepositorio(this._context, this._transaction).Update(fornecedor.ToPessoa());
                }
            }

            var query = "INSERT INTO public.Fornecedor(ativo, tipoFornecedor, fk_IdPessoa) " +
                        " VALUES (@ativo, @tipoFornecedor, @fk_IdPessoa) ";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ativo", fornecedor.ativo);
            command.Parameters.AddWithValue("@tipoFornecedor", fornecedor.tipoFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);

            command.ExecuteNonQuery();

            query = "select currval('fornecedor_idfornecedor_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    fornecedor.idFornecedor = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public Fornecedor Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Fornecedor WHERE idFornecedor = @id");
            command.Parameters.AddWithValue("@id", id);
            Fornecedor fornecedor = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    fornecedor = new Fornecedor
                    {
                        Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                        idFornecedor = Convert.ToInt32(reader["idFornecedor"]),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        tipoFornecedor = Convert.ToInt32(reader["tipoFornecedor"])                        
                    };                    
                }
                else
                {
                    return null;
                }
            }

            fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

            return fornecedor;
        }

        public IEnumerable<Fornecedor> GetAll()
        {
            var result = new List<Fornecedor>();

            var command = CreateCommand("SELECT * FROM public.Fornecedor");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var fornecedor = new Fornecedor
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idFornecedor = Convert.ToInt32(reader["idFornecedor"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            tipoFornecedor = Convert.ToInt32(reader["tipoFornecedor"])
                        };

                        result.Add(fornecedor);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var fornecedor in result)
            {
                fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));
                fornecedor.cpfCnpj = fornecedor.tipoFornecedor == 1 ? Convert.ToUInt64(fornecedor.cpfCnpj).ToString(@"000\.000\.000\-00")
                                                                    : Convert.ToUInt64(fornecedor.cpfCnpj).ToString(@"00\.000\.000\/0000\-00");
            }

            return result;
        }

        public IEnumerable<Fornecedor> GetAtivos()
        {
            var result = new List<Fornecedor>();

            var command = CreateCommand("SELECT * FROM public.Fornecedor where ativo = true");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var fornecedor = new Fornecedor
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idFornecedor = Convert.ToInt32(reader["idFornecedor"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            tipoFornecedor = Convert.ToInt32(reader["tipoFornecedor"])
                        };

                        result.Add(fornecedor);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var fornecedor in result)
                fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

            return result;
        }

        public IEnumerable<Fornecedor> GetByNomeLike(string nome)
        {
            var result = new List<Fornecedor>();

            var command = CreateCommand("SELECT * FROM Fornecedor f inner join pessoa p on f.fk_idPessoa = p.idPessoa where p.nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        var fornecedor = new Fornecedor
                        {
                            Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                            idFornecedor = Convert.ToInt32(reader["idFornecedor"]),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            tipoFornecedor = Convert.ToInt32(reader["tipoFornecedor"])
                        };

                        result.Add(fornecedor);
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var fornecedor in result)
                fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

            return result;
        }

        public int GetIdPessoa(int idFornecedor)
        {
            var command = CreateCommand("SELECT fk_IdPessoa FROM public.Fornecedor WHERE idFornecedor = @id");
            command.Parameters.AddWithValue("@id", idFornecedor);

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
            var command = CreateCommand("DELETE FROM Fornecedor WHERE idFornecedor = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Fornecedor fornecedor)
        {
            var idPessoa = fornecedor.Id;
            if (idPessoa > 0)
                new PessoaRepositorio(this._context, this._transaction).Update(fornecedor.ToPessoa());
            else
            {
                new PessoaRepositorio(this._context, this._transaction).Create(fornecedor.ToPessoa());
                var pessoaInsert = new PessoaRepositorio(this._context, this._transaction).GetByCpfCnpj(fornecedor.cpfCnpj);

                if (pessoaInsert != null)
                    idPessoa = pessoaInsert.Id;
            }

            var query = "UPDATE public.Fornecedor SET ativo = @ativo, tipoFornecedor = @tipoFornecedor, fk_IdPessoa = @fk_IdPessoa WHERE idFornecedor = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ativo", fornecedor.ativo);
            command.Parameters.AddWithValue("@tipoFornecedor", fornecedor.tipoFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);
            command.Parameters.AddWithValue("@id", fornecedor.Id);

            command.ExecuteNonQuery();
        }
    }
}
