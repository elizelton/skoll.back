using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios.acoes
{
    public interface ICreateRepositorio<T> where T : class
    {
        void Create(T t);
    }
}
