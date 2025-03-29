module monkey.ast;

import std.stdio;
import std.array;
import std.format;
import monkey.token;

interface INode
{
    string tokenLiteral();
    string toStr();
}

interface IStatement : INode
{
    void statementNode();
}

interface IExpression : INode
{
    void expressionNode();
}

class Program : INode
{
    IStatement[] statements;
    
    this(IStatement[] statements)
    {
        this.statements = statements;
    }

    string tokenLiteral()
    {
        return statements.length > 0 ? statements[0].tokenLiteral() : "";
    }

    string toStr()
    {
        Appender!string o;
        foreach (s; statements)
        {
            o.put(s.toStr());
        }

        return o.data;
    }
}

class LetStatement : IStatement
{
    Token token;
    Identifier name;
    IExpression value;
    
    this(Token token, Identifier name, IExpression value)
    {
        this.token = token;
        this.name = name;
        this.value = value;
    }

    void statementNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        o.put(tokenLiteral());
        o.put(" ");
        o.put(name.toStr());
        o.put(" = ");

        if (value !is null)
        {
            o.put(value.toStr());
        }

        o.put(";");
        return o.data;
    }
}

class ReturnStatement : IStatement
{
    Token token;
    IExpression returnValue;
    
    this(Token token, IExpression returnValue)
    {
        this.token = token;
        this.returnValue = returnValue;
    }

    void statementNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        o.put(tokenLiteral());
        o.put(" ");

        if (returnValue !is null)
        {
            o.put(returnValue.toStr());
        }

        o.put(";");
        return o.data;
    }
}

class ExpressionStatement : IStatement
{
    Token token;
    IExpression expression;
    
    this(Token token, IExpression expression)
    {
        this.token = token;
        this.expression = expression;
    }

    void statementNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return expression !is null ? expression.toStr() : "";
    }
}

class BlockStatement : IStatement
{
    Token token;
    IStatement[] statements;
    
    this(Token token, IStatement[] statements)
    {
        this.token = token;
        this.statements = statements;
    }

    void statementNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        foreach (s; statements)
        {
            o.put(s.toStr());
        }

        return o.data;
    }
}

class Identifier : IExpression
{
    Token token;
    string value;
    
    this(Token token, string value)
    {
        this.token = token;
        this.value = value;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return value;
    }
}

class Boolean : IExpression
{
    Token token;
    bool value;
    
    this(Token token, bool value)
    {
        this.token = token;
        this.value = value;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return token.literal;
    }
}

class IntegerLiteral : IExpression
{
    Token token;
    long value;
    
    this(Token token, long value)
    {
        this.token = token;
        this.value = value;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return token.literal;
    }
}

class PrefixExpression : IExpression
{
    Token token;
    string operator;
    IExpression right;
    
    this(Token token, string operator, IExpression right)
    {
        this.token = token;
        this.operator = operator;
        this.right = right;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return format("(%s%s)", operator, right.toStr());
    }
}

class InfixExpression : IExpression
{
    Token token;
    IExpression left;
    string operator;
    IExpression right;
    
    this(Token token, IExpression left, string operator, IExpression right)
    {
        this.token = token;
        this.left = left;
        this.operator = operator;
        this.right = right;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return format("(%s %s %s)", left.toStr(), operator, right.toStr());
    }
}

class IfExpression : IExpression
{
    Token token;
    IExpression cond;
    BlockStatement consequence;
    BlockStatement alt;
    
    this(Token token, IExpression cond, BlockStatement consequence, BlockStatement alt)
    {
        this.token = token;
        this.cond = cond;
        this.consequence = consequence;
        this.alt = alt;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        o.put("if");
        o.put(cond.toStr());
        o.put(" ");
        o.put(consequence.toStr());

        if (alt !is null)
        {
            o.put("else");
            o.put(alt.toStr());
        }
        return o.data;
    }
}

class FunctionLiteral : IExpression
{
    Token token;
    Identifier[] parameters;
    BlockStatement body;
    
    this(Token token, Identifier[] parameters, BlockStatement body)
    {
        this.token = token;
        this.parameters = parameters;
        this.body = body;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        string[] params;
        foreach (p; parameters)
        {
            params ~= p.toString();
        }

        o.put(tokenLiteral());
        o.put("(");
        o.put(join(params, ", "));
        o.put(") ");
        o.put(body.toStr());

        return o.data;
    }
}

class CallExpression : IExpression
{
    Token token;
    IExpression func;
    IExpression[] arguments;
    
    this(Token token, IExpression func, IExpression[] arguments)
    {
        this.token = token;
        this.func = func;
        this.arguments = arguments;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        string[] args;
        foreach (a; arguments)
        {
            args ~= a.toStr();
        }

        o.put(func.toStr());
        o.put("(");
        o.put(join(args, ", "));
        o.put(")");

        return o.data;
    }
}

class StringLiteral : IExpression
{
    Token token;
    string value;
    
    this(Token token, string value)
    {
        this.token = token;
        this.value = value;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return token.literal;
    }
}

class ArrayLiteral : IExpression
{
    Token token;
    IExpression[] elements;

    this(Token token, IExpression[] elements)
    {
        this.token = token;
        this.elements = elements;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        string[] els;
        foreach (el; elements)
        {
            els ~= el.toStr();
        }

        o.put("[");
        o.put(join(els, ", "));
        o.put("]");

        return o.data;
    }
}

class IndexExpression : IExpression
{
    Token token;
    IExpression left;
    IExpression index;
    
    this(Token token, IExpression left, IExpression index)
    {
        this.token = token;
        this.left = left;
        this.index = index;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        return format("(%s[%s])", left.toStr(), index.toStr());
    }
}

class HashLiteral : IExpression
{
    Token token;
    IExpression[IExpression] pairs;
    
    this(Token token, IExpression[IExpression] pairs)
    {
        this.token = token;
        this.pairs = pairs;
    }

    void expressionNode()
    {
    }

    string tokenLiteral()
    {
        return token.literal;
    }

    string toStr()
    {
        Appender!string o;
        string[] pairStrings;

        foreach (key, value; pairs)
        {
            pairStrings ~= format("%s:%s", key.toStr(), value.toStr());
        }

        o.put("{");
        o.put(join(pairStrings, ", "));
        o.put("}");

        return o.data;
    }
}
