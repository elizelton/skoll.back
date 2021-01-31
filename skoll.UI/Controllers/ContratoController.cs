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
    public class ContratoController : Controller
    {
        private IContratoService _contService;
        private IAutenticacaoService _autenticacaoService;
        public ContratoController(IContratoService contService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contService = contService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContratos([FromQuery] QueryString query)
        {
            return new { items = _contService.GetAll() };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContrato")]
        public IActionResult GetContrato(int id)
        {
            var cont = _contService.Get(id);

            if (cont == null)
                return NotFound();
            else
                return new ObjectResult(cont);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarContrato([FromBody] Contrato cont)
        {
            if (cont == null)
                return BadRequest();

            _contService.Create(cont);

            return CreatedAtRoute("GetContrato", new { id = cont.Id }, cont);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarContrato(int id, [FromBody] Contrato cont)
        {
            _contService.Update(cont);

            return new NoContentResult();
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}/{diaVencimento}/{isPrimeira}/gerarparcelas")]
        public IActionResult GerarParcelasContrato(int id, int diaVencimento, bool isPrimeira)
        {
            var cont = _contService.Get(id);
            if (cont != null)
                _contService.GerarParcelas(cont, diaVencimento, isPrimeira);
            else
                return BadRequest();

            return new NoContentResult();
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}/{valorDif}/{vencimento}/parcelajuste")]
        public IActionResult GerarParcelaAjusteContrato(int id, decimal valorDif, DateTime vencimento)
        {
            _contService.GerarParcelaAjuste(id, valorDif, vencimento);

            return new NoContentResult();
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{novoCliente}/{multa}/cancelar")]
        public IActionResult GerarCancelamentoContrato(int idNovoCliente, decimal multa, [FromBody] Contrato cont)
        {
            _contService.CancelarContrato(cont, idNovoCliente, multa);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverContrato(int id)
        {
            _contService.Remove(id);

            return new NoContentResult();
        }
    }
}