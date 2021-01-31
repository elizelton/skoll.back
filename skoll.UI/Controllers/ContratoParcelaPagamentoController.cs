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
    public class ContratoParcelaPagamentoController : Controller
    {
        private IContratoParcelaPagamentoService _contParcPagService;
        private IAutenticacaoService _autenticacaoService;
        public ContratoParcelaPagamentoController(IContratoParcelaPagamentoService contParcPagService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contParcPagService = contParcPagService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContratosParcelaPagamento([FromQuery] QueryString query)
        {
            return new { items = _contParcPagService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContratoParcelaPagamento")]
        public IActionResult GetContratoParcelaPagamento(int id)
        {
            var contParcPag = _contParcPagService.Get(id);

            if (contParcPag == null)
                return NotFound();
            else
                return new ObjectResult(contParcPag);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idcontParc}/contratoparc", Name = "GetPagamentosByContrato")]
        public IActionResult GetPagamentosByContrato(int idcontParc)
        {
            var contParcPag = _contParcPagService.GetByContratoParcela(idcontParc);

            if (contParcPag == null)
                return NotFound();
            else
                return new ObjectResult(contParcPag);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarPagamentoContratoParcela([FromBody] ContratoParcelaPagamento contParcPag)
        {
            if (contParcPag == null)
                return BadRequest();

            _contParcPagService.Create(contParcPag);

            return CreatedAtRoute("GetContratoParcelaPagamento", new { id = contParcPag.Id }, contParcPag);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarPagamentoContratoParcela(int id, [FromBody] ContratoParcelaPagamento contParcPag)
        {
            _contParcPagService.Update(contParcPag);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverPagamentoContratoParcela(int id)
        {
            _contParcPagService.Remove(id);

            return new NoContentResult();
        }

    }
}