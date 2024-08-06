defmodule Token do
  defstruct token_type: nil, literal: nil

  token_types = [
    illegal: {"ILLEGAL"},
    eof: {"EOF"},
    assign: {"="},
    eq: {"=="},
    not_eq: {"!="},
    ident: {"IDENT"},
    int: {"INT"},
    plus: {"+"},
    comma: {","},
    semicolon: {";"},
    colon: {":"},
    minus: {"-"},
    bang: {"!"},
    slash: {"/"},
    asterisk: {"*"},
    lt: {"<"},
    gt: {">"},
    lparen: {"("},
    rparen: {")"},
    lbrace: {"{"},
    rbrace: {"}"},
    lbracket: {"["},
    rbracket: {"]"},
    function: {"FUNCTION"},
    let: {"LET"},
    true: {"TRUE"},
    false: {"FALSE"},
    if: {"IF"},
    else: {"ELSE"},
    return: {"RETURN"},
    string: {"STRING"}
  ]

  for {function_name, {value}} <- token_types do
    def unquote(function_name)(), do: unquote(value)
  end

  def new(token_type, literal) do
    %Token{token_type: token_type, literal: literal}
  end

  @spec keyword(String.t()) :: String.t()
  def keyword(value) do
    case value do
      "fn" -> "FUNCTION"
      "let" -> "LET"
      "true" -> "TRUE"
      "false" -> "FALSE"
      "if" -> "IF"
      "else" -> "ELSE"
      "return" -> "RETURN"
      _ -> "IDENT"
    end
  end

  defimpl String.Chars, for: Token do
    def to_string(token) do
      "{#{token.token_type} ^ #{token.literal} }"
    end
  end
end
