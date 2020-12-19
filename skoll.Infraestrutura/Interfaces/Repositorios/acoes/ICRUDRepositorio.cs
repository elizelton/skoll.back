using skoll.Infraestrutura.Interfaces.Repositorios.acoes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface ICRUDRepositorio<T> :
        ICreateRepositorio<T>,
        IReadRepositorio<T>,
        IUpdateRepositorio<T>,
        IRemoveRepositorio<T> where T : class
    {
        
    }
}
