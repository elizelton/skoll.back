﻿using FluentValidation;
using System.ComponentModel.DataAnnotations;

namespace skoll.Dominio.Common
{
    public abstract class BaseEntity
    {
        [Key()]
        public int Id { get; set; }

    }
}
