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
    public class ContaPagarParcelaController : Controller
    {
        private IContaPagarParcelaService _contPgParcService;
        private IAutenticacaoService _autenticacaoService;
        public ContaPagarParcelaController(IContaPagarParcelaService contPgParcService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contPgParcService = contPgParcService;
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContaParcela")]
        public IActionResult GetContaParcela(int id)
        {
            var contParc = _contPgParcService.Get(id);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idContPg}/contapagar", Name = "GetParcelaByContaPagar")]
        public IActionResult GetParcelaByContaPagar(int idContPg)
        {
            var contParc = _contPgParcService.GetByContaPagar(idContPg);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{venc}/vencimento", Name = "GetParcelaByVencimento")]
        public IActionResult GetParcelaByVencimento(DateTime venc)
        {
            var contParc = _contPgParcService.GetByVencimentoAte(venc);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContaParcelas([FromQuery] QueryString query)
        {
            return new { items = _contPgParcService.GetAll() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("naopagastotalmente", Name = "GetContaParcelasNaoPagas")]
        public object GetContaParcelasNaoPagas([FromQuery] QueryString query)
        {
            return new { items = _contPgParcService.GetNaoPagasTotalmente() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("pendentes", Name = "GetContaParcelasPendentes")]
        public object GetContaParcelasPendentes([FromQuery] QueryString query)
        {
            return new { items = _contPgParcService.GetPendentes() };
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarContaParcela([FromBody] ContaPagarParcela contParc)
        {
            if (contParc == null)
                return BadRequest();

            _contPgParcService.Create(contParc);

            return CreatedAtRoute("GetContaParcela", new { id = contParc.Id }, contParc);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarContaParcela(int id, [FromBody] ContaPagarParcela contParc)
        {
            _contPgParcService.Update(contParc);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverContaParcela(int id)
        {
            _contPgParcService.Remove(id);

            return new NoContentResult();
        }

    }
}