using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using skoll.Application.Common.Interfaces;
using skoll.Domain.Entities;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace skoll.ui.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : Controller
    {
        private IUnitOfWork uow;

        private readonly MD5 md5 = new MD5CryptoServiceProvider();
        public UsuarioController(IUnitOfWork unitOfWork)
        {
            uow = unitOfWork;
        }

        // GET: api/Usuario     
        [Authorize("Bearer")]
        [HttpGet]
        public IEnumerable<Usuario> Get()
        {
            return uow.UsuarioRepositorio.GetAll();
        }

        // GET: api/Usuario/5
        [Authorize("Bearer")]
        [HttpGet("{id}", Name = "GetUsuario")]
        public IActionResult Get(int id)
        {
            var usuario = uow.UsuarioRepositorio.Get(u => u.Id == id);

            if (usuario == null)
                return NotFound();
            else
                return new ObjectResult(usuario);
        }

        // POST: api/Usuario
        [Authorize("Bearer")]
        [HttpPost]
        public IActionResult Post([FromBody] Usuario user)
        {
            if (user == null)
                return BadRequest();

            if (uow.UsuarioRepositorio.Get(u => u.Login == user.Login) != null)
            {
                return new BadRequestObjectResult($"Login: **{ user.Login }** já cadastrado!");
            }

            user.Senha = md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(user.Senha)).ToString();

            uow.UsuarioRepositorio.Adicionar(user);
            uow.Commit();


            return CreatedAtRoute("GetUsuario", new { id = user.Id }, user);
        }

        // PUT: api/Usuario/5
        [Authorize("Bearer")]
        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody] Usuario user)
        {
            if (user == null || user.Id != id)
                return BadRequest();

            var usuario = uow.UsuarioRepositorio.Get(u => u.Id == id);

            if (usuario == null)
                return BadRequest();

            usuario.Login = user.Login;
            usuario.Nome = user.Nome;
            if (!String.IsNullOrEmpty(user.Senha))
                usuario.Senha = md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(user.Senha)).ToString();
            usuario.Situacao = user.Situacao;

            uow.UsuarioRepositorio.Atualizar(usuario);
            uow.Commit();

            return new NoContentResult();
        }

        // DELETE: api/ApiWithActions/5
        [Authorize("Bearer")]
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var usuario = uow.UsuarioRepositorio.Get(u => u.Id == id);

            if (usuario == null)
                return NotFound();

            uow.UsuarioRepositorio.Deletar(usuario);
            uow.Commit();

            return new NoContentResult();
        }
    }
}