module monkey.token;

alias TokenType = string;
enum TTEnum : TokenType
{
    ILLEGAL = "ILLEGAL",
    EOF = "EOF",
    IDENT = "IDENT",
    INT = "INT",
    STRING = "STRING",
    ASSIGN = "=",
    PLUS = "+",
    MINUS = "-",
    BANG = "!",
    ASTERISK = "*",
    SLASH = "/",
    LT = "<",
    GT = ">",
    EQ = "==",
    NOT_EQ = "!=",
    COMMA = ",",
    SEMICOLON = ";",
    COLON = ":",
    LPAREN = "(",
    RPAREN = ")",
    LBRACE = "{",
    RBRACE = "}",
    LBRACKET = "[",
    RBRACKET = "]",
    FUNCTION = "FUNCTION",
    LET = "LET",
    TRUE = "TRUE",
    FALSE = "FALSE",
    IF = "IF",
    ELSE = "ELSE",
    RETURN = "RETURN"
}

struct Token
{
    TokenType type;
    string literal;
    
    this(TokenType type, string literal)
    {
        this.type = type;
        this.literal = literal;
    }
}

immutable string[string] keywords = [
    "fn": TTEnum.FUNCTION,
    "let": TTEnum.LET,
    "true": TTEnum.TRUE,
    "false": TTEnum.FALSE,
    "if": TTEnum.IF,
    "else": TTEnum.ELSE,
    "return": TTEnum.RETURN
];

TokenType lookupIdent(string ident) pure @safe
{
    return keywords.get(ident, TTEnum.IDENT);
}
