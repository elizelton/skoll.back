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

            var query = "INSERT INTO public.Fornecedor(ativo, tipoFornecedor, fk_IdPessoa) " +
                        " VALUES (@ativo, @tipoFornecedor, @fk_IdPessoa) ";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ativo", fornecedor.ativo);
            command.Parameters.AddWithValue("@tipoFornecedor", fornecedor.tipoFornecedor);
            command.Parameters.AddWithValue("@fk_IdPessoa", idPessoa);

            command.ExecuteNonQuery();
        }

        public Fornecedor Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Fornecedor WHERE idFornecedor = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    var fornecedor = new Fornecedor
                    {
                        Id = Convert.ToInt32(reader["fk_IdPessoa"]),
                        idFornecedor = Convert.ToInt32(reader["idFornecedor"]),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        tipoFornecedor = Convert.ToInt32(reader["tipoFornecedor"])                        
                    };

                    fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

                    return fornecedor;
                }
                else
                {
                    return null;
                }
            }
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

                        fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

                        result.Add(fornecedor);
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

                        fornecedor.prenchePessoa(new PessoaRepositorio(this._context, this._transaction).Get(fornecedor.Id));

                        result.Add(fornecedor);
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
