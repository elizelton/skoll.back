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
    public class PessoaController : Controller
    {
        private IPessoaService _pessoaService;
        private IAutenticacaoService _autenticacaoService;
        public PessoaController(IPessoaService pessoaService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._pessoaService = pessoaService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetPessoa([FromQuery] QueryString query)
        {
            return new { items = _pessoaService.GetAll() };
        }

        [HttpGet("{nome}/nome", Name = "GetPessoaNome")]
        public IActionResult GetPessoaNome(string nome)
        {
            var pessoa = _pessoaService.GetByNomeLike(nome);

            if (pessoa == null)
                return NotFound();
            else
                return new ObjectResult(pessoa);
        }

        [HttpGet("{nome}/cpfCnpj", Name = "GetPessoaCpfCnpj")]
        public IActionResult GetPessoaCpfCnpj(string nome)
        {
            var pessoa = _pessoaService.GetByNomeLike(nome);

            if (pessoa == null)
                return NotFound();
            else
                return new ObjectResult(pessoa);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetPessoa")]
        public IActionResult GetPessoa(int id)
        {
            var pessoa = _pessoaService.Get(id);

            if (pessoa == null)
                return NotFound();
            else
                return new ObjectResult(pessoa);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarPessoa([FromBody] Pessoa pessoa)
        {
            if (pessoa == null)
                return BadRequest();

            _pessoaService.Create(pessoa);

            return CreatedAtRoute("GetPessoa", new { id = pessoa.Id }, pessoa);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarPessoa(int id, [FromBody] Pessoa pessoa)
        {
            _pessoaService.Update(pessoa);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverPessoa(int id)
        {
            _pessoaService.Remove(id);

            return new NoContentResult();
        }
    }
}