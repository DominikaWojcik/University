using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_4
{
    class Zadanie2
    {
        public static void sMain(string[] args)
        {
            ShapeFactory factory = new ShapeFactory();
            IShape square = factory.CreateShape("Square", 5);
            IShape rectangle = factory.CreateShape("Rectangle", 4, 5);
            
            if(rectangle == null)
            {
                Console.WriteLine("Rectangle jest null");
            }
            else
            {
                Console.WriteLine("Rectangle nie jest null");
            }

            //rozszerzenie
            factory.RegisterWorker(new RectangleWorker());
            rectangle = factory.CreateShape("Rectangle", 4, 5);

            if (rectangle == null)
            {
                Console.WriteLine("Teraz Rectangle jest null");
            }
            else
            {
                Console.WriteLine("Teraz Rectangle nie jest null");
            }
        }
    }

    public interface IShape
    {
    }

    public class Square : IShape
    {
        public int Size { get; set; }
    }

    public class Rectangle : IShape 
    {
        public int Width { get; set; }
        public int Height { get; set; }
    }

    public interface IShapeFactoryWorker
    {
        bool AcceptParameters(string ShapeName, params object[] parameters);

        IShape CreateShape(string ShapeName, params object[] parameters);
    }


    public class RectangleWorker : IShapeFactoryWorker
    {
        public bool AcceptParameters(string ShapeName, params object[] parameters)
        {
            return ShapeName.Equals("Rectangle") && 
                    parameters.Length == 2 &&
                    parameters[0].GetType() == typeof(System.Int32) &&
                    parameters[1].GetType() == typeof(System.Int32);
        }

        public IShape CreateShape(string ShapeName, params object[] parameters)
        {
            return new Rectangle() { Width = (int)parameters[0], Height = (int)parameters[1] };
        }
    }

    public class SquareWorker : IShapeFactoryWorker
    {
        public bool AcceptParameters(string ShapeName, params object[] parameters)
        {
            return ShapeName.Equals("Square") &&
                    parameters.Length == 1 &&
                    parameters[0].GetType() == typeof(System.Int32);
        }

        public IShape CreateShape(string ShapeName, params object[] parameters)
        {
            return new Square() { Size = (int)parameters[0] };
        }
    }

    public class ShapeFactory
    {
        List<IShapeFactoryWorker> workers;

        public ShapeFactory()
        {
            workers = new List<IShapeFactoryWorker>();
            workers.Add(new SquareWorker());
        }

        public void RegisterWorker(IShapeFactoryWorker worker)
        {
            workers.Add(worker);
        }

        public IShape CreateShape(string ShapeName, params object[] parameters)
        {
            foreach(var worker in workers)
            {
                if(worker.AcceptParameters(ShapeName, parameters))
                {
                    return worker.CreateShape(ShapeName, parameters);
                }
            }
            return null;
        }
    }


}
