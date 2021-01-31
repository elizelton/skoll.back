using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IServicoPrestadoRepositorio : ICRUDRepositorio<ServicoPrestado>
    {
        IEnumerable<ServicoPrestado> GetByNomeLike(string nome);

        IEnumerable<ServicoPrestado> GetAtivos();

        IEnumerable<ServicoPrestado> GetByProduto(int idProduto);
    }
}
