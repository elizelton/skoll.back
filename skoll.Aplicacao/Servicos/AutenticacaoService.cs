using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using skoll.Aplicacao.Interfaces;
using skoll.Aplicacao.Common.Model;
using skoll.Aplicacao.Common.Services;
using skoll.Dominio.Entities;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Principal;
using static skoll.Aplicacao.Util.StringUtil;
using skoll.Dominio.Exceptions;
using System.Net.Mail;
using System.Net;
using System.Text.RegularExpressions;
using System.Configuration;
using System.Text;

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
            if (!String.IsNullOrEmpty(usuario.userName) && !String.IsNullOrEmpty(usuario.senha))
            {
                using (var context = _unitOfWork.Create())
                {
                    var usuarioBanco = context.Repositorios.UsuarioRepositorio.GetByUserNameESenha(usuario.userName, GetSHA1(usuario.senha));

                    if (usuarioBanco != null)
                    {
                        ClaimsIdentity identity = new ClaimsIdentity(
                           new GenericIdentity(usuario.userName, "UserName"),
                           new[] {
                            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")),
                            new Claim(JwtRegisteredClaimNames.UniqueName, usuario.userName)
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
                            UserName = usuarioBanco.userName,
                            nome = usuarioBanco.nome,
                            autenticado = true,
                            accessToken = token,
                            sessaoExpira = dataExpiracao
                        };
                    }
                }
            }

            throw new AppError("Usuário e/ou Senha inválidos", 401);

        }

        /// <summary>
        /// Transmite uma mensagem de email sem anexos
        /// </summary>
        /// <param name="tipoGet">tipoGet (1 = email / 2 = nomeUsuario)</param>
        /// <returns>Status da mensagem</returns>
        public string EsqueciMinhaSenha(Usuario usuario)
        {
            if (string.IsNullOrEmpty(usuario.email))
            {
                throw new AppError("Email do usuário não é válido. Favor entrar em contato com o administrador do sistema", 401);
            }

            System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
            client.Host = "smtp.gmail.com";
            client.EnableSsl = true;
            client.Port = 587;
            //var email = _configuration.GetConnectionString("Login");
            //var senhaEmail = 
            client.Credentials = new System.Net.NetworkCredential("suporteskoll@gmail.com", "Vinik@2020");
            MailMessage mail = new MailMessage();
            mail.Sender = new System.Net.Mail.MailAddress("suporteskoll@gmail.com", "Suporte Skoll");
            mail.From = new MailAddress("suporteskoll@gmail.com", "Suporte Skoll");
            mail.To.Add(new MailAddress(usuario.email, usuario.nome));
            mail.Subject = "Nova senha de usuário - Sistema Skoll";
            var senha = GeraSenhaAleatoria();
            mail.Body = " Mensagem do Sistema Skoll:<br/> Olá " + usuario.nome + "<br/> Sua nova senha é : <b>" + senha + "</b> <br/> TROQUE-A ASSIM QUE REALIZAR O LOGIN NO SISTEMA.";
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.High;

            usuario.senha = senha;
            new UsuarioService(_unitOfWork).Update(usuario);

            try
            {
                client.Send(mail);
            }
            catch (System.Exception erro)
            {
                throw new AppError("Não foi possível enviar seu email - favor entre em contato com o administrador do sistema. Erro: " + erro.Message + ". Stack: " + erro.StackTrace, 401);
            }
            finally
            {
                mail = null;                
            }

            return "oi";

        }

        private string GeraSenhaAleatoria()
        {
            int tamanhoSenha = 15;
            string validar = "abcdefghijklmnozABCDEFGHIJKLMNOZ1234567890@#$%&*!";
            try
            {
                StringBuilder strbld = new StringBuilder(100);
                Random random = new Random();
                while (0 < tamanhoSenha--)
                {
                    strbld.Append(validar[random.Next(validar.Length)]);
                }
                return strbld.ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }

    }
}
