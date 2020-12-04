defmodule Frank.Interpreter do
  alias Frank.Environment, as: Env

  def evaluate({"\"" <> _ = string, env}) do
    {String.slice(string, 1, String.length(string) - 2), env}
  end

  def evaluate({number, env}) when is_number(number) do
    "welcome back to hell, fix me plz"
  end

  def evaluate({[[func | args]], env}) when is_binary(func) do
    Env.get(env, func).(args, env)
  end

  def evaluate(ast) when is_list(ast) do
    evaluate({ast, Env.new()})
  end

  def evaluate({[car | []], env}) do
    {value, _env} = evaluate({car, env})
    value
  end

  def evaluate({[car | cdr], env}) do
    {_, new_env} = evaluate({car, env})
    evaluate({cdr, new_env})
  end
end
