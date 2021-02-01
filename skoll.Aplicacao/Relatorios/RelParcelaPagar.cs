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
    public class RelParcelaPagar : TNEReport
    {
        public List<RelParcelasPagar> list = null;
        public RelParcelaPagar()
        { 
            Paisagem = false;
        }

        public RelParcelaPagar(List<RelParcelasPagar> result)
        {
            Paisagem = false;
            this.list = result;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            #region Cabeçalho do Relatório
            PdfPTable table = new PdfPTable(6);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            float[] colsW = { 110,40,20,40,40,40 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Fornecedor", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Venc.", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Num.", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("A Pagar", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Pago", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Saldo", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));            
            #endregion

            var parcelas = this.list;

            foreach (var d in parcelas)
            { 
                table.AddCell(getNewCell(d.fornecedorConta, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.dataVencimento, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.numParcela.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("R$ {0:0.00}", d.valorPagar), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("R$ {0:0.00}", d.valorPago), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("R$ {0:0.00}", d.valorPagar - d.valorPago), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            }


            var total = parcelas.Sum(e => e.valorPagar);
            var pago = parcelas.Sum(e => e.valorPago);

            table.AddCell(getNewCell("", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            table.AddCell(getNewCell("", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            table.AddCell(getNewCell("Total: ", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            table.AddCell(getNewCell(string.Format("R$ {0:0.00}", total), titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            table.AddCell(getNewCell(string.Format("R$ {0:0.00}", pago), titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
            table.AddCell(getNewCell(string.Format("R$ {0:0.00}", total - pago), titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));

            doc.Add(table);
        }
    }
}
