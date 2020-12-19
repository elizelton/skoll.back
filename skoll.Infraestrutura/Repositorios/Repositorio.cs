using Microsoft.EntityFrameworkCore;
using Npgsql;
using skoll.Infraestrutura.Interfaces.Repositorios;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;

namespace skoll.Infraestrutura.Repositorios
{
    public abstract class RepositorioBase
    {
        protected NpgsqlConnection _context;
        protected NpgsqlTransaction _transaction;

        protected NpgsqlCommand CreateCommand(string query)
        {
            return new NpgsqlCommand(query, _context, _transaction);
        }
    }
}
