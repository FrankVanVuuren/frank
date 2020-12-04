defmodule Frank.Parser do
  def parse(source) when is_binary(source) do
    source
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
    |> string_joiner()
    |> parse()
  end

  def parse(["(" | rest]) do
    list_body = parse(rest)

    new_rest =
      rest
      |> Enum.drop(length(list_body) + 1)
      |> parse()

    [list_body | new_rest]
  end

  def parse([")" | _rest]), do: []

  def parse([token | rest]) do
    atom =
      case Float.parse(token) do
        {value, ""} -> value
        :error -> token
      end

    [atom | parse(rest)]
  end

  def parse([]), do: []

  defp string_joiner(list, acc \\ [])

  defp string_joiner([], acc), do: acc

  defp string_joiner([car | cdr], acc) do
    cond do
      String.starts_with?(car, "\"") && String.ends_with?(car, "\"") ->
        string_joiner(cdr, acc ++ [car])

      String.starts_with?(car, "\"") ->
        [cadr | cddr] = cdr
        string_joiner([car <> " " <> cadr | cddr], acc)

      true ->
        string_joiner(cdr, acc ++ [car])
    end
  end
end
