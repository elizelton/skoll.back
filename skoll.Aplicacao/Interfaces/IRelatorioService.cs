using Npgsql;
using skoll.Aplicacao.Relatorios;
using skoll.Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Aplicacao.Interfaces
{
    public interface IRelatorioService
    {
        RelCidadesEstado RelCidadesEstado(string estado);

        RelParcelaPagar RelParcelasPagar(DateTime dataAte);

        RelParcelaVencer RelParcelasVencer(DateTime dataAte);

        RelContratoCliente RelContratosPorCliente(int idCliente, DateTime inicio, DateTime fim);
    }
}
