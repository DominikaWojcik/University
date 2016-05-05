using System;
using System.Linq.Expressions;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public class DiagramExpressionVistor : ExpressionVisitor
    {
        List<int> tabs = new List<int>();

        protected override Expression VisitBinary(System.Linq.Expressions.BinaryExpression node)
        {
            int currentTabs;
            if (tabs.Count > 0)
            {
                currentTabs = tabs[tabs.Count - 1];
                tabs.RemoveAt(tabs.Count - 1);
            }
            else currentTabs = 0;

            for (int i = 0; i < currentTabs; i++) Console.Write("\t");
            Console.WriteLine("VisitBinary {0}", node.NodeType.ToString());

            if (node.Right != null && (node.Right is System.Linq.Expressions.BinaryExpression
                                        || node.Right is System.Linq.Expressions.ParameterExpression
                                        || node.Right is System.Linq.Expressions.ConstantExpression))
                tabs.Add(currentTabs + 1);

            if (node.Left != null && (node.Left is System.Linq.Expressions.BinaryExpression
                                        || node.Left is System.Linq.Expressions.ParameterExpression
                                        || node.Left is System.Linq.Expressions.ConstantExpression))
                tabs.Add(currentTabs + 1);

            return base.VisitBinary(node);
        }

        protected override Expression VisitLambda<T>(Expression<T> node)
        {
            int currentTabs;
            if (tabs.Count > 0)
            {
                currentTabs = tabs[tabs.Count - 1];
                tabs.RemoveAt(tabs.Count - 1);
            }
            else currentTabs = 0;

            for (int i = 0; i < currentTabs; i++) Console.Write("\t");
            Console.WriteLine("VisitLambda");

            for (int i = 0; i < node.Parameters.Count; i++)
            {
                tabs.Add(currentTabs + 1);
            }

            if (node.Body != null && (node.Body is System.Linq.Expressions.BinaryExpression
                                       || node.Body is System.Linq.Expressions.LambdaExpression))
                tabs.Add(currentTabs + 1);

            return base.VisitLambda<T>(node);
        }

        protected override Expression VisitParameter(ParameterExpression node)
        {
            int currentTabs;
            if (tabs.Count > 0)
            {
                currentTabs = tabs[tabs.Count - 1];
                tabs.RemoveAt(tabs.Count - 1);
            }
            else currentTabs = 0;

            for (int i = 0; i < currentTabs; i++) Console.Write("\t");
            Console.WriteLine("VisitParameter {0}", node.Name.ToString());
            return base.VisitParameter(node);
        }

        protected override Expression VisitConstant(ConstantExpression node)
        {
            int currentTabs;
            if (tabs.Count > 0)
            {
                currentTabs = tabs[tabs.Count - 1];
                tabs.RemoveAt(tabs.Count - 1);
            }
            else currentTabs = 0;

            for (int i = 0; i < currentTabs; i++) Console.Write("\t");
            Console.WriteLine("VisitConstant {0}", node.Value.ToString());
            return base.VisitConstant(node);
        }
    }

}
