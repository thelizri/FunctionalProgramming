defmodule Env do

  def new() do
    []
  end


  def add(key, str, env) do
    [{key, str} | env]
  end


  def lookup(key, env) do
    List.keyfind(env, key, 0)
  end


  def remove(keys, env) do
    List.foldr(keys, env, fn(key, env) ->
      List.keydelete(env, key, 0)
    end)
  end

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error -> :error
        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    List.zip([pars, args]) ++ env
  end

end