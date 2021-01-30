using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class PessoaRepositorio : RepositorioBase, IPessoaRepositorio
    {
        public PessoaRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void Create(Pessoa pessoa)
        {
            var query = "INSERT INTO public.Pessoa(cpfCnpj, numero, complemento, bairro, Nome, email, cep, logradouro, fk_IdCidade) " +
                        " VALUES (@cpfCnpj, @numero, @complemento, @bairro, @Nome, @email, @cep, @logradouro, @fk_IdCidade) ";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@cpfCnpj", pessoa.cpfCnpj);
            command.Parameters.AddWithValue("@numero", pessoa.numero);
            command.Parameters.AddWithValue("@complemento", pessoa.complemento);
            command.Parameters.AddWithValue("@bairro", pessoa.bairro);
            command.Parameters.AddWithValue("@Nome", pessoa.nome);
            command.Parameters.AddWithValue("@email", pessoa.email);
            command.Parameters.AddWithValue("@cep", pessoa.cep);
            command.Parameters.AddWithValue("@logradouro", pessoa.logradouro);
            command.Parameters.AddWithValue("@fk_IdCidade", pessoa.Cidade.Id);

            command.ExecuteNonQuery();

            query = "select currval('pessoa_idpessoa_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    pessoa.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public Pessoa Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Pessoa WHERE idPessoa = @id");
            command.Parameters.AddWithValue("@id", id);
            Pessoa pessoa = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    pessoa = new Pessoa
                    {
                        Id = Convert.ToInt32(reader["idPessoa"]),
                        cpfCnpj = reader["cpfCnpj"].ToString(),
                        numero = reader["numero"].ToString(),
                        complemento = reader["complemento"].ToString(),
                        bairro = reader["bairro"].ToString(),
                        nome = reader["Nome"].ToString(),
                        email = reader["email"].ToString(),
                        cep = reader["cep"].ToString(),
                        logradouro = reader["logradouro"].ToString(),
                        Cidade = new Cidade() { Id = Convert.ToInt32(reader["fk_IdCidade"]) }
                    };
                }
                else
                {
                    return null;
                }
            }

            pessoa.Cidade = new CidadeRepositorio(this._context, this._transaction).Get(pessoa.Cidade.Id);
            pessoa.telefones = (List<Telefone>)new TelefoneRepositorio(this._context, this._transaction).GetByPessoa(pessoa.Id);

            return pessoa;
        }

        public IEnumerable<Pessoa> GetAll()
        {
            var result = new List<Pessoa>();

            var command = CreateCommand("SELECT * FROM public.Pessoa");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Pessoa
                        {
                            Id = Convert.ToInt32(reader["idPessoa"]),
                            cpfCnpj = reader["cpfCnpj"].ToString(),
                            numero = reader["numero"].ToString(),
                            complemento = reader["complemento"].ToString(),
                            bairro = reader["bairro"].ToString(),
                            nome = reader["Nome"].ToString(),
                            email = reader["email"].ToString(),
                            cep = reader["cep"].ToString(),
                            logradouro = reader["logradouro"].ToString(),
                            Cidade = new Cidade() { Id = Convert.ToInt32(reader["fk_IdCidade"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach(var pessoa in result)
            {
                pessoa.Cidade = new CidadeRepositorio(this._context, this._transaction).Get(pessoa.Cidade.Id);
                pessoa.telefones = (List<Telefone>)new TelefoneRepositorio(this._context, this._transaction).GetByPessoa(pessoa.Id);
            }

            return result;
        }

        public IEnumerable<Pessoa> GetByNomeLike(string nome)
        {
            var result = new List<Pessoa>();

            var command = CreateCommand("SELECT * FROM public.Pessoa where nome like @nome");
            command.Parameters.AddWithValue("@nome", "%" + nome + "%");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Pessoa
                        {
                            Id = Convert.ToInt32(reader["idPessoa"]),
                            cpfCnpj = reader["cpfCnpj"].ToString(),
                            numero = reader["numero"].ToString(),
                            complemento = reader["complemento"].ToString(),
                            bairro = reader["bairro"].ToString(),
                            nome = reader["Nome"].ToString(),
                            email = reader["email"].ToString(),
                            cep = reader["cep"].ToString(),
                            logradouro = reader["logradouro"].ToString(),
                            Cidade = new Cidade() { Id = Convert.ToInt32(reader["fk_IdCidade"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach (var pessoa in result)
            {
                pessoa.Cidade = new CidadeRepositorio(this._context, this._transaction).Get(pessoa.Cidade.Id);
                pessoa.telefones = (List<Telefone>)new TelefoneRepositorio(this._context, this._transaction).GetByPessoa(pessoa.Id);
            }

            return result;
        }

        public Pessoa GetByCpfCnpj(string cpfCnpj)
        {
            var command = CreateCommand("SELECT * FROM public.Pessoa where cpfCnpj = @cpfCnpj");
            command.Parameters.AddWithValue("@cpfCnpj", cpfCnpj);
            Pessoa pessoa = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    pessoa = new Pessoa
                    {
                        Id = Convert.ToInt32(reader["idPessoa"]),
                        cpfCnpj = reader["cpfCnpj"].ToString(),
                        numero = reader["numero"].ToString(),
                        complemento = reader["complemento"].ToString(),
                        bairro = reader["bairro"].ToString(),
                        nome = reader["Nome"].ToString(),
                        email = reader["email"].ToString(),
                        cep = reader["cep"].ToString(),
                        logradouro = reader["logradouro"].ToString(),
                        Cidade = new Cidade() { Id = Convert.ToInt32(reader["fk_IdCidade"]) }
                    };
                }
                else
                {
                    return null;
                }
            }

            pessoa.Cidade = new CidadeRepositorio(this._context, this._transaction).Get(pessoa.Cidade.Id);
            pessoa.telefones = (List<Telefone>)new TelefoneRepositorio(this._context, this._transaction).GetByPessoa(pessoa.Id);

            return pessoa;
        }

        public void Remove(int id)
        {
            var command = CreateCommand("DELETE FROM Pessoa WHERE idPessoa = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Pessoa pessoa)
        {
            var query = "UPDATE public.Pessoa SET cpfCnpj = @cpfCnpj, numero = @numero, complemento = @complemento, bairro = @bairro, Nome = @Nome, " +
                        "email = @email, cep = @cep, logradouro = @logradouro, fk_IdCidade = @fk_IdCidade WHERE idPessoa = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@cpfCnpj", pessoa.cpfCnpj);
            command.Parameters.AddWithValue("@numero", pessoa.numero);
            command.Parameters.AddWithValue("@complemento", pessoa.complemento);
            command.Parameters.AddWithValue("@bairro", pessoa.bairro);
            command.Parameters.AddWithValue("@Nome", pessoa.nome);
            command.Parameters.AddWithValue("@email", pessoa.email);
            command.Parameters.AddWithValue("@cep", pessoa.cep);
            command.Parameters.AddWithValue("@logradouro", pessoa.logradouro);
            command.Parameters.AddWithValue("@fk_IdCidade", pessoa.Cidade.Id);
            command.Parameters.AddWithValue("@id", pessoa.Id);

            command.ExecuteNonQuery();
        }
    }
}
