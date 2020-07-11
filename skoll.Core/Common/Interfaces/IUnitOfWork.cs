using skoll.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace skoll.Application.Common.Interfaces
{
    public interface IUnitOfWork
    {
        IRepositorio<Usuario> UsuarioRepositorio { get; }

        void Commit();
        void RollBack();
    }
}
