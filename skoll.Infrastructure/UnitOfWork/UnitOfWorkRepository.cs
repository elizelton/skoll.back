﻿using Npgsql;
using skoll.Infraestrutura.Interfaces.Repositorios;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using skoll.Infraestrutura.Repositorios;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.UnitOfWork
{
    public class UnitOfWorkRepository : IUnitOfWorkRepository
    {
        public IUsuarioRepositorio UsuarioRepositorio { get; }
        public UnitOfWorkRepository(NpgsqlConnection context, NpgsqlTransaction transaction)
        {
            UsuarioRepositorio = new UsuarioRepositorio(context, transaction);
        }
    }
}
