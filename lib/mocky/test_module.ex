defmodule Mocky.RealModule do
  def some_func_a, do: :ok
  def some_func_a(_), do: :ok
  def an_existing_function, do: :ok
end

defmodule Mocky.FakeModule do
  # use Mock.Module, module: Mock.RealModule

  def func_a, do:
    Mocky.StateManager.update_call_counter(__MODULE__, :func_a, [])

  def func_a(n), do:
    Mocky.StateManager.update_call_counter(__MODULE__, :func_a, [n])
end

defmodule Mocky.Exp do
  @module Application.get_env(:mocky, :module)

  def some_func_a, do: @module.func_a()
  def some_func_a(n), do: @module.func_a(n)
end
