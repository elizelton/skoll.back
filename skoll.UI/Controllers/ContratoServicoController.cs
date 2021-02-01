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
    public class ContratoServicoController : Controller
    {
        private IContratoServicoService _contService;
        private IAutenticacaoService _autenticacaoService;
        public ContratoServicoController(IContratoServicoService contService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contService = contService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContratoServicos([FromQuery] QueryString query)
        {
            return new { items = _contService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContratoServico")]
        public IActionResult GetContratoServico(int id)
        {
            var cont = _contService.Get(id);

            if (cont == null)
                return NotFound();
            else
                return new ObjectResult(cont);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idContrato}/contrato", Name = "GetContratoServicoContrato")]
        public IActionResult GetContratoServicoContrato(int idContrato)
        {
            var cont = _contService.GetByContrato(idContrato);

            if (cont == null)
                return NotFound();
            else
                return new ObjectResult(cont);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarContratoServico([FromBody] ContratoServico cont)
        {
            if (cont == null)
                return BadRequest();

            _contService.Create(cont);

            return CreatedAtRoute("GetContratoServico", new { id = cont.Id }, cont);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarContratoServico(int id, [FromBody] ContratoServico cont)
        {
            _contService.Update(cont);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverContratoServico(int id)
        {
            _contService.Remove(id);

            return new NoContentResult();
        }
    }
}