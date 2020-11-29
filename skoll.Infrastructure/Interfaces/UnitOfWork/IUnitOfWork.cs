using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        bool _hasConnection { get; set; }
        SqlTransaction _transaction { get; set; }
        SqlConnection _connection { get; set; }
        void SaveChanges();
        void Dispose();
    }
}
