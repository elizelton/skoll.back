using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IServicoPrestadoService
    {
        void Create(ServicoPrestado servPrest);

        ServicoPrestado Get(int id);

        IEnumerable<ServicoPrestado> GetAll();

        IEnumerable<ServicoPrestado> GetAtivos();

        IEnumerable<ServicoPrestado> GetByNomeLike(string nome);

        IEnumerable<ServicoPrestado> GetByProduto(int idProduto);

        void Remove(int id);

        void Update(ServicoPrestado servPrest);

    }
}
