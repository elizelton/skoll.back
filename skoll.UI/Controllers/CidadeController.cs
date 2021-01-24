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
    public class CidadeController : Controller
    {
        private ICidadeService _cidadeService;
        private IAutenticacaoService _autenticacaoService;
        public CidadeController(ICidadeService cidadeService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._cidadeService = cidadeService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetCidades([FromQuery] QueryString query)
        {
            return new { items = _cidadeService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetCidade")]
        public IActionResult GetCidade(int id)
        {
            var cidade = _cidadeService.Get(id);

            if (cidade == null)
                return NotFound();
            else
                return new ObjectResult(cidade);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{estado}/estado", Name = "GetCidadeEstado")]
        public IActionResult GetCidadeEstado(string estado)
        {
            var cidade = _cidadeService.GetByEstado(estado);

            if (cidade == null)
                return NotFound();
            else
                return new ObjectResult(cidade);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{nome}/nome", Name = "GetCidadeNome")]
        public IActionResult GetCidadeNome(string nome)
        {
            var cidade = _cidadeService.GetByNome(nome);

            if (cidade == null)
                return NotFound();
            else
                return new ObjectResult(cidade);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{nome}/{estado}", Name = "GetCidadeNomeEstado")]
        public IActionResult GetCidadeNomeEstado(string nome, string estado)
        {
            var cidade = _cidadeService.GetByNomeEstado(nome, estado);

            if (cidade == null)
                return NotFound();
            else
                return new ObjectResult(cidade);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarCidade([FromBody] Cidade cidade)
        {
            if (cidade == null)
                return BadRequest();

            _cidadeService.Create(cidade);

            return CreatedAtRoute("GetCidade", new { id = cidade.Id }, cidade);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarCidade(int id, [FromBody] Cidade cidade)
        {
            _cidadeService.Update(cidade);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverCidade(int id)
        {
            _cidadeService.Remove(id);

            return new NoContentResult();
        }

    }
}