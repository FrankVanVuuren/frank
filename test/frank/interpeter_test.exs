defmodule Frank.InterpreterTest do
  use ExUnit.Case

  import Frank.{Interpreter, Parser}

  defp eval(frank_src), do: frank_src |> parse() |> evaluate()

  describe "evaluate atoms" do
    test "strings" do
      "hail satan" = eval(~s["hail satan"])
      "hail satan" = eval(~s["offer blood" "hail satan"])
    end
  end

  describe "operators" do
    test "+" do
      3.0 = eval(~s[(+ 1 2)])
    end
  end
end
