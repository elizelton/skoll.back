using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using skoll.Infraestrutura.UnitOfWork;
using Skoll.Infrastructure.Persistence;
using System;

namespace skoll.Infrastructure
{
    public static class DependencyInjection
    {

        public static IServiceCollection AddInfraestrutura(this IServiceCollection services, IConfiguration configuration)
        {

            services.AddSingleton<IUnitOfWorkFactory, UnitOfWorkFactory>();

            return services;
        }
    }
}
