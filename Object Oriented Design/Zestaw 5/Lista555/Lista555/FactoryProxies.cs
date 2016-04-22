using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{
    public class FactoryProtectionProxy : IShapeFactory
    {
        private static int openHour = 8;
        private static int closeHour = 22;

        IShapeFactory realFactory;

        public FactoryProtectionProxy(IShapeFactory realFactory)
        {
            this.realFactory = realFactory;
        }

        public void RegisterWorker(IShapeFactoryWorker worker)
        {
            AssertTime();
            realFactory.RegisterWorker(worker);
        }

        public IShape CreateShape(string ShapeName, params object[] parameters)
        {
            AssertTime();
            return realFactory.CreateShape(ShapeName, parameters);
        }

        private void AssertTime()
        {
            DateTime now = DateTime.Now.ToLocalTime();
           
            if(now.Hour < openHour|| now.Hour >= closeHour)
            {
                throw new UnauthorizedAccessException("Używanie po godzinach pracy");
            }
        }
    }

    public class FactoryLoggerProxy : IShapeFactory
    {
        private IShapeFactory realFactory;

        public FactoryLoggerProxy(IShapeFactory realFactory)
        {
            this.realFactory = realFactory;
        }

        public void RegisterWorker(IShapeFactoryWorker worker)
        {
            Console.WriteLine("Proxy register worker start: {0}, params {1}", DateTime.Now, worker.ToString());
            realFactory.RegisterWorker(worker);
            Console.WriteLine("Proxy register worker end: {0}", DateTime.Now); 
        }

        public IShape CreateShape(string ShapeName, params object[] parameters)
        {
            Console.Write("Proxy create shape start: {0}, shape name {1}, params ", DateTime.Now, ShapeName);
            foreach(var param in parameters)
            {
                Console.Write("{0} ", param.ToString());
            }
            Console.Write("\n");

            IShape toReturn = realFactory.CreateShape(ShapeName, parameters);

            Console.WriteLine("Proxy create shape end: {0}, returns {1}", DateTime.Now, toReturn.ToString());
            return toReturn;
        }
    }

    /* 
     * Z POPRZEDNIEGO TYGODNIA
    */

    public interface IShape
    {
    }

    public class Square : IShape
    {
        public int Size { get; set; }

        public override string ToString()
        {
            return "Kwadrat o boku " + Size.ToString();
        }
    }

    public class Rectangle : IShape
    {
        public int Width { get; set; }
        public int Height { get; set; }

        public override string ToString()
        {
            return "Prostokąt o szerokości " + Width.ToString() + " i wysokości " + Height.ToString();
        }
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

    public interface IShapeFactory
    {
        void RegisterWorker(IShapeFactoryWorker worker);
        IShape CreateShape(string ShapeName, params object[] parameters);
    }

    public class ShapeFactory : IShapeFactory
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
            foreach (var worker in workers)
            {
                if (worker.AcceptParameters(ShapeName, parameters))
                {
                    return worker.CreateShape(ShapeName, parameters);
                }
            }
            return null;
        }
    }
}
