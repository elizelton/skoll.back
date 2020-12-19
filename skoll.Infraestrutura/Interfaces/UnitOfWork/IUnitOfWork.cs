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
        IUnitOfWorkRepository Repositorios { get; }
        void SaveChanges();
        new void Dispose();
    }
}
