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
        }

        public RelParcelasCaixa(List<RelPagamentoParcela> result)
        {
            Paisagem = false;
            this.list = result;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            #region Cabeçalho do Relatório
            PdfPTable table = new PdfPTable(3);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            float[] colsW = { 60,60,60 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Descrição", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Valor", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Pagamento", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            #endregion

            //var parcelas = this.list;

            //foreach (var d in parcelas)
            //{
            //    table.AddCell(getNewCell(d.clienteContrato, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(d.inicio, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(d.vendedor.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(d.formaPagamento.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(d.numParcelas.ToString(), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(string.Format("R$ {0:0.00}", d.valorTotal), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell(d.status.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //}

            doc.Add(table);
        }
    }
}
