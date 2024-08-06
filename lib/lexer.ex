defmodule Lexer do
  def tokenize(input) do
    chars = String.split(input, "", trim: true)
    tokenize(chars, [])
  end

  defp tokenize(chars = [ch | rest], tokens) do
    # IO.puts(chars)

    cond do
      is_whitespace(ch) -> tokenize(rest, tokens)
      is_letter(ch) -> read_identifier(chars, tokens)
      is_digit(ch) -> read_number(chars, tokens)
      is_two_char(chars) -> read_two_characters(chars, tokens)
      is_quote(ch) -> read_string(chars, tokens)
      true -> read_next_char(chars, tokens)
    end
  end

  defp tokenize(_chars = [], tokens) do
    Enum.reverse([Token.new(Token.eof(), "") | tokens])
  end

  defp read_next_char(_chars = [ch | rest], tokens) do
    token =
      case ch do
        "=" -> Token.new(Token.assign(), ch)
        ";" -> Token.new(Token.semicolon(), ch)
        ":" -> Token.new(Token.colon(), ch)
        "(" -> Token.new(Token.lparen(), ch)
        ")" -> Token.new(Token.rparen(), ch)
        "[" -> Token.new(Token.lbracket(), ch)
        "]" -> Token.new(Token.rbracket(), ch)
        "{" -> Token.new(Token.lbrace(), ch)
        "}" -> Token.new(Token.rbrace(), ch)
        "<" -> Token.new(Token.lt(), ch)
        ">" -> Token.new(Token.gt(), ch)
        "+" -> Token.new(Token.plus(), ch)
        "-" -> Token.new(Token.minus(), ch)
        "*" -> Token.new(Token.asterisk(), ch)
        "/" -> Token.new(Token.slash(), ch)
        "!" -> Token.new(Token.bang(), ch)
        "," -> Token.new(Token.comma(), ch)
        _ -> Token.new(Token.illegal(), "")
      end

    tokenize(rest, [token | tokens])
  end

  defp read_identifier(chars, tokens),
    do:
      read_value(chars, tokens, &is_letter/1, fn identifier ->
        Token.new(Token.keyword(identifier), identifier)
      end)

  defp read_number(chars, tokens),
    do: read_value(chars, tokens, &is_digit/1, fn number -> Token.new(Token.int(), number) end)

  defp read_value(chars, tokens, split_fn, create_token_fn) do
    {value, rest} = Enum.split_while(chars, split_fn)
    value = Enum.join(value)
    token = create_token_fn.(value)
    tokenize(rest, [token | tokens])
  end

  defp read_two_characters(chars, tokens) do
    {literal, rest} = Enum.split(chars, 2)
    literal = Enum.join(literal)

    token =
      case literal do
        "==" -> Token.new(Token.eq(), literal)
        "!=" -> Token.new(Token.not_eq(), literal)
      end

    tokenize(rest, [token | tokens])
  end

  defp read_string([_quote | rest], tokens) do
    {string, [_quote | rest]} = Enum.split_while(rest, fn ch -> !is_quote(ch) end)
    string = Enum.join(string)
    token = Token.new(Token.string(), string)
    tokenize(rest, [token | tokens])
  end

  defp is_quote(ch), do: ch == "\""

  defp is_two_char(chars) do
    (Enum.at(chars, 0) == "!" || Enum.at(chars, 0) == "=") && Enum.at(chars, 1) == "="
  end

  defp is_whitespace(ch), do: ch == " " || ch == "\t" || ch == "\n" || ch == "\r"

  defp is_digit(ch), do: "0" <= ch && ch <= "9"

  defp is_letter(ch) do
    ("a" <= ch && ch <= "z") || ("A" <= ch && ch <= "Z") || ch == "_"
  end
end
