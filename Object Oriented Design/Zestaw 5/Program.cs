using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nZADANIE 1 (Należy podać w kodze nadawce, adresata i hasło do konta nadawcy, włączyć obsługę mało bezpiecznych aplikacji w ustawieniach gmaila)\n");
            
            SmtpFacade facade = new SmtpFacade();
            FileStream fileStream = new FileStream("plik.txt", FileMode.OpenOrCreate, FileAccess.Read);
            facade.Send("mojmail@gmail.com", "mojmail@gmail.com", "haslo", "Temat wiadomości", "Tresc wiadomosci", fileStream, "text/plain");
            

            Console.WriteLine("\nZADANIE 2\n");

            FileStream fileToWrite = File.Create("zad2");
            CaesarStreamDecorator caeToWrite = new CaesarStreamDecorator(fileToWrite, 5);

            Console.WriteLine("Wypisano do pliku {0}", "To be written out by caesar stream");
            byte[] toBeWritten = Encoding.ASCII.GetBytes("To be written out by caesar stream");
            caeToWrite.Write(toBeWritten, 0, toBeWritten.Length);
            caeToWrite.Close();

            FileStream fileToRead = File.Open("zad2", FileMode.Open);
            CaesarStreamDecorator caeToRead = new CaesarStreamDecorator(fileToRead, -5);
            const int bufferLength = 128;
            byte[] toBeRead = new byte[bufferLength];

            int bytesRead = caeToRead.Read(toBeRead, 0, bufferLength);
            Console.WriteLine("Wczytano {0}", Encoding.ASCII.GetString(toBeRead));
            caeToRead.Close();
            
            
            Console.WriteLine("\nZADANIE 3\n");
            
            IShapeFactory factory = new ShapeFactory();
            IShapeFactory protectionProxy = new FactoryProtectionProxy(factory);
            IShapeFactory loggerProxy = new FactoryLoggerProxy(factory);

            try
            {
                IShape square = protectionProxy.CreateShape("Square", 2);
                Console.WriteLine("protection proxy nie wyrzuca wyjątku, zwraca {0}", square.ToString());
            }
            catch(UnauthorizedAccessException e)
            {
                Console.WriteLine("protection proxy wyrzuca wyjątek: {0}", e.Message);
            }

            loggerProxy.RegisterWorker(new RectangleWorker());
            IShape rectangle = loggerProxy.CreateShape("Rectangle", 4, 5);
           

            Console.WriteLine("\nZADANIE 5\n");

            Console.WriteLine("Wersja pierwsza - Wstrzykujemy ładowanie ludzi");
            NotifierPersonRegistry personReg1 = new MailPersonRegistry(new DatabasePeopleLoader());
            personReg1.LoadPeople();
            personReg1.NotifyPeople();

            Console.WriteLine("\nWersja druga - Wstrzykujemy powiadamianie ludzi");

            LoaderPersonRegistry personReg2 = new XmlPersonRegistry(new SmsPeopleNotifier());
            personReg2.LoadPeople();
            personReg2.NotifyPeople();
            
        }
    }
}
