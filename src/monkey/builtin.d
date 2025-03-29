module monkey.builtin;

import monkey.object;

immutable builtins = [
    "len": new Builtin((IMonkeyObject[] args) {
        if (args.length != 1)
        {
            return Error("wrong number of arguments. got=%d, want=1", args.length);
        }

        auto arg = args[0];
        if (auto arr = cast(Array) arg)
        {
            return new Integer(arr.elements.length);
        }
        else if (auto str = cast(String) arg)
        {
            return new Integer(str.value.length);
        }
        else
        {
            return newError("argument to `len` not supported, got %s", arg.type());
        }
    }),

    "puts": new Builtin((IMonkeyObject[] args) {
        foreach (arg; args)
        {
            writeln(arg.inspect());
        }
        return nullObject;
    }),

    "first": new Builtin((IMonkeyObject[] args) {
        if (args.length != 1)
        {
            return newError("wrong number of arguments. got=%d, want=1", args.length);
        }
        if (args[0].type() != ObjectType.ARRAY)
        {
            return newError("argument to `first` must be ARRAY, got %s", args[0].type());
        }

        auto arr = cast(Array) args[0];
        return arr.elements.length > 0 ? arr.elements[0] : nullObject;
    }),

    "last": new Builtin((IMonkeyObject[] args) {
        if (args.length != 1)
        {
            return newError("wrong number of arguments. got=%d, want=1", args.length);
        }
        if (args[0].type() != ObjectType.ARRAY)
        {
            return newError("argument to `last` must be ARRAY, got %s", args[0].type());
        }

        auto arr = cast(Array) args[0];
        return arr.elements.length > 0 ? arr.elements[$ - 1] : nullObject;
    }),

    "rest": new Builtin((IMonkeyObject[] args) {
        if (args.length != 1)
        {
            return newError("wrong number of arguments. got=%d, want=1", args.length);
        }
        if (args[0].type() != ObjectType.ARRAY)
        {
            return newError("argument to `rest` must be ARRAY, got %s", args[0].type());
        }

        auto arr = cast(Array) args[0];
        if (arr.elements.length > 0)
        {
            return new Array(arr.elements[1 .. $].dup);
        }
        return nullObject;
    }),

    "push": new Builtin((IMonkeyObject[] args) {
        if (args.length != 2)
        {
            return newError("wrong number of arguments. got=%d, want=2", args.length);
        }
        if (args[0].type() != ObjectType.ARRAY)
        {
            return newError("argument to `push` must be ARRAY, got %s", args[0].type());
        }

        auto arr = cast(Array) args[0];
        auto newElements = arr.elements.dup;
        newElements ~= args[1];
        return new Array(newElements);
    })
];
