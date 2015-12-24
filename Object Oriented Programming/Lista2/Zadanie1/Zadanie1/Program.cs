/*
 *  Author: Jarosław Dzikowski
 *  
 *  */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Zadanie1
{
    class IntStream
    {
        protected int current;
        public IntStream()
        {
            current = 0;
        }
        virtual public bool eos()
        {
            return current < 0;
        }

        virtual public int next()
        {
            current++;
            return current-1;
        }

        virtual public void reset()
        {
            current = 1;
        }
    }

    class PrimeStream : IntStream
    {
        public static bool isPrime(int x)
        {
            for (int i = 2; i * i <= x; i++)
                if (x % i == 0) return false;
            return true;
        }
        public PrimeStream()
        {
            current = 2;
        }
        public override int next()
        {
            while (current > 1 && !isPrime(current)) current++;
            if (current < 0) return 0;
            current++;
            return current-1;
        }

        public override void reset()
        {
            current = 2;
        }


    }

    class RandomStream : IntStream
    {
        Random generator;
        public RandomStream() : base()
        {
           generator = new Random();
        }

        public override bool eos()
        {
            return false;
        }
        public override int next()
        {
            return current = generator.Next();
        }

        public override void reset()
        {
        }

    }

    class RandomWordStream
    {
        RandomStream random;
        PrimeStream prime;
        String current;

        public RandomWordStream()
        {
            prime = new PrimeStream();
            random = new RandomStream();
            current = "";
        }

        public String next()
        {
            int length = prime.next();
            current = "";
            for(int i=0;i<length;i++)
            {
                char temp= (char)(random.next()%('z'-'a'+1) + 'a');
                current+=temp;
            }
            return current;

        }

        public bool eos()
        {
            return prime.eos();
        }

        public void reset()
        {
            prime.reset();
            random.reset();

        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            RandomWordStream rws = new RandomWordStream();

            Console.WriteLine("Opcje:");
            Console.WriteLine("1  -- Wypisuje string");
            Console.WriteLine("2  -- Sprawdza, czy strumień się zakończył");
            Console.WriteLine("3  -- Resetuje strumień");
            Console.WriteLine("cokolwiek innego -- Kończy program");


            bool done = false;
            while(!done)
            {
                int option = int.Parse(Console.ReadLine());
                switch(option)
                {
                    case 1:
                        Console.WriteLine(rws.next());
                        break;
                    case 2:
                        Console.WriteLine("EOS = {0}", rws.eos() ? "true" : "false");
                        break;
                    case 3:
                        rws.reset();
                        Console.WriteLine("Zresetowano strumień");
                        break;
                    default:
                        done = true;
                        break;
                }
            }
        }
    }
}
