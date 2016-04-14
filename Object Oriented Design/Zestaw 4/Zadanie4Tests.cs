using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Lista_4
{
    [TestFixture]
    class Zadanie4Tests
    {
        [Test]
        public void Test1()
        {
            TagBuilder tag = new TagBuilder();
            string correctTag = 
            @"<parent parentproperty1='true' parentproperty2='5'>
    <child1 childproperty1='c'>
        childbody
    </child1>
    <child2 childproperty2='c'>
        childbody
    </child2>
</parent>
<script>
    $.scriptbody();
</script>
";
            
            tag.IsIndented = true;
            tag.Indentation = 4;
            string builtTag =
                     tag.StartTag("parent")
                         .AddAttribute("parentproperty1", "true")
                         .AddAttribute("parentproperty2", "5")
                             .StartTag("child1")
                             .AddAttribute("childproperty1", "c")
                             .AddContent("childbody")
                             .EndTag()
                             .StartTag("child2")
                             .AddAttribute("childproperty2", "c")
                             .AddContent("childbody")
                             .EndTag()
                         .EndTag()
                         .StartTag("script")
                         .AddContent("$.scriptbody();")
                         .EndTag()
                         .ToString();

            Assert.AreEqual(builtTag, correctTag);
        }
    }
}
