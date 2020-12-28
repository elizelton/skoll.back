﻿using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IUsuarioRepositorio : ICRUDRepositorio<Usuario>
    {
        Usuario GetByUserNameESenha(string UserName, string senha);

        void Remove(List<Usuario> usuarios);
    }
}
