using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using skoll.Application.Common.Interfaces;
using skoll.Application.Common.Model;
using skoll.Application.Common.Services;
using skoll.Domain.Entities;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace skoll.ui.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private IUnitOfWork uow;
        public AuthController(IUnitOfWork unitOfWork,
            [FromServices] SigningConfigurations signingConfigurations,
            [FromServices] TokenConfigurations tokenConfigurations)
        {
            uow = unitOfWork;
        }
        [AllowAnonymous]
        [HttpPost]
        public object Post(
             [FromBody] Usuario usuario,
             [FromServices] SigningConfigurations signingConfigurations,
             [FromServices] TokenConfigurations tokenConfigurations)
        {
            if (usuario == null || String.IsNullOrEmpty(usuario.Login) || String.IsNullOrEmpty(usuario.Senha))
                return BadRequest();

            var usuarioAutenticado = uow.UsuarioRepositorio.Get(u => u.Login == usuario.Login
                                                                  && u.Senha == usuario.Senha
                                                                  && u.Situacao == true);

            if (usuarioAutenticado != null)
            {
                ClaimsIdentity identity = new ClaimsIdentity(
                    new GenericIdentity(usuario.Login, "Login"),
                    new[] {
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")),
                        new Claim(JwtRegisteredClaimNames.UniqueName, usuario.Login)
                    }
                );

                DateTime dataCriacao = DateTime.Now;
                DateTime dataExpiracao = dataCriacao +
                    TimeSpan.FromHours(tokenConfigurations.Hours);

                var handler = new JwtSecurityTokenHandler();
                var securityToken = handler.CreateToken(new SecurityTokenDescriptor
                {
                    Issuer = tokenConfigurations.Issuer,
                    Audience = tokenConfigurations.Audience,
                    SigningCredentials = signingConfigurations.SigningCredentials,
                    Subject = identity,
                    NotBefore = dataCriacao,
                    Expires = dataExpiracao
                });
                var token = handler.WriteToken(securityToken);

                return new
                {
                    login = usuarioAutenticado.Login,
                    nome = usuarioAutenticado.Nome,
                    autenticado = true,
                    accessToken = token,
                    sessaoExpira = dataExpiracao
                };
            }
            else
            {
                return new
                {
                    autenticado = false,
                };
            }
        }
    }
}
