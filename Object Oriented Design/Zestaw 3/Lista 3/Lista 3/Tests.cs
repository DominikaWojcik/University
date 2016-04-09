using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Lista_3
{
    [TestFixture]
    class Tests
    {
        [Test]
        public void Test1()
        {

            Assert.AreEqual(5*5*5,125);
        }
    }
}
