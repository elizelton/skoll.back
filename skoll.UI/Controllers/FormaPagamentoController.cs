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
    public class FormaPagamentoController : Controller
    {
        private IFormaPagamentoService _formaPagService;
        private IAutenticacaoService _autenticacaoService;
        public FormaPagamentoController(IFormaPagamentoService formaPagService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._formaPagService = formaPagService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetFormasPagamento([FromQuery] QueryString query)
        {
            return new { items = _formaPagService.GetAll(query.search) };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("ativas", Name = "GetFormasPagamentoAtivas")]
        public IActionResult GetFormasPagamentoAtivas()
        {
            var cidade = _formaPagService.GetAtivos();

            if (cidade == null)
                return NotFound();
            else
                return new ObjectResult(cidade);
        }


        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetFormaPagamento")]
        public IActionResult GetFormaPagamento(int id)
        {
            var formaPag = _formaPagService.Get(id);

            if (formaPag == null)
                return NotFound();
            else
                return new ObjectResult(formaPag);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{nome}/nome", Name = "GetFormasPagamentoNome")]
        public IActionResult GetFormasPagamentoNome(string nome)
        {
            var formaPag = _formaPagService.GetByNomeLike(nome);

            if (formaPag == null)
                return NotFound();
            else
                return new ObjectResult(formaPag);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarForma([FromBody] FormaPagamento formaPag)
        {
            if (formaPag == null)
                return BadRequest();

            _formaPagService.Create(formaPag);

            return CreatedAtRoute("GetFormaPagamento", new { id = formaPag.Id }, formaPag);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarForma(int id, [FromBody] FormaPagamento formaPag)
        {
            _formaPagService.Update(formaPag);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverForma(int id)
        {
            _formaPagService.Remove(id);

            return new NoContentResult();
        }

    }
}