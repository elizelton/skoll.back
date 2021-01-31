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

        public void CancelarContrato(Contrato contrato, int novoCliente, decimal multa)
        {
            throw new NotImplementedException();
        }

        public void Create(Contrato Contrato)
        {
            var query = "INSERT INTO public.Contrato(qntdExemplares, tipoDocumento, numParcelas, valorTotal, juros, ajuste, observacoes, ativo, dataInicio, periodoMeses, dataTermino, fk_IdFormaPag, fk_IdVendedor, fk_IdUsuario, fk_IdCliente, fk_IdPessoa) " +
                "VALUES (@qntdExemplares, @tipoDocumento, @numParcelas, @valorTotal, @juros, @ajuste, @observacoes, @ativo, @dataInicio, @periodoMeses, @dataTermino, @fk_IdFormaPag, @fk_IdVendedor, @fk_IdUsuario, @fk_IdCliente, @fk_IdPessoa)";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@qntdExemplares", Contrato.qntdExemplares);
            command.Parameters.AddWithValue("@tipoDocumento", Contrato.tipoDocumento);
            command.Parameters.AddWithValue("@numParcelas", Contrato.numParcelas);
            command.Parameters.AddWithValue("@valorTotal", Contrato.valorTotal);
            command.Parameters.AddWithValue("@juros", Contrato.juros);
            command.Parameters.AddWithValue("@ajuste", Contrato.ajuste);
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

            query = "select currval('contrato_idcontrato_seq') as newId";
            command = CreateCommand(query);

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    Contrato.Id = Convert.ToInt32(reader["newId"]);
                }
            }
        }

        public void GerarParcelaAjuste(int idConta, decimal valorDif, DateTime vencimento)
        {
            throw new NotImplementedException();
        }

        public void GerarParcelas(Contrato Contrato, int diaVencimentoDemais, bool isPrimeiraVigencia)
        {
            //datainicio, datatermino, numparcelass
            var servicos = (List<ContratoServico>)new ContratoServicoRepositorio(this._context, this._transaction).GetByContrato(Contrato.Id);
            if (servicos == null || servicos.Count == 0)
                return;
            else if (Contrato.numParcelas == 0)
                throw new InvalidOperationException("É necessário informar o número de parcelas");

            DateTime dataPrimeira = DateTime.Today;
            decimal valorParc = servicos.Sum(s => s.valorTotal);

            if (valorParc == 0)
                throw new InvalidOperationException("Os serviços prestados a esse contrato não possuem valor");

            if (diaVencimentoDemais == 0)
            {
                dataPrimeira = Contrato.dataInicio;
            }
            else
            {                
                if (isPrimeiraVigencia)
                    dataPrimeira = Contrato.dataInicio;
                else
                {
                    if (diaVencimentoDemais < Contrato.dataInicio.Day)
                    {
                        //Mês seguinte
                        var dataFinal = Contrato.dataInicio.AddMonths(1);
                        dataPrimeira = Convert.ToDateTime($"{diaVencimentoDemais}/{dataFinal.Month}/{dataFinal.Year}");
                    }
                    else
                    {
                        dataPrimeira = Convert.ToDateTime($"{diaVencimentoDemais}/{Contrato.dataInicio.Month}/{Contrato.dataInicio.Year}");
                    }                    
                }
            }

            for (int i = 0; i < Contrato.numParcelas; i++)
            {
                ContratoParcela parc = new ContratoParcela();
                parc.idContrato = Contrato.Id;
                parc.numParcela = i + 1;
                parc.valorParcela = valorParc;
                parc.dataVencimento = (i == 0) ? dataPrimeira : dataPrimeira.AddMonths(i);
                parc.situacao = 1;
                parc.comissao = valorParc * (Contrato.vendedor.percComis / 100);
                parc.ajuste = 0;

                new ContratoParcelaRepositorio(this._context, this._transaction).Create(parc);
            }
        }

        public Contrato Get(int id)
        {
            var command = CreateCommand("SELECT * FROM public.Contrato WHERE idContrato = @id");
            command.Parameters.AddWithValue("@id", id);
            Contrato contrato = null;

            using (var reader = command.ExecuteReader())
            {
                reader.Read();
                if (reader.HasRows)
                {
                    contrato = new Contrato
                    {
                        Id = Convert.ToInt32(reader["idContrato"]),
                        qntdExemplares = Convert.ToInt32(reader["qntdExemplares"]),
                        tipoDocumento = Convert.ToInt32(reader["tipoDocumento"]),
                        numParcelas = Convert.ToInt32(reader["numParcelas"]),
                        valorTotal = Convert.ToDecimal(reader["valorTotal"]),
                        juros = Convert.ToDecimal(reader["juros"]),
                        ajuste = Convert.ToDecimal(reader["ajuste"]),
                        observacoes = reader["observacoes"].ToString(),
                        ativo = Convert.ToBoolean(reader["ativo"]),
                        dataInicio = Convert.ToDateTime(reader["dataInicio"]),
                        periodoMeses = Convert.ToInt32(reader["periodoMeses"]),
                        dataTermino = Convert.ToDateTime(reader["dataTermino"]),
                        formaPagamento = new FormaPagamento() { Id = Convert.ToInt32(reader["fk_IdFormaPag"]) },
                        vendedor = new Vendedor() { Id = Convert.ToInt32(reader["fk_IdVendedor"]) },
                        usuario = new Usuario() { Id = Convert.ToInt32(reader["fk_IdUsuario"]) },
                        cliente = new Cliente() { idCliente = Convert.ToInt32(reader["fk_IdCliente"]) }
                    };
                }
                else
                {
                    return null;
                }
            }

            contrato.formaPagamento = new FormaPagamentoRepositorio(this._context, this._transaction).Get(contrato.formaPagamento.Id);
            contrato.vendedor = new VendedorRepositorio(this._context, this._transaction).Get(contrato.vendedor.Id);
            contrato.usuario = new UsuarioRepositorio(this._context, this._transaction).Get(contrato.usuario.Id);
            contrato.cliente = new ClienteRepositorio(this._context, this._transaction).Get(contrato.cliente.idCliente);

            return contrato;
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
                            ajuste = Convert.ToDecimal(reader["ajuste"]),
                            observacoes = reader["observacoes"].ToString(),
                            ativo = Convert.ToBoolean(reader["ativo"]),
                            dataInicio = Convert.ToDateTime(reader["dataInicio"]),
                            periodoMeses = Convert.ToInt32(reader["periodoMeses"]),
                            dataTermino = Convert.ToDateTime(reader["dataTermino"]),
                            formaPagamento = new FormaPagamento() { Id = Convert.ToInt32(reader["fk_IdFormaPag"]) },
                            vendedor = new Vendedor() { Id = Convert.ToInt32(reader["fk_IdVendedor"]) },
                            usuario = new Usuario() { Id = Convert.ToInt32(reader["fk_IdUsuario"]) },
                            cliente = new Cliente() { idCliente = Convert.ToInt32(reader["fk_IdCliente"]) }
                        });
                    }
                    else
                    {
                        return null;
                    }

                }
                reader.Close();
            }

            foreach(var contrato in result)
            {
                contrato.formaPagamento = new FormaPagamentoRepositorio(this._context, this._transaction).Get(contrato.formaPagamento.Id);
                contrato.vendedor = new VendedorRepositorio(this._context, this._transaction).Get(contrato.vendedor.Id);
                contrato.usuario = new UsuarioRepositorio(this._context, this._transaction).Get(contrato.usuario.Id);
                contrato.cliente = new ClienteRepositorio(this._context, this._transaction).Get(contrato.cliente.idCliente);
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
                        "valorTotal = @valorTotal, juros = @juros, ajuste = @ajuste, observacoes = @observacoes, ativo = @ativo, dataInicio = @dataInicio, " +
                        "periodoMeses = @periodoMeses, dataTermino = @dataTermino, fk_IdFormaPag = @fk_IdFormaPag, fk_IdVendedor = @fk_IdVendedor, " +
                        "fk_IdUsuario = @fk_IdUsuario, fk_IdCliente = @fk_IdCliente, fk_IdPessoa = @fk_IdPessoa WHERE idContrato = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@qntdExemplares", Contrato.qntdExemplares);
            command.Parameters.AddWithValue("@tipoDocumento", Contrato.tipoDocumento);
            command.Parameters.AddWithValue("@numParcelas", Contrato.numParcelas);
            command.Parameters.AddWithValue("@valorTotal", Contrato.valorTotal);
            command.Parameters.AddWithValue("@juros", Contrato.juros);
            command.Parameters.AddWithValue("@ajuste", Contrato.ajuste);
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
