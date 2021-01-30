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
    public class ContaPagarController : Controller
    {
        private IContaPagarService _contPgService;
        private IAutenticacaoService _autenticacaoService;
        public ContaPagarController(IContaPagarService contPgService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contPgService = contPgService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContas([FromQuery] QueryString query)
        {
            return new { items = _contPgService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetConta")]
        public IActionResult GetConta(int id)
        {
            var cont = _contPgService.Get(id);

            if (cont == null)
                return NotFound();
            else
                return new ObjectResult(cont);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarConta([FromBody] ContaPagar cont)
        {
            if (cont == null)
                return BadRequest();

            _contPgService.Create(cont);

            return CreatedAtRoute("GetContaParcelaPagamento", new { id = cont.Id }, cont);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarConta(int id, [FromBody] ContaPagar cont)
        {
            _contPgService.Update(cont);

            return new NoContentResult();
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}/gerarparcelas")]
        public IActionResult GerarParcelasConta(int id, [FromBody] ContaPagar cont)
        {
            _contPgService.GerarParcelas(cont);

            return new NoContentResult();
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}/{valorDif}/{vencimento}")]
        public IActionResult GerarParcelaAjusteConta(int id, decimal valorDif, DateTime vencimento)
        {
            _contPgService.GerarParcelaAjuste(id, valorDif, vencimento);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverConta(int id)
        {
            _contPgService.Remove(id);

            return new NoContentResult();
        }
    }
}