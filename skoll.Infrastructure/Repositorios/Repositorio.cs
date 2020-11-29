using Microsoft.EntityFrameworkCore;
using skoll.Application.Common.Interfaces;
using skoll.Infraestrutura.Interfaces.Repositorios;
using Skoll.Infrastructure.Persistence;
using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;

namespace skoll.Infraestrutura.Repositorios
{
    public abstract class Repositorio
    {
        protected SqlConnection _context;
        protected SqlTransaction _transaction;

        SqlCommand CreateCommand(string query)
        {
            return new SqlCommand(query, _context, _transaction);
        }
    }
}
