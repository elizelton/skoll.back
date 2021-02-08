using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;

namespace skoll.Aplicacao.Relatorios
{
    public abstract class TNEReport
    {
        protected Document doc;
        PdfWriter writer;
        MemoryStream output;

        public string PageTitle { get; set; }
        public string PageSubTitle { get; set; }
        public string PageSubLogo { get; set; }
        public string BasePath { get; set; }
        public bool ImprimirCabecalhoPadrao { get; set; }
        public bool ImprimirRodapePadrao { get; set; }
        public bool Paisagem { get; set; }
        public bool oldDoc { get; set; }

        public TNEReport()
        {
            InicializaVariaveis();
        }

        public void InicializaVariaveis()
        {
            ImprimirCabecalhoPadrao = true;
            ImprimirRodapePadrao = true;
            PageTitle = string.Empty;
            PageSubTitle = string.Empty;
            BasePath = Directory.GetCurrentDirectory(); 
            Paisagem = false;
        }

        public MemoryStream GetOutput()
        {
            MontaCorpoDados();

            if (output == null || output.Length == 0)
            {
                throw new Exception("Sem dados para exibir.");
            }

            try
            {
                writer.Flush();

                if (writer.PageEmpty)
                {
                    doc.Add(new Paragraph("Nenhum registro para listar."));
                }

                doc.Close();
            }
            catch { }
            finally
            {
                doc = null;
                writer = null;
            }

            return output;
        }

        public virtual void MontaCorpoDados()
        {
            if (!Paisagem)
            {
                if (!oldDoc)
                    doc = new Document(PageSize.A4, 10, 10, 80, 75);
                else
                    doc = new Document(PageSize.A4, 20, 10, 80, 40);
            }
            else
            {
                doc = new Document(PageSize.A4.Rotate(), 20, 10, 80, 80);
            }
            output = new MemoryStream();
            writer = PdfWriter.GetInstance(doc, output);

            doc.AddAuthor("SKOLL");
            doc.AddTitle(PageTitle);
            doc.AddSubject(PageTitle);

            var footer = new MSPDFFooter();
            footer.PageTitle = PageTitle;
            footer.PageSubTitle = PageSubTitle;
            footer.BasePath = BasePath;
            footer.ImprimirCabecalhoPadrao = ImprimirCabecalhoPadrao;
            footer.ImprimirRodapePadrao = ImprimirRodapePadrao;

            writer.PageEvent = footer;

            doc.Open();

            return;
        }

        protected PdfPCell getNewCell(string Texto, Font Fonte, int Alinhamento, float Espacamento, int Borda, BaseColor CorBorda, BaseColor CorFundo)
        {
            var cell = new PdfPCell(new Phrase(Texto, Fonte));
            cell.HorizontalAlignment = Alinhamento;
            cell.Padding = Espacamento;
            cell.Border = Borda;
            cell.BorderColor = CorBorda;
            cell.BackgroundColor = CorFundo;

            return cell;
        }

        protected PdfPCell getNewCell(string Texto, Font Fonte, int Alinhamento, float Espacamento, int Borda, BaseColor CorBorda)
        {
            return getNewCell(Texto, Fonte, Alinhamento, Espacamento, Borda, CorBorda, new BaseColor(255, 255, 255));
        }
        protected PdfPCell getNewCell(string Texto, Font Fonte, int Alinhamento = 0, float Espacamento = 5, int Borda = 0)
        {
            return getNewCell(Texto, Fonte, Alinhamento, Espacamento, Borda, new BaseColor(0, 0, 0), new BaseColor(255, 255, 255));
        }
    }

    public class MSPDFFooter : PdfPageEventHelper
    {
        public string PageTitle { get; set; }
        public string PageSubTitle { get; set; }
        public string PageSubLogo { get; set; }
        public string BasePath { get; set; }
        public bool ImprimirCabecalhoPadrao { get; set; }
        public bool ImprimirRodapePadrao { get; set; }

        public override void OnOpenDocument(PdfWriter writer, Document doc)
        {
            base.OnOpenDocument(writer, doc);
        }

        public override void OnStartPage(PdfWriter writer, Document doc)
        {
            base.OnStartPage(writer, doc);

            ImprimeCabecalho(writer, doc);
        }

        public override void OnEndPage(PdfWriter writer, Document doc)
        {
            base.OnEndPage(writer, doc);

            ImprimeRodape(writer, doc);
        }

