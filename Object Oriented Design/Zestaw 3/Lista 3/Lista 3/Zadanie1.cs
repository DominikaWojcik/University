using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_3
{
    class Zadanie1
    {
        public static void sMain(string[] args)
        {
            ShapeFactory factory = new ShapeFactory();
            CircleWorker cworker = new CircleWorker();
            RectangleWorker rworker = new RectangleWorker();
            Surface surface = new Surface(factory);

            factory.AddWorker(cworker);
            factory.AddWorker(rworker);

            for(int i=0;i<6;i++)
            {
                surface.AddNewShape();
            }

            foreach(Shape shape in surface.Shapes)
            {
                shape.PrintInfo();
            }

            Console.WriteLine("");
            Console.WriteLine("Sumaryczne pole figur na płaszczyźnie to {0}", surface.ComputeTotalArea());
            Console.WriteLine("Sumaryczny obwód figur na płaszczyźnie to {0}", surface.ComputeTotalPerimeter());

        }
    }

    public abstract class Shape
    {
        public abstract double ComputeArea();
        public abstract double ComputePerimeter();

        public abstract void PrintInfo();
    }

    public class Circle : Shape
    {
        public double Radius { get; set; }

        public override double ComputeArea()
        {
            return Math.PI * Radius * Radius;
        }

        public override double ComputePerimeter()
        {
            return 2.0 * Math.PI * Radius;
        }

        public override void PrintInfo()
        {
            Console.WriteLine("Okrąg o promieniu {0}", Radius);
        }
    }

    public class Rectangle : Shape
    {
        public double Width { get; set; }
        public double Height { get; set; }

        public override double ComputeArea()
        {
            return Width * Height;
        }

        public override double ComputePerimeter()
        {
            return 2.0 * (Width + Height);
        }

        public override void PrintInfo()
        {
            Console.WriteLine("Prostokąt o wysokości {0} i szerokości {1}", Height, Width);
        }
    }

    public interface IFactoryWorker
    {
        bool AcceptParameter(string parameter);

        Shape CreateObject(string parameter);
    }

    public class CircleWorker : IFactoryWorker
    {
        public bool AcceptParameter(string parameter)
        {
            return parameter.Equals("Circle");
        }

        public Shape CreateObject(string parameter)
        {
            switch(parameter)
            {
                case "Circle" :
                    return new Circle() { Radius = RNG.GetDouble() * 10000.0};
                default:
                    return null;
            }
        }
    }

    public class RectangleWorker : IFactoryWorker
    {
        public bool AcceptParameter(string parameter)
        {
            return parameter.Equals("Rectangle");
        }

        public Shape CreateObject(string parameter)
        {
            switch (parameter)
            {
                case "Rectangle":
                    return new Rectangle() { Width = RNG.GetDouble() * 10000.0, Height = RNG.GetDouble() * 10000.0 };
                default:
                    return null;
            }
        }
    }

    public class ShapeFactory
    {
        List<IFactoryWorker> workers;
        List<Shape> shapes;

        public ShapeFactory()
        {
            workers = new List<IFactoryWorker>();
            shapes = new List<Shape>();
        }

        public void AddWorker(IFactoryWorker worker)
        {
            workers.Add(worker);
        }

        public Shape CreateShape(string type)
        {
            foreach(IFactoryWorker worker in workers)
            {
                if (worker.AcceptParameter(type))
                {
                    Shape newShape = worker.CreateObject(type);
                    shapes.Add(newShape);
                    return newShape;
                }
            }

            return null;
        }

    }

    public class Surface
    {
        private ShapeFactory factory;
        private List<Shape> shapes;

        public Surface(ShapeFactory factory)
        {
            shapes = new List<Shape>();
            this.factory = factory;
        }

        public List<Shape> Shapes
        {
            get { return shapes; }
        }

        public double ComputeTotalArea()
        {
            double totalArea = 0.0;

            foreach(Shape shape in shapes)
            {
                totalArea += shape.ComputeArea();
            }

            return totalArea;
        }

        public double ComputeTotalPerimeter()
        {
            double totalPerimeter = 0.0;

            foreach(Shape shape in shapes)
            {
                totalPerimeter += shape.ComputePerimeter();
            }

            return totalPerimeter;
        }

        public void AddNewShape()
        {
            Shape newShape;

            if (RNG.GetInt() % 2 == 0)
            {
                newShape = factory.CreateShape("Rectangle");
            }
            else
            {
                newShape = factory.CreateShape("Circle");
            }

            if(newShape != null)
            {
                shapes.Add(newShape);
            }
        }
    }

    public class RNG
    {
        private static Random rand = new Random();

        public static double GetDouble()
        {
            return rand.NextDouble();
        }

        public static double GetInt()
        {
            return rand.Next();
        }
    }
}
