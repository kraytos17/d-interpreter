module monkey.repl;

import std.stdio;
import std.range;
import std.conv : to;
import monkey.env : Environment;
import monkey.lexer : Lexer;
import monkey.parser;

immutable string PROMPT = ">>";

void start()
{
    auto env = Environment.newEnv();
    foreach (line; stdin.byLine())
    {
        write(PROMPT);
        if (line.empty)
        {
            continue;
        }

        auto lex = Lexer(line.to!string);
        auto parser = Parser(lex);
        auto prog = parser.parseProg();
        if (!parser.errors.empty)
        {
            printParserErrors(parser.errors);
            continue;
        }

        auto evaluated = Evaluator.eval(prog, env);
        if (evaluated !is null)
        {
            writeln(evaluated.inspect());
        }
    }
}

immutable string MONKEY_FACE = `
            __,__
   .--.  .-"     "-.  .--.
  / .. \/  .-. .-.  \/ .. \
 | |  '|  /   Y   \  |'  | |
 | \   \  \ 0 | 0 /  /   / |
  \ '- ,\.-"""""""-./, -' /
   ''-' /_   ^ ^   _\ '-''
       |  \._   _./  |
       \   \ '~' /   /
        '._ '-=-' _.'
           '-----'
`;

void printParserErrors(string[] errors)
{
    writeln(MONKEY_FACE);
    writeln("Woops! We ran into some monkey business here!");
    writeln("Parser errors:");
    foreach (msg; errors)
    {
        writeln("\t", msg);
    }
}
