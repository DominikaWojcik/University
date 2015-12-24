using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Zadanie4
{
    class LeniwaLista
    {
        protected int ile, licznik;
        protected List<int> lista;
        
        public LeniwaLista()
        {
            ile = 0;
            licznik = 1;
            lista = new List<int>();
            lista.Add(0);
        }
        
        public int size()
        {
            return ile;
        }

        virtual public int element(int i)
        {
            if (i <= ile) return lista[i];
            for(int j=ile+1;j<=i;j++)
            {
                lista.Add(licznik);
                licznik++;
            }
            ile += i - ile;
            return lista[i];
        }
    }

    class Pierwsze : LeniwaLista
    {
        public Pierwsze() : base()
        {

        }
        private bool isPrime(int x)
        {
            if (x < 2) return false;
            for (int i = 2; i * i <= x; i++)
                if (x % i == 0) return false;
            return true;
        }

        public override int element(int i)
        {
            if (i <= ile) return lista[i];
            for(int j=ile+1;j<=i;j++)
            {
                while (!isPrime(licznik)) licznik++;
                lista.Add(licznik);
                licznik++;
            }
            ile += i - ile;
            return lista[i];
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            LeniwaLista l = new LeniwaLista();
            Pierwsze p = new Pierwsze();
            Console.WriteLine("Opcje:");
            Console.WriteLine("1 i  -- Wypisz i-ty element leniwej listy");
            Console.WriteLine("2  -- Wypisz aktualny rozmiar leniwej listy");
            Console.WriteLine("3 i  -- Wypisz i-ty element listy pierwsze");
            Console.WriteLine("4  -- Wypisz aktualny rozmiar listy pierwsze");
            Console.WriteLine("Cokolwiek innego  -- zakoncz program");

            bool done = false;
            while(!done)
            {
                String[] input=Console.ReadLine().Split();
                int opcja = int.Parse(input[0]);
                int druga=0;
                if (input.Length > 1) druga = int.Parse(input[1]);
                switch(opcja)
                {
                    case 1:
                        Console.WriteLine("{0} element leniwej listy to {1}", druga, l.element(druga));
                        break;
                    case 2:
                        Console.WriteLine("Rozmiar leniwej listy to {0}", l.size());
                        break;
                    case 3:
                        Console.WriteLine("{0} element listy pierwsze to {1}", druga, p.element(druga));
                        break;
                    case 4:
                        Console.WriteLine("Rozmiar listy pierwsze to {0}", p.size());
                        break;
                    default:
                        done = true;
                        break;
                }
            }
        }
    }
}
