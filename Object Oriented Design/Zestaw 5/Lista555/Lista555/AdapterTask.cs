using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{
    class AdapterTask
    {
        static int IntComparison(int x, int y)
        {
            return x.CompareTo(y);
        }
        static void Main(string[] args)
        {
            Console.WriteLine("\nZADANIE 4\n");

            ArrayList a = new ArrayList() { 1, 5, 3, 3, 2, 4, 3 };

            Console.WriteLine("Przed posortowaniem");
            foreach(int i in a)
            {
                Console.Write(i + " ");
            }
            Console.WriteLine("");
            
            /* the ArrayList's Sort method accepts ONLY an IComparer */

            a.Sort(new ComparisonToComparerAdapter(IntComparison));

            Console.WriteLine("Po posortowaniu");
            foreach(int i in a)
            {
                Console.Write(i + " ");
            }
            Console.WriteLine("");
        }
    }

    public class ComparisonToComparerAdapter : IComparer
    {
        Func<int, int, int> comparison;

        public ComparisonToComparerAdapter(Func<int, int, int> comparison)
        {
            this.comparison = comparison;
        }

        public int Compare(object x, object y)
        {
            return comparison((int)x, (int)y);
        }
    }
}
