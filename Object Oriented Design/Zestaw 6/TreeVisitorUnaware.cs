using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public abstract class TreeVisitorUnaware
    {
        public abstract void Visit(TreeNode node);
        public abstract void Visit(TreeLeaf leaf);
    }

    public class HeightVisitorUnaware : TreeVisitorUnaware
    {
        private int currentHeight = 0;
        private int maxHeight = 0;
        private List<int> heights = new List<int>();

        public int Height 
        {
            get
            {
                return maxHeight;
            }
        }

        public override void Visit(TreeLeaf leaf)
        {
            if (heights.Count == 0) currentHeight = 1;
            else
            {
                currentHeight = heights[heights.Count - 1];
                heights.RemoveAt(heights.Count - 1);
            }
            maxHeight = Math.Max(maxHeight, currentHeight);
        }

        public override void Visit(TreeNode node)
        {
            if (heights.Count == 0) currentHeight = 1;
            else
            {
                currentHeight = heights[heights.Count - 1];
                heights.RemoveAt(heights.Count - 1);
            }
            maxHeight = Math.Max(maxHeight, currentHeight);

            if (node.Right != null)
                heights.Add(currentHeight + 1);
            if (node.Left != null)
                heights.Add(currentHeight + 1);
        }
    }
}
