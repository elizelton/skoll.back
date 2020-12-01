using Microsoft.Extensions.Configuration;
using Npgsql;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.UnitOfWork
{
    public class UnitOfWorkFactory : IUnitOfWorkFactory
    {
        private readonly IConfiguration _configuration;

        public UnitOfWorkFactory(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public IUnitOfWork Create()
        {
            string stringConexao = "DefaultConnection";
            if (_configuration == null)
                throw new ConfigurationErrorsException("Configuration faltando.");

            string connString = _configuration.GetConnectionString(stringConexao);

            if (String.IsNullOrEmpty(connString))
                throw new ConfigurationErrorsException($"Verificar {stringConexao} no appsetting.json");

            var connection = new NpgsqlConnection(connString);

            // Inicia a conexão
            connection.Open();

            // Retorna uma nova unidade de trabalho
            return new UnitOfWork(connection, true);
        }
    }
}
