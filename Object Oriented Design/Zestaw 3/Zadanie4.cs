using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_3
{
    class Zadanie4
    {
        public static void Main(string[] args)
        {
            int w = 4, h = 5, s = 5;
            Rectangle rect = new Rectangle() { Width = w, Height = h };
            Square square = new Square() { Size = 5 };
            Polygon polyRect = new Rectangle() { Width = w, Height = h };
            Polygon polySquare = new Square() { Size = 5 };

            AreaCalculator calc = new AreaCalculator();
            Console.WriteLine( "Prostokąt o wymiarach {0} na {1} ma pole {2}", w, h, calc.CalculateArea(rect));
            Console.WriteLine("Kwadrat o wymiarach {0} na {0} ma pole {1}", s, calc.CalculateArea(square));

            Console.WriteLine("Wielokąt będący prostokątem ma pole {0} <- losowa liczba", calc.CalculateArea(polyRect));
            Console.WriteLine("Wielokąt będący kwadratem ma pole {0} <- losowa liczba", calc.CalculateArea(polySquare));
        }
    }

    public class Polygon
    {
        //Jakieś cechy wspólne wielokątów np. lista wierzchołków etc;
    }

    public class Rectangle : Polygon
    {
        public int Width { get; set; }
        public int Height { get; set; }
    }

    public class Square : Polygon
    {
        public int Size { get; set; }
    }

    public class AreaCalculator
    {
        public int CalculateArea(Polygon polygon)
        {
            //Liczymy jakoś pole (chociażby przez triangulację)
            return 42;
        }
        public int CalculateArea(Rectangle rectangle)
        {
            return rectangle.Width * rectangle.Height;
        }

        public int CalculateArea(Square square)
        {
            return square.Size * square.Size;
        }

    }
}
