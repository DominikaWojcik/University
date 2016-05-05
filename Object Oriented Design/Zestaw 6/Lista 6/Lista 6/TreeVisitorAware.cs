using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public abstract class TreeVisitorAware
    {
        public void Visit(Tree tree)
        {
            if(tree is TreeLeaf)
            {
                Visit((TreeLeaf)tree);
            }
            else
            {
                Visit((TreeNode)tree);
            }
        }

        public abstract void Visit(TreeNode node);
        public abstract void Visit(TreeLeaf leaf);
    }

    public class HeightVisitorAware : TreeVisitorAware
    {
        private int maxHeight = 0;
        private int currentHeight = 0;

        public int Height
        {
            get
            {
                return maxHeight;
            }
        }

        public override void Visit(TreeLeaf leaf)
        {
            if(leaf == null) return;

            currentHeight++;
            maxHeight = Math.Max(maxHeight, currentHeight);
            currentHeight--;
        }

        public override void Visit(TreeNode node)
        {
            if (node == null) return;

            currentHeight++;
            maxHeight = Math.Max(maxHeight, currentHeight);
            Visit(node.Left);
            Visit(node.Right);
            currentHeight--;
        }
    }
}
