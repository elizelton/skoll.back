using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Npgsql;
using skoll.Aplicacao.Interfaces;
using skoll.Aplicacao.Notification;
using skoll.Application.Common.Model;
using skoll.Application.Common.Services;
using skoll.Domain.Entities;
using skoll.Infraestrutura.Interfaces.UnitOfWork;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using static skoll.Aplicacao.Util.StringUtil;

namespace skoll.Aplicacao.Servicos
{
    public class UsuarioService : IUsuarioService
    {
        private IUnitOfWorkFactory _unitOfWork;
        private readonly NotificationContext _notificationContext;

        public UsuarioService(IUnitOfWorkFactory unitOfWorkFactory,
                              NotificationContext notificationContext)
        {
            _unitOfWork = unitOfWorkFactory;
            _notificationContext = notificationContext;
        }

        public void Create(Usuario usuario)
        {
            using (var context = _unitOfWork.Create())
            {
                try
                {
                    context.Repositorios.UsuarioRepositorio.Create(usuario);
                }
                catch(PostgresException e)
                {
                    _notificationContext.AddNotification("", e.MessageText);
                }
                context.SaveChanges();
            }
        }

        public Usuario Get(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.Get(id);
            }
        }

        public IEnumerable<Usuario> GetAll()
        {
            using (var context = _unitOfWork.Create())
            {
                return context.Repositorios.UsuarioRepositorio.GetAll();
            }
        }

        public void Remove(int id)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Remove(id);
                context.SaveChanges();
            }
        }

        public void Update(Usuario usuario)
        {
            using (var context = _unitOfWork.Create())
            {
                context.Repositorios.UsuarioRepositorio.Update(usuario);
                context.SaveChanges();
            }
        }
    }
}
