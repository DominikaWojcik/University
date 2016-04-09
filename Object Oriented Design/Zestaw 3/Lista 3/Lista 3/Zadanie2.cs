using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_3
{
    class Zadanie2
    {
        static void sMain(string[] args)
        {
            //PRZED MODYFIKACJĄ HIERARCHII
            Console.WriteLine("PRZED MODYFIKACJĄ HIERARCHII");

            ReportPrinter printer1 = new ReportPrinter("Jakiś tekst");

            Console.WriteLine("Dane przed formatem: {0}", printer1.GetData());
            printer1.FormatDocument();
            Console.WriteLine("Dane po formacie: {0}", printer1.GetData());
            printer1.PrintReport();

            //PO MODYFIKACJI
            Console.WriteLine("PO MODYFIKACJI HIERARCHII");

            Document doc = new Document("Jakiś tekst");
            DocumentFormatter docFormatter = new DocumentFormatter();
            ReportPrinter2 printer2 = new ReportPrinter2();

            Console.WriteLine("Dane przed formatem: {0}", doc.GetData());
            docFormatter.FormatDocument(doc);
            Console.WriteLine("Dane po formacie: {0}", doc.GetData());
            printer2.PrintReport(doc);
        }
    }

    public class ReportPrinter
    {
        private string data;

        public ReportPrinter(string _data)
        {
            this.data = _data;
        }
        public string GetData()
        {
            return data;
        }
        public void FormatDocument()
        {
            data = "Sformatowany dokument";
        }

        public void PrintReport()
        {
            Console.WriteLine("Drukuję dokument {0}", data);
        }
    }

    public class Document
    {
        public string data;

        public Document(string _data)
        {
            this.data = _data;
        }
        
        public string GetData()
        {
            return data;
        }
    }

    public class DocumentFormatter
    {
        public void FormatDocument(Document document)
        {
            document.data = "Dokument sformatowany przez DocumentFormatter";
        }
    }

    public class ReportPrinter2
    {
        public void PrintReport(Document report)
        {
            Console.WriteLine("ReportPrinter2 drukuje dokument {0}", report.GetData());
        }
    }


}
