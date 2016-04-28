using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public abstract class Tree
    {
        public virtual void Accept(TreeVisitorUnaware visitor)
        { }
    }

    public class TreeNode : Tree
    {
        public Tree Left { get; set; }
        public Tree Right { get; set; }

        public override void Accept(TreeVisitorUnaware visitor)
        {
            visitor.Visit(this);

            if (Left != null)
                Left.Accept(visitor);

            if (Right != null)
                Right.Accept(visitor);
        }
    }

    public class TreeLeaf : Tree
    {
        public override void Accept(TreeVisitorUnaware visitor)
        {
            visitor.Visit(this);
        }
    }

}
