﻿using Npgsql;
using skoll.Dominio.Entities;
using skoll.Dominio.Exceptions;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace skoll.Infraestrutura.Repositorios
{
    public class PagamentoComissaoRepositorio : RepositorioBase, IPagamentoComissaoRepositorio
    {
        public PagamentoComissaoRepositorio(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }

        public List<PagamentoComissao> ComissoesPagar(int idVendedor, DateTime inicio, DateTime fim, int filtroPag)
        {
            if (filtroPag < 1 || filtroPag > 2)
                throw new AppError("Filtro inválido");

            var result = new List<PagamentoComissao>();
            string query = string.Empty;
            if (filtroPag == 1)
            {
                query = "select t1.nome as vendNome, t2.idContrato, t3.nome as nomeCli, (t2.valortotal * (t1.perccomis/100)) as valor, t1.perccomis from vendedor t1  " +
                        "inner join contrato t2 on t2.fk_idVendedor = t1.idVendedor inner join pessoa t3 on t3.idPessoa = t2.fk_idPessoa " +
                        "where t1.idVendedor = @id and t1.perccomis > 0 and exists (select 1 from contratoparcela where fk_idcontrato = t2.idContrato) " +
                        "and not exists (select 1 from contratoparcela where fk_idcontrato = t2.idContrato and comissao > 0) " +
                        "and t2.tipodocumento <> 3 and t2.ativo = true  " +
                        "and not exists (select 1 from contratoparcelapagamento where fk_idcontratoparcela in (select idcontratoparcela  " +
                        "               from contratoparcela where fk_idcontrato = t2.idContrato) and comissao > 0) " +
                        "and t2.datainicio >= @ini and t2.datainicio <= @fim order by t2.idContrato ";
            }
            else if (filtroPag == 2)
            {
                query = "select t1.nome as vendNome, t2.idContrato, t3.nome as nomeCli, (sum(t5.valorpagamento) * (t1.percComis/100)) as valor, t1.perccomis from vendedor t1 " +
                        "inner join contrato t2 on t2.fk_idVendedor = t1.idVendedor inner join pessoa t3 on t3.idPessoa = t2.fk_idPessoa " +
                        "inner join contratoparcela t4 on t4.fk_idcontrato = t2.idContrato inner join contratoparcelapagamento t5 on t5.fk_idContratoParcela = t4.idContratoParcela " +
                        "where t1.idVendedor = @id and t1.perccomis > 0 and exists (select 1 from contratoparcela where fk_idcontrato = t2.idContrato) " +
                        "and not exists (select 1 from contratoparcela where fk_idcontrato = t2.idContrato and comissao > 0) " +
                        "and t2.tipodocumento <> 3 and t2.ativo = true " +
                        "and t5.datapagamento >= @ini and t5.datapagamento <= @fim and t4.situacao = 3 and t5.comissao = 0 " +
                        "group by t1.nome, t2.idContrato, t3.nome, t1.perccomis, t4.fk_idContrato ";
            }

            var command = CreateCommand(query);

            command.Parameters.AddWithValue("@ini", inicio);
            command.Parameters.AddWithValue("@fim", fim);
            command.Parameters.AddWithValue("@id", idVendedor);

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        result.Add(new PagamentoComissao
                        {
                            cliente = reader["nomeCli"].ToString(),
                            idContrato = Convert.ToInt32(reader["idContrato"]),
                            valorComissao = Convert.ToDecimal(reader["valor"]),
                            vendedor = reader["vendNome"].ToString(),
                            percComis = Convert.ToDecimal(reader["perccomis"]),
                            filtro = filtroPag
                        });
                    }
                }
                reader.Close();
            }

            return result.OrderBy(r => r.cliente).ToList<PagamentoComissao>();
        }

        public void PagarComissao(int idVendedor, List<int> contratos, int filtroPag, DateTime inicio, DateTime fim)
        {
            var vendedor = new VendedorRepositorio(this._context, this._transaction).Get(idVendedor);
            if (filtroPag == 1)
            {
                foreach (var cont in contratos)
                {
                    var parcelas = new ContratoParcelaRepositorio(this._context, this._transaction).GetByContrato(cont);
                    foreach (var parc in parcelas)
                    {
                        parc.comissao = parc.valorParcela * (vendedor.percComis / 100);
                        new ContratoParcelaRepositorio(this._context, this._transaction).Update(parc);
                    }
                }
            }
            else if (filtroPag == 2)
            {
                foreach (var cont in contratos)
                {
                    var parcelas = new ContratoParcelaRepositorio(this._context, this._transaction).GetByContrato(cont);
                    parcelas = parcelas.Where(p => p.situacao == 3);
                    foreach (var parc in parcelas)
                    {
                        var pagamentos = new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).GetByContratoParcela(parc.Id);
                        pagamentos = pagamentos.Where(e => e.comissao == 0 && e.valorPagamento > 0 && e.dataPagamento >= inicio && e.dataPagamento <= fim).ToList();
                        foreach (var pgto in pagamentos)
                        {
                            pgto.comissao = pgto.valorPagamento * (vendedor.percComis / 100);
                            new ContratoParcelaPagamentoRepositorio(this._context, this._transaction).Update(pgto);
                        }
                    }
                }
            }
            else
                throw new AppError("Filtro inválido");
        }
    }        
}
