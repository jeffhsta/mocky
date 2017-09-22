# TODO: make it auto create those functions based on the real module
defmodule Mocky.Module do
  defmacro __using__([module: module]) do
    quote do
      module = unquote(module)
      module.__info__(:functions) |> IO.inspect(label: "functions to mock")
      unquote(Mocky.Module.generate_func(__MODULE__, :negative, 1))
    end
    # :functions
    # |> module.__info__()
    # |> Enum.map(fn {name, num_args} ->
    #   Mock.Main.generate_func(module, name, num_args)
    # end)
  end

  def generate_func(module, function, num_args) do
    IO.puts("Creating macro #{module}.#{function}/#{num_args}")
    quote do
      def unquote(:"#{function}/#{num_args}")() do
        IO.puts("Calling #{unquote(module)}")

        Agent.get(module, fn state ->
          state
          |> Map.get(unquote(:"#{function}/#{num_args}"), %{})
          |> Map.get(:stub)
        end)
      end
    end
  end
end
