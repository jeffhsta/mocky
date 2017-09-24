# TODO: make it auto create those functions based on the real module
defmodule Mocky.Module do
  defmacro __using__([module: original_module_quoted, from: mock_module_quoted]) do
    mock_module = Mocky.Module.parse_quoted_module(mock_module_quoted)

    original_module_quoted
    |> Mocky.Module.parse_quoted_module()
    |> fn module -> module.__info__(:functions) end.()
    |> Enum.map(&generate_macro(mock_module, &1))
  end

  def parse_quoted_module(module_quoted) do
    {_, _, module_data} = module_quoted
    "Elixir.#{module_data |> Enum.join(".")}" |> String.to_atom
  end

  def generate_macro(mock_module, {function_name, 0}) do
    quote do
      def unquote(:"#{function_name}")() do
        module = unquote(mock_module)
        function_name = unquote(function_name)

        Mocky.StateManager.update_call_counter(module, function_name, [])
      end
    end
  end

  def generate_macro(mock_module, {function_name, 1}) do
    quote do
      def unquote(:"#{function_name}")(arg1) do
        module = unquote(mock_module)
        function_name = unquote(function_name)

        Mocky.StateManager.update_call_counter(module, function_name, [arg1])
      end
    end
  end

  def generate_macro(mock_module, {function_name, 2}) do
    quote do
      def unquote(:"#{function_name}")(arg1, arg2) do
        module = unquote(mock_module)
        function_name = unquote(function_name)

        Mocky.StateManager.update_call_counter(module, function_name, [arg1, arg2])
      end
    end
  end

  def generate_macro(mock_module, {function_name, 3}) do
    quote do
      def unquote(:"#{function_name}")(arg1, arg2, arg3) do
        module = unquote(mock_module)
        function_name = unquote(function_name)

        Mocky.StateManager.update_call_counter(module, function_name, [arg1, arg2, arg3])
      end
    end
  end

  def generate_macro(mock_module, {function_name, 4}) do
    quote do
      def unquote(:"#{function_name}")(arg1, arg2, arg3, arg4) do
        module = unquote(mock_module)
        function_name = unquote(function_name)

        Mocky.StateManager.update_call_counter(module, function_name, [arg1, arg2, arg3, arg4])
      end
    end
  end
end
