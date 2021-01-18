using Npgsql;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class ContratoRepositorio : RepositorioBase, IContratoRepositorio
    {
        public ContratoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public void CancelarContrato(int novoCliente, decimal multa)
        {
            throw new NotImplementedException();
        }

        public void Create(Contrato Contrato)
        {
            var query = "INSERT INTO public.Contrato(qntdExemplares, tipoDocumento, numParcelas, valorTotal, juros, observacoes, ativo, dataInicio, periodoMeses, dataTermino, fk_IdFormaPag, fk_IdVendedor, fk_IdUsuario, fk_IdCliente, fk_IdPessoa) " +
                "VALUES (@qntdExemplares, @tipoDocumento, @numParcelas, @valorTotal, @juros, @observacoes, @ativo, @dataInicio, @periodoMeses, @dataTermino, @fk_IdFormaPag, @fk_IdVendedor, @fk_IdUsuario, @fk_IdCliente, @fk_IdPessoa)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@qntdExemplares", Contrato.qntdExemplares);
            command.Parameters.AddWithValue("@tipoDocumento", Contrato.tipoDocumento);
            command.Parameters.AddWithValue("@numParcelas", Contrato.numParcelas);
            command.Parameters.AddWithValue("@valorTotal", Contrato.valorTotal);
            command.Parameters.AddWithValue("@juros", Contrato.juros);
            command.Parameters.AddWithValue("@observacoes", Contrato.observacoes);
            command.Parameters.AddWithValue("@ativo", Contrato.ativo);
            command.Parameters.AddWithValue("@dataInicio", Contrato.dataInicio);
            command.Parameters.AddWithValue("@periodoMeses", Contrato.periodoMeses);
            command.Parameters.AddWithValue("@dataTermino", Contrato.dataInicio);
            command.Parameters.AddWithValue("@fk_IdFormaPag", Contrato.formaPagamento.Id);
            command.Parameters.AddWithValue("@fk_IdVendedor", Contrato.vendedor.Id);
            command.Parameters.AddWithValue("@fk_IdUsuario", Contrato.usuario.Id);
            command.Parameters.AddWithValue("@fk_IdCliente", Contrato.cliente.idCliente);
            command.Parameters.AddWithValue("@fk_IdPessoa", Contrato.cliente.Id);

            command.ExecuteNonQuery();
        }

        public void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento)
        {
            throw new NotImplementedException();
        }

        public void GerarParcelas(Contrato Contrato)
        {
            throw new NotImplementedException();
        }

        public Contrato Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Contrato WHERE idContrato = @id");
            command.Parameters.AddWithValue("@id", id);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    return new Contrato
                    {
                        Id = Convert.ToInt32(reader["idContrato"]),
                        qntdExemplares = Convert.ToInt32(reader["qntdExemplares"]),
                        tipoDocumento = Convert.ToInt32(reader["tipoDocumento"]),
                        numParcelas = Convert.ToInt32(reader["numParcelas"]),
                        valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        observacoes = reader["observacoes"].ToString(),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        dataInicio = Convert.ToDateTime(reader["dataInicio"]),
                        periodoMeses = Convert.ToInt32(reader["periodoMeses"]),
                        dataTermino = Convert.ToDateTime(reader["dataTermino"]),
                        formaPagamento = new FormaPagamentoRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdFormaPag"])),
                        vendedor = new VendedorRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdVendedor"])),
                        usuario = new UsuarioRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdUsuario"])),
                        cliente = new ClienteRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdCliente"]))
                    };
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<Contrato> GetAll()
        {
            var result = new List<Contrato>();

            var command = CreateCommand("SELECT * FROM public.Contrato");

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new Contrato
                        {
                            Id = Convert.ToInt32(reader["idContrato"]),
                            qntdExemplares = Convert.ToInt32(reader["qntdExemplares"]),
                            tipoDocumento = Convert.ToInt32(reader["tipoDocumento"]),
                            numParcelas = Convert.ToInt32(reader["numParcelas"]),
                            valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                            juros = Convert.ToDecimal(reader["juros"]),
                            observacoes = reader["observacoes"].ToString(),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            dataInicio = Convert.ToDateTime(reader["dataInicio"]),
                            periodoMeses = Convert.ToInt32(reader["periodoMeses"]),
                            dataTermino = Convert.ToDateTime(reader["dataTermino"]),
                            formaPagamento = new FormaPagamentoRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdFormaPag"])),
                            vendedor = new VendedorRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdVendedor"])),
                            usuario = new UsuarioRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdUsuario"])),
                            cliente = new ClienteRepositorio(this._context, this._transaction).Get(Convert.ToInt32(reader["fk_IdCliente"]))
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
            var command = CreateCommand("DELETE FROM Contrato WHERE idContrato = @id");
            command.Parameters.AddWithValue("@id", id);

            command.ExecuteNonQuery();
        }

        public void Update(Contrato Contrato)
        {
            var query = "UPDATE public.Contrato SET qntdExemplares = @qntdExemplares, tipoDocumento = @tipoDocumento, numParcelas = @numParcelas, " +
                        "valorTotal = @valorTotal, juros = @juros, observacoes = @observacoes, ativo = @ativo, dataInicio = @dataInicio, " +
                        "periodoMeses = @periodoMeses, dataTermino = @dataTermino, fk_IdFormaPag = @fk_IdFormaPag, fk_IdVendedor = @fk_IdVendedor, " +
                        "fk_IdUsuario = @fk_IdUsuario, fk_IdCliente = @fk_IdCliente, fk_IdPessoa = @fk_IdPessoa WHERE idContrato = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@qntdExemplares", Contrato.qntdExemplares);
            command.Parameters.AddWithValue("@tipoDocumento", Contrato.tipoDocumento);
            command.Parameters.AddWithValue("@numParcelas", Contrato.numParcelas);
            command.Parameters.AddWithValue("@valorTotal", Contrato.valorTotal);
            command.Parameters.AddWithValue("@juros", Contrato.juros);
            command.Parameters.AddWithValue("@observacoes", Contrato.observacoes);
            command.Parameters.AddWithValue("@ativo", Contrato.ativo);
            command.Parameters.AddWithValue("@dataInicio", Contrato.dataInicio);
            command.Parameters.AddWithValue("@periodoMeses", Contrato.periodoMeses);
            command.Parameters.AddWithValue("@dataTermino", Contrato.dataInicio);
            command.Parameters.AddWithValue("@fk_IdFormaPag", Contrato.formaPagamento.Id);
            command.Parameters.AddWithValue("@fk_IdVendedor", Contrato.vendedor.Id);
            command.Parameters.AddWithValue("@fk_IdUsuario", Contrato.usuario.Id);
            command.Parameters.AddWithValue("@fk_IdCliente", Contrato.cliente.idCliente);
            command.Parameters.AddWithValue("@fk_IdPessoa", Contrato.cliente.Id);
            command.Parameters.AddWithValue("@id", Contrato.Id);

            command.ExecuteNonQuery();
        }
    }
}
