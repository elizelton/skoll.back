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
    public class ContratoParcelaController : Controller
    {
        private IContratoParcelaService _contParcService;
        private IAutenticacaoService _autenticacaoService;
        public ContratoParcelaController(IContratoParcelaService contParcService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._contParcService = contParcService;
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetContratoParcela")]
        public IActionResult GetContratoParcela(int id)
        {
            var contParc = _contParcService.Get(id);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{idcont}/Contrato", Name = "GetParcelaByContrato")]
        public IActionResult GetParcelaByContrato(int idcont)
        {
            var contParc = _contParcService.GetByContrato(idcont);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{venc}/vencimento", Name = "GetParcelaContratoByVencimento")]
        public IActionResult GetParcelaContratoByVencimento(DateTime venc)
        {
            var contParc = _contParcService.GetByVencimentoAte(venc);

            if (contParc == null)
                return NotFound();
            else
                return new ObjectResult(contParc);
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetContratoParcelas([FromQuery] QueryString query)
        {
            return new { items = _contParcService.GetAll() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("naopagastotalmente", Name = "GetContratoParcelasNaoPagas")]
        public object GetContratoParcelasNaoPagas([FromQuery] QueryString query)
        {
            return new { items = _contParcService.GetNaoPagasTotalmente() };
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet("pendentes", Name = "GetContratoParcelasPendentes")]
        public object GetContratoParcelasPendentes([FromQuery] QueryString query)
        {
            return new { items = _contParcService.GetPendentes() };
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarContratoParcela([FromBody] ContratoParcela contParc)
        {
            if (contParc == null)
                return BadRequest();

            _contParcService.Create(contParc);

            return CreatedAtRoute("GetContratoParcela", new { id = contParc.Id }, contParc);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarContratoParcela(int id, [FromBody] ContratoParcela contParc)
        {
            _contParcService.Update(contParc);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverContratoParcela(int id)
        {
            _contParcService.Remove(id);

            return new NoContentResult();
        }

    }
}