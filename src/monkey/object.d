module monkey.object;

import std.string : join;
import std.array : array;
import std.conv : to;
import monkey.env : Environment;
import monkey.ast : Identifier, BlockStatement;

alias BuiltinFn = IMonkeyObject function(IMonkeyObject[] args);
enum ObjectType : string
{
    nullObj = "NULL",
    errorObj = "ERROR",
    integerObj = "INTEGER",
    booleanObj = "BOOLEAN",
    stringObj = "STRING",
    returnValueObj = "RETURN_VALUE",
    functionObj = "FUNCTION",
    builtinObj = "BUILTIN",
    arrayObj = "ARRAY",
    hashObj = "HASH"
}

struct HashKey
{
    ObjectType type;
    ulong value;
}

interface IMonkeyObject
{
    ObjectType type();
    string inspect();
}

interface IHashable : IMonkeyObject
{
    HashKey hashKey();
}

class Integer : IHashable, IMonkeyObject
{
    long value;

    this(long value)
    {
        this.value = value;
    }

    ObjectType type()
    {
        return ObjectType.integerObj;
    }

    string inspect()
    {
        import std.conv : to;

        return value.to!string;
    }

    HashKey hashKey()
    {
        return HashKey(type(), cast(ulong) value);
    }
}

class Boolean : IHashable, IMonkeyObject
{
    bool value;

    this(bool value)
    {
        this.value = value;
    }

    this(bool value) immutable
    {
        this.value = value;
    }

    ObjectType type()
    {
        return ObjectType.booleanObj;
    }

    string inspect()
    {
        import std.conv : to;

        return value.to!string;
    }

    HashKey hashKey()
    {
        return HashKey(type(), cast(ulong) value);
    }
}

class Null : IMonkeyObject
{
    ObjectType type()
    {
        return ObjectType.nullObj;
    }

    string inspect()
    {
        return "null";
    }
}

class ReturnValue : IMonkeyObject
{
    IMonkeyObject value;

    this(IMonkeyObject value)
    {
        this.value = value;
    }

    ObjectType type()
    {
        return ObjectType.returnValueObj;
    }

    string inspect()
    {
        return value.inspect();
    }
}

class MonkeyError : IMonkeyObject
{
    string msg;

    this(string msg)
    {
        this.msg = msg;
    }

    ObjectType type()
    {
        return ObjectType.errorObj;
    }

    string inspect()
    {
        return "ERROR: " ~ msg;
    }
}

class Function : IMonkeyObject
{
    Identifier[] params;
    BlockStatement body;
    Environment env;

    this(Identifier[] params, BlockStatement body, Environment env)
    {
        this.params = params;
        this.body = body;
        this.env = env;
    }

    ObjectType type()
    {
        return ObjectType.functionObj;
    }

    string inspect()
    {
        string[] parameters;
        foreach (p; params)
        {
            parameters ~= p.toStr();
        }
        return "fn(" ~ parameters.join(", ") ~ ") {\n" ~ body.toString() ~ "\n}";
    }
}

class Builtin : IMonkeyObject
{
    BuiltinFn fn;

    this(BuiltinFn fn)
    {
        this.fn = fn;
    }

    ObjectType type()
    {
        return ObjectType.builtinObj;
    }

    string inspect()
    {
        return "builtin function";
    }
}

class String : IMonkeyObject, IHashable
{
    string value;

    this(string value)
    {
        this.value = value;
    }

    ObjectType type()
    {
        return ObjectType.stringObj;
    }

    string inspect()
    {
        return value;
    }

    HashKey hashKey()
    {
        ulong hash = 0xcbf29ce484222325;
        foreach (c; value)
        {
            hash ^= c;
            hash *= 0x100000001b3;
        }
        return HashKey(type(), hash);
    }
}

class Array : IMonkeyObject
{
    IMonkeyObject[] elems;

    this(IMonkeyObject[] elems)
    {
        this.elems = elems;
    }

    ObjectType type()
    {
        return ObjectType.arrayObj;
    }

    string inspect()
    {
        string[] elements;
        foreach (e; elems)
        {
            elements ~= e.inspect();
        }
        return "[" ~ elements.join(", ") ~ "]";
    }
}

class Hash : IMonkeyObject
{
    private struct HashPair
    {
        IMonkeyObject key;
        IMonkeyObject value;
    }

    HashPair[HashKey] pairs;

    this(HashPair[HashKey] pairs)
    {
        this.pairs = pairs;
    }

    ObjectType type()
    {
        return ObjectType.hashObj;
    }

    string inspect()
    {
        string[] pairStrs;
        foreach (pair; pairs)
        {
            pairStrs ~= pair.key.inspect() ~ ": " ~ pair.value.inspect();
        }
        return "{" ~ pairStrs.join(", ") ~ "}";
    }
}
