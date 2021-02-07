using Npgsql;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
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

        public void CancelarContrato(Contrato contrato, int novoCliente)
        {
            int idContrato = contrato.Id;
            if (novoCliente > 0)
            {
                var cliente = new ClienteRepositorio(this._context, this._transaction).Get(novoCliente);
                if (cliente.Id == 0)
                    throw new AppError("Não foi possível gerar um novo contrato - Cliente inválido");
                var newContrato = contrato;
                newContrato.Id = 0;
                newContrato.cliente.Id = cliente.Id;
                newContrato.cliente.idCliente = cliente.idCliente;

                Create(newContrato);

                if (newContrato.Id == 0)
                    throw new AppError("Não foi possível gerar um novo contrato");

                var parcelas = contrato.parcelas;

                foreach(var parc in parcelas)
                {
                    parc.Id = 0;
                    parc.idContrato = newContrato.Id;

                    new ContratoParcelaRepositorio(this._context, this._transaction).Create(parc);

                    if (parc.Id == 0)
                        throw new AppError("Não foi possível gerar as parcelas do novo contrato");

                    foreach (var pgto in parc.pagamentos)
                    {
                        pgto.Id = 0;
                        pgto.idContratoParcela = parc.Id;

                        new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).Create(pgto);

                        if (pgto.Id == 0)
                            throw new AppError("Não foi possível gerar os pagamentos das parcelas do novo contrato");
                    }
                }
            }

            var query = "UPDATE public.Contrato SET tipoDocumento = @tipoDocumento WHERE idContrato = @id";
            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@tipoDocumento", 3);
            command.Parameters.AddWithValue("@id", idContrato);

            command.ExecuteNonQuery();
        }

        public void Create(Contrato Contrato)
        {
            if (Contrato.cliente.Id == 0)
                Contrato.cliente.Id = new ClienteRepositorio(this._context, this._transaction).GetIdPessoa(Contrato.cliente.idCliente);

            var query = "INSERT INTO public.Contrato(qntdExemplares, tipoDocumento, numParcelas, valorTotal, juros,  observacoes, ativo, dataInicio, periodoMeses, dataTermino, fk_IdFormaPag, fk_IdVendedor, fk_IdUsuario, fk_IdCliente, fk_IdPessoa) " +
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

        public void GerarParcelas(Contrato Contrato, int diaVencimentoDemais, bool isPrimeiraVigencia)
        {
            var parcelasContrato = new ContratoParcelaRepositorio(this._context, this._transaction).GetByContrato(Contrato.Id).ToList();
            if (parcelasContrato.Count > 0)
            {
                foreach (var parc in parcelasContrato)
                    new ContratoParcelaRepositorio(this._context, this._transaction).Remove(parc.Id);
            }

            var servicos = (List<ContratoServico>)new ContratoServicoRepositorio(this._context, this._transaction).GetByContrato(Contrato.Id);
            if (servicos == null || servicos.Count == 0)
                return;
            else if (Contrato.numParcelas == 0)
                throw new AppError("É necessário informar o número de parcelas");

            DateTime dataPrimeira = DateTime.Today;
            DateTime dataSegunda = DateTime.Today;
            decimal valorParc = servicos.Sum(s => s.valorTotal) / Contrato.numParcelas;

            if (valorParc == 0)
                throw new AppError("Os serviços prestados a esse contrato não possuem valor");

            valorParc = Math.Round(valorParc, 2);

            if (diaVencimentoDemais == 0)
            {
                dataPrimeira = Contrato.dataInicio;
            }
            else
            {
                if (isPrimeiraVigencia)
                {
                    dataPrimeira = Contrato.dataInicio;
                    if (diaVencimentoDemais != 0)
                    {
                        if (diaVencimentoDemais < Contrato.dataInicio.Day)
                        {
                            //Mês seguinte
                            var dataFinal = Contrato.dataInicio.AddMonths(1);
                            dataSegunda = Convert.ToDateTime($"{diaVencimentoDemais}/{dataFinal.Month}/{dataFinal.Year}");
                        }
                        else
                        {
                            dataSegunda = Convert.ToDateTime($"{diaVencimentoDemais}/{Contrato.dataInicio.Month}/{Contrato.dataInicio.Year}");
                        }
                    }
                }
                else
                {
                    if (diaVencimentoDemais < Contrato.dataInicio.Day)
                    {
                        //Mês seguinte
                        var dataFinal = Contrato.dataInicio.AddMonths(1);
                        dataPrimeira = Convert.ToDateTime($"{diaVencimentoDemais}/{dataFinal.Month}/{dataFinal.Year}");
                        dataSegunda = dataPrimeira;
                    }
                    else
                    {
                        dataPrimeira = Convert.ToDateTime($"{diaVencimentoDemais}/{Contrato.dataInicio.Month}/{Contrato.dataInicio.Year}");
                        dataSegunda = dataPrimeira;
                    }
                }
            }

            List<ContratoParcela> parcelas = new List<ContratoParcela>();

            for (int i = 0; i < Contrato.numParcelas; i++)
            {
                ContratoParcela parc = new ContratoParcela();
                parc.idContrato = Contrato.Id;
                parc.numParcela = i + 1;
                parc.valorParcela = valorParc;
                parc.dataVencimento = (i == 0) ? dataPrimeira : (diaVencimentoDemais == 0) ? dataPrimeira.AddMonths(i) : dataSegunda.AddMonths(i);
                parc.situacao = 1;
                //parc.comissao = valorParc * (Contrato.vendedor.percComis / 100);
                parc.comissao = 0;

                parcelas.Add(parc);              
            }

            var soma = parcelas.Sum(p => p.valorParcela);
            decimal dif = 0;
            dif = servicos.Sum(s => s.valorTotal) - soma;

            if (dif > 0)
                parcelas.Last().valorParcela = parcelas.Last().valorParcela + dif;

            foreach (var parc in parcelas)
            {
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
                contrato.nomeVendedor = new VendedorRepositorio(this._context, this._transaction).Get(contrato.vendedor.Id).nome;
                contrato.nomeCliente = new ClienteRepositorio(this._context, this._transaction).Get(contrato.cliente.idCliente).nome;
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
            if (Contrato.cliente.Id == 0)
                Contrato.cliente.Id = new ClienteRepositorio(this._context, this._transaction).GetIdPessoa(Contrato.cliente.idCliente);

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
