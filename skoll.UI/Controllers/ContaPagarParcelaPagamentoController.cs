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
    public class ContaPagarParcelaPagamentoController : Controller
    {
        private IContaPagarParcelaPagamentoService _contPgParcPagService;
        private IAutenticacaoService _autenticacaoService;
        public ContaPagarParcelaPagamentoController(IContaPagarParcelaPagamentoService contPgParcPagService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contPgParcPagService = contPgParcPagService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContasParcelaPagamento([FromQuery] QueryString query)
        {
            return new { items = _contPgParcPagService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContaParcelaPagamento")]
        public IActionResult GetContaParcelaPagamento(int id)
        {
            var contParcPag = _contPgParcPagService.Get(id);

            if (contParcPag == null)
                return NotFound();
            else
                return new ObjectResult(contParcPag);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idContPgParc}/contapagarparc", Name = "GetPagamentosByContaPagar")]
        public IActionResult GetPagamentosByContaPagar(int idContPgParc)
        {
            var contParcPag = _contPgParcPagService.GetByContaPagarParcela(idContPgParc);

            if (contParcPag == null)
                return NotFound();
            else
                return new ObjectResult(contParcPag);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarPagamentoContaParcela([FromBody] ContaPagarParcelaPagamento contParcPag)
        {
            if (contParcPag == null)
                return BadRequest();

            _contPgParcPagService.Create(contParcPag);

            return CreatedAtRoute("GetContaParcelaPagamento", new { id = contParcPag.Id }, contParcPag);
        }
        
        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarPagamentoContaParcela(int id, [FromBody] ContaPagarParcelaPagamento contParcPag)
        {
            _contPgParcPagService.Update(contParcPag);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverPagamentoContaParcela(int id)
        {
            _contPgParcPagService.Remove(id);

            return new NoContentResult();
        }

    }
}