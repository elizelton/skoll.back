using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using iTextSharp.text;
using iTextSharp.text.pdf;
using skoll.Dominio.Entities;

namespace skoll.Aplicacao.Relatorios
{
    public class RelCidadesEstado : TNEReport
    {
        public List<Cidade> list = null;
        public RelCidadesEstado()
        { 
            Paisagem = false;
        }

        public RelCidadesEstado(List<Cidade> result)
        {
            Paisagem = false;
            this.list = result;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            #region Cabeçalho do Relatório
            PdfPTable table = new PdfPTable(2);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            float[] colsW = {40 ,10 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100f;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Cidade", titulo, Element.ALIGN_LEFT, 10, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Estado", titulo, Element.ALIGN_LEFT, 10, PdfPCell.BOTTOM_BORDER, preto, fundo));
            #endregion

            var cidades = this.list;

            foreach (var d in cidades)
            {
                //Alteração de Estado
                //if (d.cliente.RazaoSocial != clienteOld)
                //{
                //    var cell = getNewCell(d.cliente.RazaoSocial, titulo, Element.ALIGN_LEFT, 10, PdfPCell.BOTTOM_BORDER);
                //    cell.Colspan = 5;
                //    table.AddCell(cell);
                //    clienteOld = d.cliente.RazaoSocial;
                //}

                table.AddCell(getNewCell(d.cidade, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.estado, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            }

            doc.Add(table);
        }
    }
}
