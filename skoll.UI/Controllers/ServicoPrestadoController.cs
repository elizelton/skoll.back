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
    public class ServicoPrestadoController : Controller
    {
        private IServicoPrestadoService _servPrestService;
        private IAutenticacaoService _autenticacaoService;
        public ServicoPrestadoController(IServicoPrestadoService servPrestService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._servPrestService = servPrestService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetServicoPrestados([FromQuery] QueryString query)
        {
            return new { items = _servPrestService.GetAll() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("ativos", Name = "GetServicoPrestadosAtivos")]
        public object GetServicoPrestadosAtivos([FromQuery] QueryString query)
        {
            return new { items = _servPrestService.GetAtivos() };
        }

        [HttpGet("{nome}/nome", Name = "GetServicoPrestadoNome")]
        public IActionResult GetServicoPrestadoNome(string nome)
        {
            var servPrest = _servPrestService.GetByNomeLike(nome);

            if (servPrest == null)
                return NotFound();
            else
                return new ObjectResult(servPrest);
        }

        [HttpGet("{idProduto}/produto", Name = "GetServicoPrestadoProduto")]
        public IActionResult GetServicoPrestadoProduto(int idProduto)
        {
            var servPrest = _servPrestService.GetByProduto(idProduto);

            if (servPrest == null)
                return NotFound();
            else
                return new ObjectResult(servPrest);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetServicoPrestado")]
        public IActionResult GetServicoPrestado(int id)
        {
            var servPrest = _servPrestService.Get(id);

            if (servPrest == null)
                return NotFound();
            else
                return new ObjectResult(servPrest);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarServicoPrestado([FromBody] ServicoPrestado servPrest)
        {
            if (servPrest == null)
                return BadRequest();

            _servPrestService.Create(servPrest);

            return CreatedAtRoute("GetServicoPrestado", new { id = servPrest.Id }, servPrest);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarServicoPrestado(int id, [FromBody] ServicoPrestado servPrest)
        {
            _servPrestService.Update(servPrest);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverServicoPrestado(int id)
        {
            _servPrestService.Remove(id);

            return new NoContentResult();
        }
    }
}