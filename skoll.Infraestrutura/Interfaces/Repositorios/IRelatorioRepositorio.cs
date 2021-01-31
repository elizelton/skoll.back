using Npgsql;
using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IRelatorioRepositorio : ICRUDRepositorio<Usuario>
    {
        List<Cidade> RelCidadesEstado(string estado);
    }
}
