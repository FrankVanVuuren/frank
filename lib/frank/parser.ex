defmodule Frank.Parser do
  defmacro starts_with(x, y) do
    y_length = String.length(y)
    quote do
      binary_part(unquote(x), 0, unquote(y_length)) == unquote(y)
    end
  end

  defmacro ends_with(x, y) do
    y_length = String.length(y)
    quote do
      binary_part(unquote(x), byte_size(unquote(x)), unquote(0 - y_length)) == unquote(y)
    end
  end

  def parse(source) when is_binary(source) do
    source
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
    |> parse()
  end

  def parse([string | rest]) when starts_with(string, "\"") do
    string_chunks = [string | parse(rest)]

    new_rest = rest
               |> Enum.drop(length(string_chunks) + 1)
               |> parse()

    IO.inspect(rest, label: "rest")
    IO.inspect(string_chunks, label: "string chunks")
    IO.inspect(new_rest, label: "new_rest")

    [Enum.join(string_chunks, " ") | new_rest]
  end

  def parse([string | rest]) when ends_with(string, "\"") do
    [string]
  end

  def parse(["(" | rest]) do
    list_body = parse(rest)

    new_rest = rest
               |> Enum.drop(length(list_body) + 1)
               |> parse()

    [list_body | new_rest]
  end

  def parse([")" | _rest]), do: []

  def parse([token | rest]) do
    atom = case Float.parse(token) do
      {value, ""} -> value
      :error -> token
    end

    [atom | parse(rest)]
  end

  def parse([]), do: []
end
