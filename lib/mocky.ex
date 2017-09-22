defmodule Mocky do
  @moduledoc """
  Documentation for Mock.
  """

  @doc """
  Setup mock.

  ## Examples

  iex> import Mock
  iex> setup_mock(MyMock)
  """
  def setup_mock(module), do:
    Agent.start_link(fn -> %{} end, name: module)

  @doc """
  Stub.

  ## Examples

  iex> import Mock
  iex> stub(MyMock, :func)

  """
  # defmacro stub(module, function, do: code) do
  #   quote do
  #     module = unquote(module)
  #     function = unquote(function)
  #     stub_value = unquote(code)
  #
  #     Agent.update(module, fn state ->
  #       stub =
  #         state
  #         |> Map.get(:"#{function}", %{stub: nil, called: 0})
  #       stub = %{stub | stub: stub_value}
  #       state |> Map.put(:"#{function}", stub)
  #     end)
  #   end
  # end
  #
  # def process(arg) when is_function(arg), do: arg
  # def process(arg), do: fn -> arg end

  def stub(module, function), do:
    %{module: module, function: function, args: []}

  def with_args(s = %{module: _, function: _}, args), do:
    %{s | args: args}

  def then_return(%{module: module, function: function, args: args}, value) do
    Agent.update(module, fn state ->
      state
      |> Map.put(%{function: function, args: args}, %{stub: value, called: 0})
    end)
  end

  @doc """
  Verify called.

  ## Examples

  iex> import Mock
  iex> MyMock.func()
  iex> called(MyMock, :func)
  true

  """
  def called(module, function, args \\ []) do
    Agent.get(module, fn state ->
      state
      |> Map.get(%{function: function, args: args}, %{stub: nil, called: 0})
      |> Map.get(:called)
    end) > 0
  end
end
