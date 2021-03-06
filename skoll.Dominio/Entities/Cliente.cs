﻿using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System;

namespace skoll.Dominio.Entities
{
    public class Cliente : Pessoa
    {
        public int idCliente { get; set; }
        public bool ativo { get; set; }
        public int tipoCliente { get; set; }
        public DateTime nascimento { get; set; }
    }
}
