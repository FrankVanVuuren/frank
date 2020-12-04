defmodule Frank.Environment do
  defstruct scope: %{},
            global: %{
              "+" => &__MODULE__.plus/2
            }

  def new(), do: %__MODULE__{}

  def get(env, symbol) do
    cond do
      Map.has_key?(env.scope, symbol) -> Map.get(env.scope, symbol)
      Map.has_key?(env.global, symbol) -> Map.get(env.global, symbol)
      true -> nil
    end
  end

  def plus(arguments, environment, accumulator \\ 0)
  def plus([], env, acc), do: {acc, env}

  def plus([car | cdr], env, acc) do
    plus(cdr, env, acc + car)
  end
end
