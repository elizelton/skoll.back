using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IUsuarioService
    {
        IEnumerable<Usuario> GetAll(string search);
        Usuario Get(int id);
        void Create(Usuario usuario);
        void Update(Usuario usuario);
        void Remove(int id);
        void Remove(List<Usuario> usuarios);
        Usuario GetByUserNameESenha(string UserName, string senha);
        Usuario GetByUserName(string userName);
        Usuario GetByEmail(string email);
    }
}
