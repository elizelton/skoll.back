using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios.acoes
{
    public interface IUpdateRepositorio<T> where T : class
    {
        void Update(T t);
    }
}
