using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios.acoes
{
    public interface IReadRepositorio<T> where T : class
    {
        IEnumerable<T> GetAll();
        T Get(int id);
    }
}
