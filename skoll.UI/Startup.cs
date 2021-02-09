using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using skoll.Infraestrutura;
using skoll.Dominio.Exceptions;
using Microsoft.AspNetCore.Http;
using System;
using Npgsql;
using skoll.Aplicacao;
using Newtonsoft.Json;
using Swashbuckle.Swagger;
using Microsoft.OpenApi.Models;

namespace skoll
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllersWithViews();

            services.AddAplicacao(Configuration);
            services.AddInfraestrutura(Configuration);

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo()
                {
                    Version = "v1",
                    Title = "SKoll API",
                    Description = "Backend SKoll API"
                });
            });

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseCors(builder => builder.WithOrigins("https://skollweb.herokuapp.com").AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
            app.UseCors(builder => builder.WithOrigins("http://localhost:4200")
                                .AllowAnyMethod()
                                .AllowAnyHeader());

            app.UseCors(builder => builder.WithOrigins("https://skollweb.herokuapp.com/")
                                .AllowAnyMethod()
                                .AllowAnyHeader());


            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
            });

            app.Use(async (context, next) =>
            {
                try
                {
                    await next();
                }
                catch (AppError ex)
                {
                    string json = JsonConvert.SerializeObject(new Dominio.Common.Response("error", ex._message));
                    context.Response.ContentType = "application/json";
                    context.Response.StatusCode = ex._statusCode;

                    await context.Response.WriteAsync(json);
                }
                catch (PostgresException ex)
                {
                    string json = JsonConvert.SerializeObject(new Dominio.Common.Response(ex.SqlState, ex.MessageText));
                    context.Response.ContentType = "application/json";
                    context.Response.StatusCode = 400;

                    await context.Response.WriteAsync(json);
                }
                catch (Exception ex)
                {
                    string json = JsonConvert.SerializeObject(new Dominio.Common.Response("error", ex.Message));
                    context.Response.ContentType = "application/json";
                    context.Response.StatusCode = 500;

                    await context.Response.WriteAsync(json);
                }
                //catch (InvalidOperationException ex)
                //{
                //    string json = JsonConvert.SerializeObject(new Response("",""));
                //    context.Response.ContentType = "application/json";
                //    context.Response.StatusCode = 400;

                //    await context.Response.WriteAsync(json);
                //}

            });

            app.UseHttpsRedirection();

            //app.UseAllElasticApm(Configuration);

            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");
            });


        }
    }
}
