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
    public class RelParcelasCaixa : TNEReport
    {
        public List<RelPagamentoParcela> list = null;
        public RelParcelasCaixa()
        {
            Paisagem = false;
            oldDoc = true;
        }

        public RelParcelasCaixa(List<RelPagamentoParcela> result)
        {
            Paisagem = false;
            this.list = result;
            oldDoc = true;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            #region Cabeçalho do Relatório
            PdfPTable table = new PdfPTable(5);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            float[] colsW = { 15, 25, 7, 3, 10 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100f;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Descrição", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Cli./Forn.", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Pagamento", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Num", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Valor", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            #endregion


            var parcelas = this.list.OrderBy(e=> e.isEstrada);
            bool entrou = false;
            var total1 = parcelas.Where(e => e.isEstrada).Sum(e => e.valor);
            var total2 = parcelas.Where(e => !e.isEstrada).Sum(e => e.valor);

            var cell = getNewCell("RECEBIDAS", titulo, Element.ALIGN_LEFT, 10, PdfPCell.BOTTOM_BORDER);
            cell.Colspan = 5;
            table.AddCell(cell);

            foreach (var d in parcelas)
            {

                if (d.isEstrada == false &&!entrou)
                {
                    cell = getNewCell($"Total: R${total1}", titulo, Element.ALIGN_RIGHT, 10, PdfPCell.BOTTOM_BORDER);
                    cell.Colspan = 5;
                    table.AddCell(cell);


                    cell = getNewCell("PAGAS", titulo, Element.ALIGN_LEFT, 10, PdfPCell.BOTTOM_BORDER);
                    cell.Colspan = 5;
                    table.AddCell(cell);
                    entrou = true;
                }
                table.AddCell(getNewCell("0", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell("01/01/2020", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell("01/01/2020", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("{0:0.00}", "100"), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("{0:0.00}", "100"), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));

            }

            if (entrou)
            {
                cell = getNewCell($"Total: R${total2}", titulo, Element.ALIGN_RIGHT, 10, PdfPCell.BOTTOM_BORDER);
                cell.Colspan = 5;
                table.AddCell(cell);
            }
            else
            {
                cell = getNewCell($"Total: R${total1}", titulo, Element.ALIGN_RIGHT, 10, PdfPCell.BOTTOM_BORDER);
                cell.Colspan = 5;
                table.AddCell(cell);
            }

            doc.Add(table);
        }
    }
}
