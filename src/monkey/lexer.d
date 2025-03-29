module monkey.lexer;

import std.conv : to;
import monkey.token;

struct Lexer
{
    string input;
    int pos;
    int readPos;
    dchar ch;

    this(string input)
    {
        this.input = input;
        readChar();
    }

    Token nextToken()
    {
        skipWhitespace();

        switch (ch)
        {
        case '=':
            if (peekChar() == '=')
            {
                dchar temp = ch;
                readChar();
                return Token(TTEnum.EQ, temp.to!string ~ ch.to!string);
            }
            return Token(TTEnum.ASSIGN, ch.to!string);
        case '+':
            return Token(TTEnum.PLUS, ch.to!string);
        case '-':
            return Token(TTEnum.MINUS, ch.to!string);
        case '!':
            if (peekChar() == '=')
            {
                dchar temp = ch;
                readChar();
                return Token(TTEnum.NOT_EQ, temp.to!string ~ ch.to!string);
            }
            return Token(TTEnum.BANG, ch.to!string);
        case '/':
            return Token(TTEnum.SLASH, ch.to!string);
        case '*':
            return Token(TTEnum.ASTERISK, ch.to!string);
        case '<':
            return Token(TTEnum.LT, ch.to!string);
        case '>':
            return Token(TTEnum.GT, ch.to!string);
        case ';':
            return Token(TTEnum.SEMICOLON, ch.to!string);
        case ':':
            return Token(TTEnum.COLON, ch.to!string);
        case ',':
            return Token(TTEnum.COMMA, ch.to!string);
        case '{':
            return Token(TTEnum.LBRACE, ch.to!string);
        case '}':
            return Token(TTEnum.RBRACE, ch.to!string);
        case '(':
            return Token(TTEnum.LPAREN, ch.to!string);
        case ')':
            return Token(TTEnum.RPAREN, ch.to!string);
        case '[':
            return Token(TTEnum.LBRACKET, ch.to!string);
        case ']':
            return Token(TTEnum.RBRACKET, ch.to!string);
        case '"':
            return Token(TTEnum.STRING, readString());
        case 0:
            return Token(TTEnum.EOF, "");
        default:
            if (isLetter(ch))
            {
                string ident = readIdentifier();
                return Token(lookupIdent(ident), ident);
            }
            if (isDigit(ch))
            {
                return Token(TTEnum.INT, readNumber());
            }
            return Token(TTEnum.ILLEGAL, ch.to!string);
        }

        readChar();
        return Token(TTEnum.ILLEGAL, ch.to!string);
    }

    void skipWhitespace()
    {
        while (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r')
        {
            readChar();
        }
    }

    void readChar()
    {
        if (readPos >= input.length)
        {
            ch = '\0';
        }
        else
        {
            ch = input[readPos];
        }
        pos = readPos++;
    }

    dchar peekChar()
    {
        return (readPos >= input.length) ? '\0' : input[readPos];
    }

    string readIdentifier()
    {
        int start = pos;
        while (isLetter(ch))
        {
            readChar();
        }
        return input[start .. pos];
    }

    string readNumber()
    {
        int start = pos;
        while (isDigit(ch))
        {
            readChar();
        }
        return input[start .. pos];
    }

    string readString()
    {
        int start = pos + 1;
        while (true)
        {
            readChar();
            if (ch == '"' || ch == '\0')
            {
                break;
            }
        }
        return input[start .. pos];
    }

    bool isDigit(dchar c) @safe pure nothrow
    {
        return '0' <= c && c <= '9';
    }

    bool isLetter(dchar c) @safe pure nothrow
    {
        return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '_';
    }
}
