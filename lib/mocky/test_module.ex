defmodule Mocky.RealModule do
  def negative(n), do: -n
end

defmodule Mocky.FakeModule do
  # use Mock.Module, module: Mock.RealModule
  def negative(n) do
    self() |> IO.inspect(label: "Mocky.FakeModule")
    Agent.update(__MODULE__, fn state ->
      fun_mock =
        state
        |> Map.get(%{function: :negative, args: [n]}, %{stub: nil, called: 0})

      fun_mock = %{fun_mock | called: fun_mock.called + 1}
      state |> Map.put(%{function: :negative, args: [n]}, fun_mock)
    end)

    Agent.get(__MODULE__, fn state ->
      state
      |> Map.get(%{function: :negative, args: [n]})
      |> Map.get(:stub)
    end)
  end

  def func_a, do: Mocky.StateManager.update_call_counter(__MODULE__, :func_a)
  def func_a(n) do
    Mocky.StateManager.update_call_counter(__MODULE__, :func_a, [n])
  end
end

defmodule Mocky.Exp do
  @module Application.get_env(:mocky, :module)

  def func(n), do: @module.negative(n)

  def some_func_a, do: @module.func_a()
  def some_func_a(n), do: @module.func_a(n)
end
