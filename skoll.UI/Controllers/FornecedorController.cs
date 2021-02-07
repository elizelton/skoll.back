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
    public class FornecedorController : Controller
    {
        private IFornecedorService _fornecedorService;
        private IAutenticacaoService _autenticacaoService;
        public FornecedorController(IFornecedorService fornecedorService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._fornecedorService = fornecedorService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetFornecedores([FromQuery] QueryString query)
        {
            return new { items = _fornecedorService.GetAll(query.search) };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("ativos", Name = "GetFornecedoresAtivos")]
        public object GetFornecedoresAtivos([FromQuery] QueryString query)
        {
            return new { items = _fornecedorService.GetAtivos() };
        }

        [HttpGet("{nome}/nome", Name = "GetFornecedorNome")]
        public IActionResult GetFornecedorNome(string nome)
        {
            var fornecedor = _fornecedorService.GetByNomeLike(nome);

            if (fornecedor == null)
                return NotFound();
            else
                return new ObjectResult(fornecedor);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetFornecedor")]
        public IActionResult GetFornecedor(int id)
        {
            var fornecedor = _fornecedorService.Get(id);

            if (fornecedor == null)
                return NotFound();
            else
                return new ObjectResult(fornecedor);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarFornecedor([FromBody] Fornecedor fornecedor)
        {
            if (fornecedor == null)
                return BadRequest();

            _fornecedorService.Create(fornecedor);

            return CreatedAtRoute("GetFornecedor", new { id = fornecedor.idFornecedor }, fornecedor);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarFornecedor(int id, [FromBody] Fornecedor fornecedor)
        {
            _fornecedorService.Update(fornecedor);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverFornecedor(int id)
        {
            _fornecedorService.Remove(id);

            return new NoContentResult();
        }
    }
}