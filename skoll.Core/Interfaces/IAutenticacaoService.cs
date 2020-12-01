using skoll.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IAutenticacaoService
    {
        public object Autenticar(Usuario usuario);
    }
}
