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
    public class RelComissaoPaga : TNEReport
    {
        public List<RelComissaoVendedor> list = null;
        public RelComissaoPaga()
        {
            Paisagem = false;
            oldDoc = true;
        }

        public RelComissaoPaga(List<RelComissaoVendedor> result)
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

            float[] colsW = {4, 18, 18, 2, 8};
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100f;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Contr.", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Vendedor", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Cliente", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Tp", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Valor", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            #endregion

            var parcelas = this.list.OrderByDescending(e=> e.tipoPagamento);
            var total = parcelas.Sum(e => e.valorComissao);

            foreach (var d in parcelas)
            {
                table.AddCell(getNewCell(d.idContrato.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.vendedor, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.clienteContrato, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.tipoPagamento, font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("{0:0.00}", d.valorComissao), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            }

            var cell = getNewCell($"Total: R${string.Format("{0:0.00}", total)}", titulo, Element.ALIGN_RIGHT, 10, PdfPCell.BOTTOM_BORDER);
            cell.Colspan = 5;
            table.AddCell(cell);

            cell = getNewCell($"---", titulo, Element.ALIGN_CENTER, 10, PdfPCell.BOTTOM_BORDER);
            cell.Colspan = 5;
            table.AddCell(cell);


            cell = getNewCell($"Legenda: Tp - Tipo (R - Recebimento | V - Venda)", titulo, Element.ALIGN_CENTER, 10, PdfPCell.BOTTOM_BORDER);
            cell.Colspan = 5;
            table.AddCell(cell);

            doc.Add(table);
        }
    }
}
