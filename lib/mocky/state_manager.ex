defmodule Mocky.StateManager do
  @initial_function_mock %{stub: nil, called: 0}

  def update_call_counter(module, function, args) do
    Agent.update(module, fn state ->
      state
      |> Keyword.get(function, %{})
      |> Map.get(args, @initial_function_mock)
      |> fn x -> %{x | called: x.called + 1} end.()
      |> update_state(state, function, args)
    end)
  end

  def call_counter(module, function, :any) do
    Agent.get(module, fn state ->
      function_mocks =
        state
        |> Keyword.get(function, %{})

      function_mocks
      |> Map.keys()
      |> Enum.reduce(0, fn key, acc ->
        function_mocks
        |> Map.get(key)
        |> Map.get(:called)
        |> Kernel.+(acc)
      end)
    end)
  end

  def call_counter(module, function, args) do
    Agent.get(module, fn state ->
      state
      |> Keyword.get(function, %{})
      |> Map.get(args, @initial_function_mock)
      |> Map.get(:called)
    end)
  end

  defp update_state(function_mock, state, function, args) do
    function_mocks =
      state
      |> Keyword.get(function, %{})
      |> Map.put(args, function_mock)

    state
    |> Keyword.put(function, function_mocks)
  end
end

# [
#   function_name: %{
#     [] => %{stub: nil, called: 0},
#     [1] => %{stub: nil, called: 0}
#   }
# ]
