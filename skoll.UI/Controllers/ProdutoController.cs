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
    public class ProdutoController : Controller
    {
        private IProdutoService _produtoService;
        private IAutenticacaoService _autenticacaoService;
        public ProdutoController(IProdutoService produtoService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._produtoService = produtoService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetProdutos([FromQuery] QueryString query)
        {
            return new { items = _produtoService.GetAll() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("ativos", Name = "GetProdutosAtivos")]
        public object GetProdutosAtivos([FromQuery] QueryString query)
        {
            return new { items = _produtoService.GetAtivos() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("comserv", Name = "GetProdutosAtivosComServ")]
        public object GetProdutosAtivosComServ([FromQuery] QueryString query)
        {
            return new { items = _produtoService.GetAtivosComServico() };
        }

        [HttpGet("{nome}/nome", Name = "GetProdutoNome")]
        public IActionResult GetProdutoNome(string nome)
        {
            var produto = _produtoService.GetByNomeLike(nome);

            if (produto == null)
                return NotFound();
            else
                return new ObjectResult(produto);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetProduto")]
        public IActionResult GetProduto(int id)
        {
            var produto = _produtoService.Get(id);

            if (produto == null)
                return NotFound();
            else
                return new ObjectResult(produto);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarProduto([FromBody] Produto produto)
        {
            if (produto == null)
                return BadRequest();

            _produtoService.Create(produto);

            return CreatedAtRoute("GetProduto", new { id = produto.Id }, produto);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarProduto(int id, [FromBody] Produto produto)
        {
            _produtoService.Update(produto);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverProduto(int id)
        {
            _produtoService.Remove(id);

            return new NoContentResult();
        }
    }
}