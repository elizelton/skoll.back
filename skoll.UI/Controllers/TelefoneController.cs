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
    public class TelefoneController : Controller
    {
        private ITelefoneService _telService;
        private IAutenticacaoService _autenticacaoService;
        public TelefoneController(ITelefoneService telService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._telService = telService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetTelefones([FromQuery] QueryString query)
        {
            return new { items = _telService.GetAll() };
        }

        [HttpGet("{idPessoa}/pessoa", Name = "GetTelefonesPessoa")]
        public IActionResult GetTelefonesPessoa(int idPessoa)
        {
            var tel = _telService.GetByPessoa(idPessoa);

            if (tel == null)
                return NotFound();
            else
                return new ObjectResult(tel);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetTelefone")]
        public IActionResult GetTelefone(int id)
        {
            var tel = _telService.Get(id);

            if (tel == null)
                return NotFound();
            else
                return new ObjectResult(tel);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarTelefone([FromBody] Telefone tel)
        {
            if (tel == null)
                return BadRequest();

            _telService.Create(tel);

            return CreatedAtRoute("GetTelefone", new { id = tel.Id }, tel);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarTelefone(int id, [FromBody] Telefone tel)
        {
            _telService.Update(tel);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverTelefone(int id)
        {
            _telService.Remove(id);

            return new NoContentResult();
        }
    }
}