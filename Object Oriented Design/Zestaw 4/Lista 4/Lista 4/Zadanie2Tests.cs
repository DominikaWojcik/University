using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Lista_4
{
    [TestFixture]
    class Zadanie2Tests
    {
        [Test]
        public void Test1()
        {
            ShapeFactory factory = new ShapeFactory();

            IShape square = factory.CreateShape("Square", 5);

            Assert.IsNotNull(square);
        }

        [Test]
        public void Test2()
        {
            ShapeFactory factory = new ShapeFactory();

            IShape rectangle = factory.CreateShape("Rectangle", 4, 5);

            Assert.IsNull(rectangle);
        }

        [Test]
        public void Test3()
        {
            ShapeFactory factory = new ShapeFactory();

            factory.RegisterWorker(new RectangleWorker());
            IShape rectangle = factory.CreateShape("Rectangle", 4, 5);

            Assert.IsNotNull(rectangle);
        }

        [Test]
        public void Test4()
        {
            ShapeFactory factory = new ShapeFactory();
            IShape square, rectangle;

            square = factory.CreateShape("Square", 5);
            factory.RegisterWorker(new RectangleWorker());
            rectangle = factory.CreateShape("Rectangle", 4, 5);

            Assert.AreNotEqual(rectangle, square);
            Assert.AreNotSame(rectangle, square);
        }

    }
}
