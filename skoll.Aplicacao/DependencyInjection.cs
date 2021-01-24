using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using skoll.Aplicacao.Interfaces;
using skoll.Aplicacao.Servicos;
using skoll.Aplicacao.Common.Model;
using skoll.Aplicacao.Common.Services;
using System;

namespace skoll.Aplicacao
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddAplicacao(this IServiceCollection services, IConfiguration configuration)
        {

            var signingConfigurations = new SigningConfigurations();
            services.AddSingleton(signingConfigurations);
            var tokenConfigurations = new TokenConfigurations();
            new ConfigureFromConfigurationOptions<TokenConfigurations>(
                configuration.GetSection("TokenConfigurations"))
                    .Configure(tokenConfigurations);
            services.AddSingleton(tokenConfigurations);
            services.AddAuthentication(authOptions =>
            {
                authOptions.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                authOptions.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(bearerOptions =>
            {
                var paramsValidation = bearerOptions.TokenValidationParameters;
                paramsValidation.IssuerSigningKey = signingConfigurations.Key;
                paramsValidation.ValidAudience = tokenConfigurations.Audience;
                paramsValidation.ValidIssuer = tokenConfigurations.Issuer;
                // Valida a assinatura de um token recebido
                paramsValidation.ValidateIssuerSigningKey = true;
                // Verifica se um token recebido ainda é válido
                paramsValidation.ValidateLifetime = true;
                // Tempo de tolerância para a expiração de um token (utilizado
                // caso haja problemas de sincronismo de horário entre diferentes
                // computadores envolvidos no processo de comunicação)
                paramsValidation.ClockSkew = TimeSpan.Zero;
            });
            // Ativa o uso do token como forma de autorizar o acesso
            // a recursos deste projeto
            services.AddAuthorization(auth =>
            {
                auth.AddPolicy("Bearer", new AuthorizationPolicyBuilder()
                    .AddAuthenticationSchemes(JwtBearerDefaults.AuthenticationScheme)
                    .RequireAuthenticatedUser().Build());
            });

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();


            //Servicos
            services.AddSingleton<IUsuarioService, UsuarioService>();
            services.AddSingleton<IAutenticacaoService, AutenticacaoService>();
            services.AddSingleton<ICidadeService, CidadeService>();
            services.AddSingleton<IClienteService, ClienteService>();
            services.AddSingleton<IFormaPagamentoService, FormaPagamentoService>();


            return services;
        }
    }
}
