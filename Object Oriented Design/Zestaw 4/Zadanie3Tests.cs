using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Lista_4
{
    [TestFixture]
    class Zadanie3Tests
    {
        [Test]
        public void DifferentPlanes()
        {
            Plane plane1, plane2;

            plane1 = Airport.Instance().AcquirePlane();
            plane2 = Airport.Instance().AcquirePlane();

            Assert.AreNotSame(plane1, plane2);
            Assert.AreNotEqual(plane1.Id, plane2.Id);

            Airport.Instance().ReleasePlane(plane1);
            Airport.Instance().ReleasePlane(plane2);
        }

        [Test]
        public void ExceptionOnEmptyAirport()
        {
            Plane[] planes = new Plane[100];
            Plane plane = null;

            for(int i = 0; i < 100; i++)
            {
                planes[i] = Airport.Instance().AcquirePlane();
            }

            Assert.Throws(typeof(Exception), () => plane = Airport.Instance().AcquirePlane());

            for (int i = 0; i < 100; i++)
            {
                Airport.Instance().ReleasePlane(planes[i]);
            }
            
        }

        [Test]
        public void ReleasingWorks()
        {
            Plane[] planes = new Plane[100];
            Plane plane = null;

            for (int i = 0; i < 100; i++)
            {
                planes[i] = Airport.Instance().AcquirePlane();
            }
            int lastId = planes[99].Id;
            Airport.Instance().ReleasePlane(planes[99]);

            Assert.DoesNotThrow(() => plane = Airport.Instance().AcquirePlane());
            Assert.AreEqual(lastId, plane.Id);

            for (int i = 0; i < 100; i++)
            {
                Airport.Instance().ReleasePlane(planes[i]);
            }
        }
    }
}
