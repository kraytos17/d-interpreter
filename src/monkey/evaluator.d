module monkey.evaluator;

import monkey.ast;
import monkey.object;
import monkey.env;

alias ObjBool = monkey.object.Boolean;

private immutable NULL = new immutable Null();
private immutable TRUE = new immutable ObjBool(true);
private immutable FALSE = new immutable ObjBool(false);

IMonkeyObject eval(INode node, ref Environment env)
{
    final switch (typeof(node))
    {
    case Program:
        return evalProgram(cast(Program) node, env);

    case BlockStatement:
        return evalBlockStatement(cast(BlockStatement) node, env);

    case ExpressionStatement:
        return eval(cast(ExpressionStatement) node.expression, env);

    case ReturnStatement:
        {
            auto val = eval(cast(ReturnStatement) node.returnValue, env);
            if (isError(val))
            {
                return val;
            }
            return new ReturnValue(val);
        }

    case LetStatement:
        {
            auto val = eval(cast(LetStatement) node.value, env);
            if (isError(val))
            {
                return val;
            }
            env.set(node.name.value, val);
        }

    case IntegerLiteral:
        return new IntegerLiteral(node.value);

    case StringLiteral:
        return new StringLiteral(node.value);

    case Boolean:
        return nativeBoolToBooleanObject(node.value);

    case PrefixExpression:
        {
            auto right = eval(cast(PrefixExpression) node.right, env);
            if (isError(right))
            {
                return right;
            }
            return evalPrefixExpression(node.operator, right);
        }

    case InfixExpression:
        {
            auto right = eval(cast(InfixExpression) node.right, env);
            if (isError(right))
            {
                return right;
            }

            auto left = eval(cast(InfixExpression) node.left, env);
            if (isError(left))
            {
                return left;
            }
            return evalInfixExpression(node.operator, left, right);
        }

    case IfExpression:
        return evalIfExpression(cast(IfExpression) node, env);

    case Identifier:
        return evalIdentifier(cast(Identifier) node, env);

    case FunctionLiteral:
        return new Function(node.parameters, node.body, env);

    case CallExpression:
        {
            auto func = eval(cast(CallExpression) node.func, env);
            if (isError(func))
            {
                return func;
            }

            auto args = evalExpressions(node.arguments, env);
            if (args.length == 1 && isError(args[0]))
            {
                return args[0];
            }
            return applyFunction(func, args);
        }

    case ArrayLiteral:
        {
            auto elems = evalExpressions(node.elements, env);
            if (elems.length == 1 && isError(elems[0]))
            {
                return elems[0];
            }
            return new Array(elems);
        }

    case IndexExpression:
        {
            auto left = eval(cast(IndexExpression) node.left, env);
            if (isError(left))
            {
                return left;
            }

            auto index = eval(cast(IndexExpression) node.index, env);
            if (isError(index))
            {
                return index;
            }
            return evalIndexExpression(left, index);
        }

    case HashLiteral:
        return evalHashLiteral(cast(HashLiteral) node, env);

    default:
        assert(0, "Unhandled node type: " ~ typeof(node).stringof);
    }
}

private IMonkeyObject evalProgram(Program program, Environment env)
{
    IMonkeyObject res;
    foreach (s; program.statements)
    {
        res = eval(s, env);
        if (typeid(res) == typeid(ReturnValue))
        {
            return (cast(ReturnValue) res).value;
        }
        else if (typeid(res) == typeid(Error))
        {
            return res;
        }
    }
    return res;
}

private IMonkeyObject evalBlockStatement(BlockStatement block, Environment env)
{
    IMonkeyObject res;

}
