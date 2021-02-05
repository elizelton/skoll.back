using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using skoll.Aplicacao.Interfaces;
using skoll.Dominio.Entities;
using skoll.UI.Controllers.Util;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace skoll.ui.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RelatorioController : Controller
    {
        private IRelatorioService _relatorioService;
        private IAutenticacaoService _autenticacaoService;
        public RelatorioController(IRelatorioService relatorioService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._relatorioService = relatorioService;
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{estado}/estado", Name = "RelCidadeEstado")]
        public FileResult RelCidadeEstado(string estado)
        {
            var rel = _relatorioService.RelCidadesEstado(estado);
            var file  = File(rel.GetOutput().GetBuffer(), "application/pdf", "Relatorio.pdf");

            return file;
        }

        [HttpGet("{dataAte}/parcelapagar", Name = "RelParcelasPagar")]
        public FileResult RelParcelasPagar(DateTime dataAte)
        {
            var rel = _relatorioService.RelParcelasPagar(dataAte);
            var file = File(rel.GetOutput().GetBuffer(), "application/pdf", "Relatorio.pdf");

            return file;
        }

        [HttpGet("{dataAte}/parcelavencer", Name = "RelParcelasVencer")]
        public FileResult RelParcelasVencer(DateTime dataAte)
        {
            var rel = _relatorioService.RelParcelasVencer(dataAte);
            var file = File(rel.GetOutput().GetBuffer(), "application/pdf", "Relatorio.pdf");

            return file;
        }

        [HttpGet("{idcliente}/{inicio}/{fim}/contratocliente", Name = "RelContratosCliente")]
        public FileResult RelContratosCliente(int idcliente, DateTime inicio, DateTime fim)
        {
            var rel = _relatorioService.RelContratosPorCliente(idcliente, inicio, fim);
            var file = File(rel.GetOutput().GetBuffer(), "application/pdf", "Relatorio.pdf");

            return file;
        }

        [HttpGet("{mes}/{ano}/contratomes", Name = "RelContratoMes")]
        public FileResult RelContratoMes(int mes, int ano)
        {
            var rel = _relatorioService.RelContratosMes(mes, ano);
            var file = File(rel.GetOutput().GetBuffer(), "application/pdf", "Relatorio.pdf");

            return file;
        }
    }
}