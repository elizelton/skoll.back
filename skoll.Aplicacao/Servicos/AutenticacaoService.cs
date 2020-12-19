using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using skoll.Aplicacao.Interfaces;
using skoll.Aplicacao.Common.Model;
using skoll.Aplicacao.Common.Services;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using static skoll.Aplicacao.Util.StringUtil;
using skoll.Dominio.Exceptions;

namespace skoll.Aplicacao.Servicos
{
    public class AutenticacaoService : IAutenticacaoService
    {
        private IUnitOfWorkFactory _unitOfWork;
        private SigningConfigurations _signingConfigurations;
        private TokenConfigurations _tokenConfigurations;
        public AutenticacaoService(IUnitOfWorkFactory unitOfWorkFactory,
            [FromServices] SigningConfigurations signingConfigurations,
            [FromServices] TokenConfigurations tokenConfigurations)
        {
            _unitOfWork = unitOfWorkFactory;
            _signingConfigurations = signingConfigurations;
            _tokenConfigurations = tokenConfigurations;
        }

        public object Autenticar(Usuario usuario)
        {
            if (!String.IsNullOrEmpty(usuario.UserName) && !String.IsNullOrEmpty(usuario.Senha))
            {
                using (var context = _unitOfWork.Create())
                {
                    var usuarioBanco = context.Repositorios.UsuarioRepositorio.GetByUserNameESenha(usuario.UserName, GetSHA1(usuario.Senha));

                    if (usuarioBanco != null)
                    {
                        ClaimsIdentity identity = new ClaimsIdentity(
                           new GenericIdentity(usuario.UserName, "UserName"),
                           new[] {
                            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")),
                            new Claim(JwtRegisteredClaimNames.UniqueName, usuario.UserName)
                           }
                        );

                        DateTime dataCriacao = DateTime.Now;
                        DateTime dataExpiracao = dataCriacao +
                            TimeSpan.FromHours(_tokenConfigurations.Hours);

                        var handler = new JwtSecurityTokenHandler();

                        var securityToken = handler.CreateToken(new SecurityTokenDescriptor
                        {
                            Issuer = _tokenConfigurations.Issuer,
                            Audience = _tokenConfigurations.Audience,
                            SigningCredentials = _signingConfigurations.SigningCredentials,
                            Subject = identity,
                            NotBefore = dataCriacao,
                            Expires = dataExpiracao
                        });

                        var token = handler.WriteToken(securityToken);

                        return new
                        {
                            UserName = usuarioBanco.UserName,
                            nome = usuarioBanco.Nome,
                            autenticado = true,
                            accessToken = token,
                            sessaoExpira = dataExpiracao
                        };
                    }
                }
            }

            throw new AppError("Usuário ou Senha", 401);

        }
    }
}
