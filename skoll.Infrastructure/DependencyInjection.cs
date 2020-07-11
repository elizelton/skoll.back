﻿using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using skoll.Application.Common.Interfaces;
using Skoll.Infrastructure.Persistence;
using System;

namespace skoll.Infrastructure
{
    public static class DependencyInjection
    {

        public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {

            services.AddDbContext<AppDbContext>(options =>
               options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")
               )
             );

            services.AddTransient<IUnitOfWork, UnitOfWork>();

            return services;
        }
    }
}
