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
    public class PagamentoComissaoController : Controller
    {
        private IPagamentoComissaoService _pgtoComissService;
        private IAutenticacaoService _autenticacaoService;
        public PagamentoComissaoController(IPagamentoComissaoService pgtoComissService,
                                            IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._pgtoComissService = pgtoComissService;
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idVendedor}/{inicio}/{fim}/{filtroPag}", Name = "GetComissoesByFiltro")]
        public object GetComissoesByFiltro(int idVendedor, DateTime inicio, DateTime fim, int filtroPag)
        {
            return new { items = _pgtoComissService.ComissoesPagar(idVendedor, inicio, fim, filtroPag) };
        }

        [HttpPut("{idVendedor}/{filtroPag}")]
        public IActionResult PagarComissao(int idVendedor, int filtroPag, [FromBody] List<int> contratos)
        {
            _pgtoComissService.PagarComissao(idVendedor, contratos, filtroPag);

            return new NoContentResult();
        }

    }
}