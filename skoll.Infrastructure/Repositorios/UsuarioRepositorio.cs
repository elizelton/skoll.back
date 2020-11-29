using skoll.Infraestrutura.Interfaces.Repositorios;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Repositorios
{
    public class UsuarioRepositorio : Repositorio, IUsuarioRepositorio
    {
        public UsuarioRepositorio(SqlConnection context, SqlTransaction transaction)
        {
            this._context = context;
            this._transaction = transaction;
        }
    }
}
