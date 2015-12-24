using System;
using System.Collections;


namespace PrimeCollection
{
    public class PrimeCollection : IEnumerable
    {
        
        public PrimeCollection()
        {
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return (IEnumerator)GetEnumerator();
        }
        public PrimeEnum GetEnumerator()
        {
            return new PrimeEnum();
        }
        
    }

    public class PrimeEnum : IEnumerator
    {
        int current;
        bool IsPrime(int x)
        {
            if (x < 0) return true;
            if (x < 2) return false;
            for (int i = 2; i * i <= x; i++)
                if (x % i == 0) return false;
            return true;
        }
        public PrimeEnum()
        {
            current = 1;
        }

        public bool MoveNext()
        {
            while (!IsPrime(current)) current++;
            return current > 0;
        }
        object IEnumerator.Current
        {
            get { return Current; }
        }
        public int Current
        {
            get 
            {
                current++;
                return current-1; 
            }
        }
        public void Reset()
        {
            current = 1;
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            PrimeCollection pc = new PrimeCollection();
            foreach(int prime in pc)
               Console.WriteLine(prime);
        }
    }

    
}