        private void ImprimeRodape(PdfWriter writer, Document doc)
        {
            #region Dados do Rodapé
            if (ImprimirRodapePadrao)
            {
                BaseColor preto = new BaseColor(0, 0, 0);
                Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
                Font negrito = FontFactory.GetFont("Verdana", 8, Font.BOLD, preto);
                float[] sizes = new float[] { 1.0f, 3.5f, 1f };

                PdfPTable table = new PdfPTable(3);
                table.TotalWidth = doc.PageSize.Width - (doc.LeftMargin + doc.RightMargin);
                table.SpacingBefore = 20f;
                table.SetWidths(sizes);

                #region Coluna TNE
                Image foot = Image.GetInstance(BasePath + @"\Content\skoll2.png");
                foot.ScalePercent(20);

                PdfPCell cell = new PdfPCell(foot);
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.PaddingLeft = 10f;
                cell.PaddingTop = 10f;
                table.AddCell(cell);

                PdfPTable micros = new PdfPTable(1);
                cell = new PdfPCell(new Phrase("SKOLL", negrito));
                cell.Border = 0;
                micros.AddCell(cell);
                cell = new PdfPCell(new Phrase("Sistema de Gerenciamento", font));
                cell.Border = 0;
                micros.AddCell(cell);
                cell = new PdfPCell(new Phrase("Relatório gerado em PDF", font));
                cell.Border = 0;
                micros.AddCell(cell);

                cell = new PdfPCell(micros);
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.PaddingTop = 10f;
                table.AddCell(cell);
                #endregion

                #region Página
                micros = new PdfPTable(1);
                cell = new PdfPCell(new Phrase(DateTime.Today.ToString("dd/MM/yyyy"), font));
                cell.Border = 0;
                cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                micros.AddCell(cell);
                cell = new PdfPCell(new Phrase(DateTime.Now.ToString("HH:mm:ss"), font));
                cell.Border = 0;
                cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                micros.AddCell(cell);

                cell = new PdfPCell(micros);
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.PaddingTop = 10f;
                table.AddCell(cell);
                #endregion

                table.WriteSelectedRows(0, -1, doc.LeftMargin, 70, writer.DirectContent);
            }
            #endregion 
        }

        private void ImprimeCabecalho(PdfWriter writer, Document doc)
        {
            #region Dados do Cabeçalho
            if (ImprimirCabecalhoPadrao)
            {
                BaseColor preto = new BaseColor(0, 0, 0);
                Font font = FontFactory.GetFont("Verdana", 8, Font.NORMAL, preto);
                Font titulo = FontFactory.GetFont("Verdana", 12, Font.BOLD, preto);
                float[] sizes = new float[] { 1f, 3f, 1f };

                PdfPTable table = new PdfPTable(3);
                table.TotalWidth = doc.PageSize.Width - (doc.LeftMargin + doc.RightMargin);
                table.SetWidths(sizes);

                #region Logo Empresa
                Image foot;
                foot = Image.GetInstance(BasePath + @"\Content\skoll2.png");

                foot.ScalePercent(20);

                PdfPCell cell = new PdfPCell(foot);
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.BorderWidthBottom = 1.5f;
                cell.PaddingTop = 10f;
                cell.PaddingBottom = 10f;
                table.AddCell(cell);

                PdfPTable micros = new PdfPTable(1);
                cell = new PdfPCell(new Phrase(PageSubTitle, font));
                cell.Border = 0;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                micros.AddCell(cell);
                cell = new PdfPCell(new Phrase(PageTitle, titulo));
                cell.Border = 0;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                micros.AddCell(cell);

                cell = new PdfPCell(micros);
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.BorderWidthBottom = 1.5f;
                cell.PaddingTop = 10f;
                table.AddCell(cell);
                #endregion

                #region Página
                micros = new PdfPTable(1);
                cell = new PdfPCell(new Phrase("Página: " + (doc.PageNumber).ToString(), font));
                cell.Border = 0;
                cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                micros.AddCell(cell);

                cell = new PdfPCell(micros);
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.Border = 0;
                cell.BorderWidthTop = 1.5f;
                cell.BorderWidthBottom = 1.5f;
                cell.PaddingTop = 10f;
                table.AddCell(cell);
                #endregion

                table.WriteSelectedRows(0, -1, doc.LeftMargin, (doc.PageSize.Height - 10), writer.DirectContent);
            }
            #endregion
        }

        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            base.OnCloseDocument(writer, document);
        }
    }
}