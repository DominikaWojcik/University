using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public class Context
    {
        Dictionary<string, bool> variables = new Dictionary<string,bool>();

        public bool GetValue(string VariableName)
        {
            if (!variables.ContainsKey(VariableName)) throw new ArgumentException();
            return variables[VariableName];
        }

        public void SetValue(string VariableName, bool Value)
        {
            if (variables.ContainsKey(VariableName))
                variables[VariableName] = Value;
            else variables.Add(VariableName, Value);
        }
    }

    public abstract class AbstractExpression
    {
        public abstract bool Interpret(Context context);
    }

    public class ConstExpression : AbstractExpression
    {
        private bool value;
        private string variable;

        public ConstExpression(bool value)
        {
            this.value = value;
            variable = null;
        }

        public ConstExpression(string variable)
        {
            this.variable = variable;
        }

        public override bool Interpret(Context context)
        {
            if (variable == null) return value;
            return context.GetValue(variable);
        }
    }

    public abstract class BinaryExpression : AbstractExpression
    {
        protected AbstractExpression left, right;

        //TODO naprawić to
        public BinaryExpression(AbstractExpression left, AbstractExpression right)
        {
            this.left = left;
            this.right = right;
        }
    }

    public class And : BinaryExpression
    {
        public And(AbstractExpression left, AbstractExpression right) : base(left, right)
        {
        }

        public override bool Interpret(Context context)
        {
            return left.Interpret(context) && right.Interpret(context);
        }
    }

    public class Or : BinaryExpression
    {
        public Or(AbstractExpression left, AbstractExpression right) : base(left, right)
        {
        }

        public override bool Interpret(Context context)
        {
            return left.Interpret(context) || right.Interpret(context);
        }
    }

    public abstract class UnaryExpression : AbstractExpression
    {
        protected AbstractExpression expr;

        public UnaryExpression(AbstractExpression expr)
        {
            this.expr = expr;
        }
    }

    public class Not : UnaryExpression
    {
        public Not(AbstractExpression expr) : base(expr)
        {
        }

        public override bool Interpret(Context context)
        {
            return !expr.Interpret(context);
        }
    }
}
