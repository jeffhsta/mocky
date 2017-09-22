defmodule Mocky.StateManager do
  def update_call_counter(module, function, args \\ []) do
    Agent.update(module, fn state ->
      key = %{function: function, args: args}
      function_mock =
        state
        |> Map.get(key, %{stub: nil, called: 0})
        |> fn x -> %{x | called: x.called + 1} end.()

      state |> Map.put(key, function_mock)
    end)
  end
end