using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_4
{
    class Zadanie4
    {
        public static void Main(string[] args)
        {
            TagBuilder tag = new TagBuilder();
            tag.IsIndented = true;
            tag.Indentation = 4;
            var script =
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
            Console.WriteLine(script);
        }
    }

    public class TagBuilder
    {
        public TagBuilder()
        {
            IsIndented = false;
            Indentation = 0;
            totalIndentation = 0;
        }

        public TagBuilder(string TagName, TagBuilder Parent)
        {
            this.tagName = TagName;
            this.parent = Parent;

            this.IsIndented = Parent.IsIndented;
            this.Indentation = Parent.Indentation;
            this.totalIndentation = Parent != null ? totalIndentation = Parent.totalIndentation + Parent.Indentation : 0;
        }

        private string tagName;
        private TagBuilder parent;
        private StringBuilder body = new StringBuilder();
        private Dictionary<string, string> _attributes = new Dictionary<string, string>();

        public bool IsIndented { get; set; }
        public int Indentation { get; set; }
        private int totalIndentation;


        public TagBuilder AddContent(string Content)
        {
            if (IsIndented)
            {
                for (int i = 0; i < totalIndentation; i++) body.Append(" ");
            }

            body.Append(Content);
            body.Append("\r\n");
            return this;
        }

        public TagBuilder AddChildContent(string Content)
        {
            //Zakładam, że już dobrze sformatowane
            body.Append(Content);
            return this;
        }

        public TagBuilder AddContentFormat(string Format, params object[] args)
        {
            body.AppendFormat(Format, args);
            return this;
        }

        public TagBuilder StartTag(string TagName)
        {
            TagBuilder tag = new TagBuilder(TagName, this);
            return tag;
        }

        public TagBuilder EndTag()
        {
            parent.AddChildContent(this.ToString());
            return parent;
        }

        public TagBuilder AddAttribute(string Name, string Value)
        {
            _attributes.Add(Name, Value);
            return this;
        }

        public override string ToString()
        {
            StringBuilder tag = new StringBuilder();

            // preamble
            if (!string.IsNullOrEmpty(this.tagName))
            {
                if(IsIndented)
                {
                    for (int i = 0; i < totalIndentation - Indentation; i++) tag.Append(" ");
                }
                tag.AppendFormat("<{0}", tagName);
            }

            if (_attributes.Count > 0)
            {
                tag.Append(" ");
                tag.Append(
                    string.Join(" ",
                        _attributes
                            .Select(
                                kvp => string.Format("{0}='{1}'", kvp.Key, kvp.Value))
                            .ToArray()));
            }

            // body/ending
            if (body.Length > 0)
            {
                if (!string.IsNullOrEmpty(this.tagName) || this._attributes.Count > 0)
                    tag.Append(">\r\n");

                string bodyStr = body.ToString();
                if(!string.IsNullOrEmpty(bodyStr))
                {
                    tag.Append(body.ToString());
                }
                
                if (!string.IsNullOrEmpty(this.tagName))
                {
                    if(IsIndented)
                    {
                        for (int i = 0; i < totalIndentation - Indentation; i++) tag.Append(" ");
                    }
                    tag.AppendFormat("</{0}>\r\n", this.tagName);
                }
            }
            else
                if (!string.IsNullOrEmpty(this.tagName))
                    tag.Append("/>\r\n");
            return tag.ToString();
        }
    }
}
