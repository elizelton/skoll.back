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
    public class ReciboParcelaImp : TNEReport
    {
        public ReciboParcela recibo = null;
        public ReciboParcelaImp()
        { 
            Paisagem = false;
        }

        public ReciboParcelaImp(ReciboParcela result)
        {
            Paisagem = false;
            this.recibo = result;
        }

        public override void MontaCorpoDados()
        {
            base.MontaCorpoDados();

            PdfPTable table = new PdfPTable(1);
            BaseColor preto = new BaseColor(0, 0, 0);
            BaseColor fundo = new BaseColor(200, 200, 200);
            Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
            Font titulo = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);

            var rec = this.recibo;
            float[] colsW = { 100 };
            table.SetWidths(colsW);
            table.HeaderRows = 1;
            table.WidthPercentage = 100;

            table.DefaultCell.Border = PdfPCell.BOTTOM_BORDER;
            table.DefaultCell.BorderColor = preto;
            table.DefaultCell.BorderColorBottom = new BaseColor(255, 255, 255);
            table.DefaultCell.Padding = 10;

            table.AddCell(getNewCell($"Recibo num {rec.idContrato}.{rec.idParcela}.{rec.numParcela}", titulo, Element.ALIGN_LEFT, 0, PdfPCell.ALIGN_LEFT, preto, fundo));
            //table.AddCell(getNewCell($"R${string.Format("R$ {0:0.00}",rec.valorExtenso)}", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER, preto, fundo));

            //table.AddCell(getNewCell($"Recebemos de {rec.cliente.nome}", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"             {rec.cliente.logradouro}, {rec.cliente.numero} - {rec.cliente.bairro}", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"             {rec.cliente.Cidade.cidade}/{rec.cliente.Cidade.estado} - {rec.cliente.cep}", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"A quantia de {rec.valorExtenso.ToUpper()} reais ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"Referente aos serviços prestados: ", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));

            //foreach (var serv in rec.servicos)
            //{
            //    table.AddCell(getNewCell($"{serv.servicoPrestado.produto.nome} - {serv.servicoPrestado.nome}", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //}

            //if (rec.observacoes != "FALSE")
            //{
            //    table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //    table.AddCell(getNewCell($"Observações: {rec.observacoes}", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //}

            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"Vencimento: {rec.vencimento}", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"E para clareza firmamos o presente ", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"Data: ___/___/____", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($" ", font, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"_____________________________________", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
            //table.AddCell(getNewCell($"Jornal Regional Notícias de Itararé - 22.013.543/0001-86", titulo, Element.ALIGN_LEFT, 5, PdfPCell.BOTTOM_BORDER));
        }
    }
}
