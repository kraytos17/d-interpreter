module monkey.env;

import monkey.object : IMonkeyObject;

struct Environment
{
    private IMonkeyObject[string] store;
    Environment* outer;

    static Environment newEnv()
    {
        return Environment(null);
    }

    static Environment newEnclosedEnv(Environment* outer)
    {
        auto env = Environment.newEnv();
        env.outer = outer;
        return env;
    }

    IMonkeyObject get(string name, ref bool found)
    {
        if (name in store)
        {
            found = true;
            return store[name];
        }
        if (outer !is null)
        {
            return outer.get(name, found);
        }
        found = false;
        return null;
    }

    void set(string name, IMonkeyObject val)
    {
        store[name] = val;
    }
}
