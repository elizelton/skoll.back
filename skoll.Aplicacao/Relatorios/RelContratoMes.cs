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
    public class RelContratoMes : TNEReport
    {
        public List<RelContrato> list = null;
        public RelContratoMes()
        { 
            Paisagem = false;
        }

        public RelContratoMes(List<RelContrato> result)
        {
            Paisagem = false;
            this.list = result;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            #region Cabeçalho do Relatório
            PdfPTable table = new PdfPTable(7);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            //float[] colsW = { 65,25,40,50,15,25,20 };
            float[] colsW = { 40,20,20,25,15,35,20 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell("Cliente", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Início", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Vendedor", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Pagamento", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Parc.", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));
            table.AddCell(getNewCell("Total", titulo, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));         
            table.AddCell(getNewCell("Status", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));         
            #endregion

            var parcelas = this.list;

            foreach (var d in parcelas)
            { 
                table.AddCell(getNewCell(d.clienteContrato, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.inicio, font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.vendedor.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.formaPagamento.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.numParcelas.ToString(), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(string.Format("R$ {0:0.00}", d.valorTotal), font, Element.ALIGN_RIGHT, 5, PdfPCell.BOTTOM_BORDER));
                table.AddCell(getNewCell(d.status.ToString(), font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            }


            //var total = parcelas.Sum(e => e.valorTotal);
            //var totalCon = parcelas.Count;

            //table.AddCell(getNewCell("Teste", titulo, Element.ALIGN_LEFT, 0, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell("Total: ", titulo, Element.ALIGN_LEFT, 0, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell(totalCon.ToString(), font, Element.ALIGN_RIGHT, 0, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell("Valores: ", titulo, Element.ALIGN_LEFT, 0, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell(string.Format("R$ {0:0.00}", total), titulo, Element.ALIGN_RIGHT, 0, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell("", titulo, Element.ALIGN_LEFT, 0, PdfPCell.BOTTOM_BORDER));

            doc.Add(table);
        }
    }
}
