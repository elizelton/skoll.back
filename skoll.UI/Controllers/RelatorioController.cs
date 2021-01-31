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
    }
}