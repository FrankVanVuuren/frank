defmodule Frank.Parser do
  def parse(frank_src) when is_binary(frank_src) do
    remaining =
      frank_src
      |> String.replace("(", " ( ")
      |> String.replace(")", " ) ")
      |> String.split()

    parse({remaining, []})
  end

  def parse({["(" | cdr], acc}) do
    {remaining, list} = parse({cdr, []})
    parse({remaining, acc ++ [list]})
  end

  def parse({[")" | cdr], acc}) do
    {cdr, acc}
  end

  def parse({["\"" <> _ = car | cdr], acc}) do
    if String.ends_with?(car, "\"") do
      parse({cdr, acc ++ [car]})
    else
      [cadr | cddr] = cdr
      parse({[car <> " " <> cadr | cddr], acc})
    end
  end

  def parse({[car | cdr], acc}) do
    case Float.parse(car) do
      {value, ""} -> parse({cdr, acc ++ [value]})
      _ -> parse({cdr, acc ++ [car]})
    end
  end

  def parse({[], acc}), do: acc
end
