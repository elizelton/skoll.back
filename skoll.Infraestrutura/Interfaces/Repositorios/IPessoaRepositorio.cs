﻿using skoll.Dominio.Entities;
using System.Collections.Generic;

namespace skoll.Infraestrutura.Interfaces.Repositorios
{
    public interface IPessoaRepositorio : ICRUDRepositorio<Pessoa>
    {
        IEnumerable<Pessoa> GetByNomeLike(string nome);

        Pessoa GetByCpfCnpj(string cpfCnpj);
    }
}
