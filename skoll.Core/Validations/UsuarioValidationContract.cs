using FluentValidator.Validation;
using skoll.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace skoll.Application.Validations
{
    class UsuarioValidationContract : IContract
    {
        public ValidationContract Contract { get; }

        public UsuarioValidationContract(Usuario usuario)
        {
            Contract = new ValidationContract();

            Contract.Requires()
                .HasMinLen(usuario.Login, 5, "Login", "Login deve conter no mínimo 5 caracteres")
                .HasMinLen(usuario.Nome, 5, "Nome", "Nome deve conter no mínimo 5 caracteres")
                .HasMinLen(usuario.Senha, 8, "Senha", "Senha deve conter no mínimo 5 caracteres")
                .HasMaxLen(usuario.Login, 15, "Login", "Login deve conter no máximo 15 caracteres")
                .HasMaxLen(usuario.Nome, 40, "Nome", "Nome deve conter no máximo 40 caracteres")
                .HasMaxLen(usuario.Senha, 15, "Senha", "Senha deve conter no máximo 15 caracteres")
                ;


        }
    }
}
