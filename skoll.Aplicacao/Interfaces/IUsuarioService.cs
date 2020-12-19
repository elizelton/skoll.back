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
        IEnumerable<Usuario> GetAll();
        Usuario Get(int id);
        void Create(Usuario usuario);
        void Update(Usuario usuario);
        void Remove(int id);
    }
}
