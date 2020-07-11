using Microsoft.EntityFrameworkCore;
using skoll.Application.Common.Interfaces;
using Skoll.Infrastructure.Persistence;
using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Linq.Expressions;

namespace skoll.Infrastructure.Repositories
{
    public class Repositorio<T> : IRepositorio<T> where T : class
    {
        private AppDbContext m_Context = null;
        DbSet<T> m_DbSet;
        public Repositorio(AppDbContext context)
        {
            m_Context = context;
            m_DbSet = m_Context.Set<T>();
        }

        public virtual void Adicionar(T entity)
        {
            m_DbSet.Add(entity);
        }

        public virtual void Atualizar(T entity)
        {
            m_DbSet.Attach(entity);
            ((IObjectContextAdapter)m_Context).ObjectContext.ObjectStateManager.ChangeObjectState(entity, System.Data.Entity.EntityState.Modified);
        }

        public virtual int Contar()
        {
            return m_DbSet.Count();
        }

        public virtual void Deletar(T entity)
        {
            m_DbSet.Remove(entity);
        }

        public virtual T Get(Expression<Func<T, bool>> predicate)
        {
            return m_DbSet.FirstOrDefault(predicate);
        }

        public virtual IEnumerable<T> GetAll(Expression<Func<T, bool>> predicate = null)
        {
            if (predicate != null)
            {
                return m_DbSet.Where(predicate);
            }
            return m_DbSet.AsEnumerable();
        }
    }
}
