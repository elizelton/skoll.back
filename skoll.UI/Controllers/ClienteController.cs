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
    public class ClienteController : Controller
    {
        private IClienteService _clienteService;
        private IAutenticacaoService _autenticacaoService;
        public ClienteController(IClienteService clienteService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._clienteService = clienteService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetClientes([FromQuery] QueryString query)
        {
            return new { items = _clienteService.GetAll(query.search) };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("ativos", Name = "GetClientesAtivos")]
        public object GetClientesAtivos([FromQuery] QueryString query)
        {
            return new { items = _clienteService.GetAtivos() };
        }

        [HttpGet("{nome}/nome", Name = "GetClienteNome")]
        public IActionResult GetClienteNome(string nome)
        {
            var cliente = _clienteService.GetByNomeLike(nome);

            if (cliente == null)
                return NotFound();
            else
                return new ObjectResult(cliente);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetCliente")]
        public IActionResult GetCliente(int id)
        {
            var cliente = _clienteService.Get(id);

            if (cliente == null)
                return NotFound();
            else
                return new ObjectResult(cliente);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarCliente([FromBody] Cliente cliente)
        {
            if (cliente == null)
                return BadRequest();

            _clienteService.Create(cliente);

            return CreatedAtRoute("GetCliente", new { id = cliente.idCliente }, cliente);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarCliente(int id, [FromBody] Cliente cliente)
        {
            _clienteService.Update(cliente);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverCliente(int id)
        {
            _clienteService.Remove(id);

            return new NoContentResult();
        }
    }
}