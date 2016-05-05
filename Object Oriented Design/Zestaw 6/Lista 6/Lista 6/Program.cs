using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    class Program
    {
        static void Main(string[] args)
        {
            //ZADANIE 1 - NULL OBJECT
            Console.WriteLine("\nZADANIE 1 - NULL OBJECT\n");
            ILogger logger1 = LoggerFactory.Instance.GetLogger(LogType.File, "foo.txt");
            logger1.Log("foo bar");

            ILogger logger2 = LoggerFactory.Instance.GetLogger(LogType.None);
            logger2.Log("qux");

            Console.WriteLine("Sprawdzić plik foo.txt!");

            //ZADANIE 2 - INTERPRETER
            Console.WriteLine("\nZADANIE 2 - INTERPRETER\n");

            //Wyrażenie (p && q) || !r
            AbstractExpression exp = new Or(new And(new ConstExpression("p"), new ConstExpression("q")), new Not(new ConstExpression("r")));
            Context context = new Context();

            context.SetValue("q", false);
            context.SetValue("p", true);
            context.SetValue("r", false);

            Console.WriteLine("Wyrażenie ((p && q) || !r) dla wartości zmiennych:\np = {0}\nq = {1}\nr = {2}\nma wartość {3}",
                context.GetValue("p"),
                context.GetValue("q"),
                context.GetValue("r"),
                exp.Interpret(context));

            //ZADANIE 3 - TREE VISITOR
            Console.WriteLine("\nZADANIE 3 - TREE VISITOR\n");

            //Visitor nieświadomy budowy drzewa
            Console.WriteLine("Visitor nieświadomy budowy drzewa");

            Tree root = new TreeNode()
            {
                Left = new TreeNode() 
                {
                    Left = new TreeLeaf(),
                    Right = new TreeNode() 
                    {
                        Left = new TreeLeaf(),
                        Right = new TreeLeaf()
                    }
                },

                Right = new TreeNode() 
                {
                    Left = new TreeLeaf(),
                    Right = new TreeNode() 
                    {
                        Left = new TreeLeaf(),
                        Right = new TreeNode() 
                        {
                            Left = new TreeLeaf(),
                            Right = new TreeLeaf()
                        }
                    }
                }
            };

            //Wysokość drzewa = 5

            HeightVisitorUnaware unawareVisitor = new HeightVisitorUnaware();
            root.Accept(unawareVisitor);

            Console.WriteLine("Max wysokość drzewa to {0}\n", unawareVisitor.Height);

            //Visitor świadomy budowy drzewa
            Console.WriteLine("Visitor świadomy budowy drzewa");

            HeightVisitorAware awareVisitor = new HeightVisitorAware();
            awareVisitor.Visit(root);

            Console.WriteLine("Max wysokość drzewa to {0}", awareVisitor.Height);

            //ZADANIE 4 - EXPRESSION VISITOR
            Console.WriteLine("\nZADANIE 4 - EXPRESSION VISITOR\n");

            DiagramExpressionVistor diagramVisitor = new DiagramExpressionVistor();

            System.Linq.Expressions.Expression<Func<int, int, bool>> lambdaExp = (i, j) => (i < 5 && i < j) || (i > 45 && i < 100);
            diagramVisitor.Visit(lambdaExp);
        }
    }
}
