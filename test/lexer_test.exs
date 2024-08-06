defmodule LexerTests do
  use ExUnit.Case

  test "validate lexer" do
    input = """
    let five = 5;
    let ten = 10;

    let add = fn(x, y) {
      x + y;
    };

    let result = add(five, ten);
    !-/*5;
    5 < 10 > 5;

    if (5 < 10) {
      return true;
    } else {
      return false;
    }

    10 == 10;
    10 != 9;
    "foobar"
    "foo bar"
    [1, 2];
    {"foo": "bar"}
    """

    expected = [
      %Token{token_type: Token.let(), literal: "let"},
      %Token{token_type: Token.ident(), literal: "five"},
      %Token{token_type: Token.assign(), literal: "="},
      %Token{token_type: Token.int(), literal: "5"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.let(), literal: "let"},
      %Token{token_type: Token.ident(), literal: "ten"},
      %Token{token_type: Token.assign(), literal: "="},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.let(), literal: "let"},
      %Token{token_type: Token.ident(), literal: "add"},
      %Token{token_type: Token.assign(), literal: "="},
      %Token{token_type: Token.function(), literal: "fn"},
      %Token{token_type: Token.lparen(), literal: "("},
      %Token{token_type: Token.ident(), literal: "x"},
      %Token{token_type: Token.comma(), literal: ","},
      %Token{token_type: Token.ident(), literal: "y"},
      %Token{token_type: Token.rparen(), literal: ")"},
      %Token{token_type: Token.lbrace(), literal: "{"},
      %Token{token_type: Token.ident(), literal: "x"},
      %Token{token_type: Token.plus(), literal: "+"},
      %Token{token_type: Token.ident(), literal: "y"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.rbrace(), literal: "}"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.let(), literal: "let"},
      %Token{token_type: Token.ident(), literal: "result"},
      %Token{token_type: Token.assign(), literal: "="},
      %Token{token_type: Token.ident(), literal: "add"},
      %Token{token_type: Token.lparen(), literal: "("},
      %Token{token_type: Token.ident(), literal: "five"},
      %Token{token_type: Token.comma(), literal: ","},
      %Token{token_type: Token.ident(), literal: "ten"},
      %Token{token_type: Token.rparen(), literal: ")"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.bang(), literal: "!"},
      %Token{token_type: Token.minus(), literal: "-"},
      %Token{token_type: Token.slash(), literal: "/"},
      %Token{token_type: Token.asterisk(), literal: "*"},
      %Token{token_type: Token.int(), literal: "5"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.int(), literal: "5"},
      %Token{token_type: Token.lt(), literal: "<"},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.gt(), literal: ">"},
      %Token{token_type: Token.int(), literal: "5"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.if(), literal: "if"},
      %Token{token_type: Token.lparen(), literal: "("},
      %Token{token_type: Token.int(), literal: "5"},
      %Token{token_type: Token.lt(), literal: "<"},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.rparen(), literal: ")"},
      %Token{token_type: Token.lbrace(), literal: "{"},
      %Token{token_type: Token.return(), literal: "return"},
      %Token{token_type: Token.true(), literal: "true"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.rbrace(), literal: "}"},
      %Token{token_type: Token.else(), literal: "else"},
      %Token{token_type: Token.lbrace(), literal: "{"},
      %Token{token_type: Token.return(), literal: "return"},
      %Token{token_type: Token.false(), literal: "false"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.rbrace(), literal: "}"},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.eq(), literal: "=="},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.int(), literal: "10"},
      %Token{token_type: Token.not_eq(), literal: "!="},
      %Token{token_type: Token.int(), literal: "9"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.string(), literal: "foobar"},
      %Token{token_type: Token.string(), literal: "foo bar"},
      %Token{token_type: Token.lbracket(), literal: "["},
      %Token{token_type: Token.int(), literal: "1"},
      %Token{token_type: Token.comma(), literal: ","},
      %Token{token_type: Token.int(), literal: "2"},
      %Token{token_type: Token.rbracket(), literal: "]"},
      %Token{token_type: Token.semicolon(), literal: ";"},
      %Token{token_type: Token.lbrace(), literal: "{"},
      %Token{token_type: Token.string(), literal: "foo"},
      %Token{token_type: Token.colon(), literal: ":"},
      %Token{token_type: Token.string(), literal: "bar"},
      %Token{token_type: Token.rbrace(), literal: "}"},
      %Token{token_type: Token.eof(), literal: ""}
    ]

    tokens = Lexer.tokenize(input)

    assert length(tokens) == length(expected)

    Enum.zip(expected, tokens)
    |> Enum.each(fn t -> assert elem(t, 0) == elem(t, 1) end)
  end
end
