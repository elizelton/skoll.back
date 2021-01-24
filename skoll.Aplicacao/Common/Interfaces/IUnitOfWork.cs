using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace skoll.Aplicacao.Common.Interfaces
{
    public interface IUnitOfWork
    {
        IRepositorio<Usuario> UsuarioRepositorio { get; }
        IRepositorio<Cidade> CidadeRepositorio { get; }

        void Commit();
        void RollBack();
    }
}
