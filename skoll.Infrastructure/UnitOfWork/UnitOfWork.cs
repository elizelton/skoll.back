using Npgsql;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        public bool _hasConnection { get; set; }
        public NpgsqlTransaction _transaction { get; set; }
        public NpgsqlConnection _connection { get; set; }
        public IUnitOfWorkRepository Repositorios { get; set; }


        public UnitOfWork(NpgsqlConnection connection, bool hasConnection)
        {
            _connection = connection;
            _hasConnection = hasConnection;
            _transaction = connection.BeginTransaction();
            Repositorios = new UnitOfWorkRepository(_connection, _transaction);
        }

        // Salva as nossas alterações, verificando se a transaction é nula.
        // Após comitar a transação, seta null para evitar problemas de concorrência.
        public void SaveChanges()
        {
            if (_transaction == null)
            {
                throw new InvalidOperationException(
                    " A transação já foi comitada ");
            }

            _transaction.Commit();
            _transaction = null;
        }

        // Fecha nossa conexão, e caso alguma transação esteja em uso faz um Rollback.
        public void Dispose()
        {
            if (_transaction != null)
            {
                _transaction.Rollback();
                _transaction = null;
            }

            if (_connection != null && _hasConnection)
            {
                _connection.Close();
                _connection = null;
            }
        }
    }
}
