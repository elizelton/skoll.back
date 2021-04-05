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
    public class UsuarioController : Controller
    {
        private IUsuarioService _usuarioService;
        private IAutenticacaoService _autenticacaoService;
        public UsuarioController(IUsuarioService usuarioService,
                                 IAutenticacaoService autenticacaoService)
        {
            this._autenticacaoService = autenticacaoService;
            this._usuarioService = usuarioService;
        }

        // GET: api/Usuario     
        //[Authorize("Bearer")]
        [HttpGet]
        public object GetUsuarios([FromQuery] QueryString query)
        {
            return new { items = _usuarioService.GetAll(query.search) };
        }

        // GET: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetUsuario")]
        public IActionResult GetUsuario(int id)
        {
            var usuario = _usuarioService.Get(id);

            if (usuario == null)
                return NotFound();
            else
                return new ObjectResult(usuario);
        }

        // POST: api/Usuario
        //[Authorize("Bearer")]
        [HttpPost]
        public IActionResult CadastrarUsuario([FromBody] Usuario user)
        {
            if (user == null)
                return BadRequest();

            _usuarioService.Create(user);

            return CreatedAtRoute("GetUsuario", new { id = user.Id }, user);
        }

        // PUT: api/Usuario/5
        //[Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult EditarUsuario(int id, [FromBody] Usuario user)
        {
            _usuarioService.Update(user);

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        //[Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult RemoverUsuario(int id)
        {
            _usuarioService.Remove(id);

            return new NoContentResult();
        }

        [HttpDelete]
        public IActionResult RemoverUsuario(List<Usuario> idList)
        {
            _usuarioService.Remove(idList);

            return new NoContentResult();
        }

        [HttpPost("/autenticacao")]
        public IActionResult AutenticarUSuario([FromBody] Usuario user)
        {
            return Ok(_autenticacaoService.Autenticar(user));
        }

        [HttpPut("/esquecisenha")]
        public IActionResult EsqueciSenha([FromBody] Usuario user)
        {
            if (!string.IsNullOrEmpty(user.userName))
                user = _usuarioService.GetByUserName(user.userName);
            else if (!string.IsNullOrEmpty(user.email))
                user = _usuarioService.GetByEmail(user.email);

            _autenticacaoService.EsqueciMinhaSenha(user);
            
            return new NoContentResult();
        }
    }
}