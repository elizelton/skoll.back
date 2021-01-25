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
    public class VendedorController : Controller
    {
        private IVendedorService _vendedorService;
        private IAutenticacaoService _autenticacaoService;
        public VendedorController(IVendedorService vendedorService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._vendedorService = vendedorService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetVendedors([FromQuery] QueryString query)
        {
            return new { items = _vendedorService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetVendedor")]
        public IActionResult GetVendedor(int id)
        {
            var vendedor = _vendedorService.Get(id);

            if (vendedor == null)
                return NotFound();
            else
                return new ObjectResult(vendedor);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{nome}/nome", Name = "GetVendedorNome")]
        public IActionResult GetVendedorNome(string nome)
        {
            var vendedor = _vendedorService.GetByNomeLike(nome);

            if (vendedor == null)
                return NotFound();
            else
                return new ObjectResult(vendedor);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("ativos", Name = "GetVendedoresAtivos")]
        public IActionResult GetVendedoresAtivos()
        {
            var vendedor = _vendedorService.GetAtivos();

            if (vendedor == null)
                return NotFound();
            else
                return new ObjectResult(vendedor);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{codigo}/codigo", Name = "GetVendedorCodigo")]
        public IActionResult GetVendedorCodigo(string codigo)
        {
            var vendedor = _vendedorService.GetByCodigo(codigo);

            if (vendedor == null)
                return NotFound();
            else
                return new ObjectResult(vendedor);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarVendedor([FromBody] Vendedor vendedor)
        {
            if (vendedor == null)
                return BadRequest();

            _vendedorService.Create(vendedor);

            return CreatedAtRoute("GetVendedor", new { id = vendedor.Id }, vendedor);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarVendedor(int id, [FromBody] Vendedor vendedor)
        {
            _vendedorService.Update(vendedor);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverVendedor(int id)
        {
            _vendedorService.Remove(id);

            return new NoContentResult();
        }

    }
}