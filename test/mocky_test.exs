defmodule MockyTest do
  use ExUnit.Case, async: true
  import Mocky

  @module Application.get_env(:mocky, :module)

  setup do
    setup_mock(Mocky.FakeModule)
    :ok
  end

  describe "Test called function for mock functions" do
    test "should return true when mock function was called" do
      Mocky.Exp.some_func_a()

      assert called(@module, :func_a)
    end

    test "should return true when mock function was called with correct args" do
      Mocky.Exp.some_func_a(1)

      assert called(@module, :func_a, [1])
    end

    test "should return false when mock function was called with wrong args" do
      Mocky.Exp.some_func_a(1)

      refute called(@module, :func_a, [2])
    end

    test "should return true when mock function was called without inform the args" do
      Mocky.Exp.some_func_a(1)

      assert called(@module, :func_a)
    end

    test "should return true when mock function was called with the same args" do
      Mocky.Exp.some_func_a(1)

      assert called(@module, :func_a, [1])
      refute called(@module, :func_a, [2])
    end
  end

  describe "Test auto create functions" do
    test "should raise an error when the called function does not exists" do
      defmodule Mocky.Test.OriginalModule do
        def some_function, do: :ok
      end

      defmodule Mocky.Test.FakeModule do
        # No function here
      end

      refute Mocky.Test.OriginalModule.some_function() |> is_nil
      assert_raise UndefinedFunctionError, fn -> Mocky.Test.FakeModule.some_function() end
    end

    test "should create function automatically based on original module" do
      assert Mocky.FakeModule.an_existing_function() ==
        Mocky.RealModule.an_existing_function()
    end

    test "should create function with one argument automatically based on original module" do
      refute Mocky.RealModule.an_existing_function(1)  |> is_nil
      Mocky.FakeModule.an_existing_function(1)
    end

    test "should create function with any arguments dynamically" do
      refute Mocky.RealModule.an_existing_function(1)  |> is_nil
      refute Mocky.RealModule.an_existing_function(1, 2)  |> is_nil
      refute Mocky.RealModule.an_existing_function(1, 2, 3)  |> is_nil
      refute Mocky.RealModule.an_existing_function(1, 2, 3, 4)  |> is_nil

      Mocky.FakeModule.an_existing_function(1)
      Mocky.FakeModule.an_existing_function(1, 2)
      Mocky.FakeModule.an_existing_function(1, 2, 3)
      Mocky.FakeModule.an_existing_function(1, 2, 3, 4)
    end
  end
end

# defmodule MyHTTP do
#   use Mock, module: RealHTTP
# end
#
# defmodule MockKafka do
#   use Mock, module: RealKafka
# end
#
#   setup do
#     MyHTTP.setup_mock
#     # MyHTTP.clean_mock
#   end
#
#   test "should do X when the scenario is Z" do
#     # given
#     given_param = 1
#     stub(MyHTTP, :get), do: %{status: 200, body: ""}
#
#     # when
#     result = MyModule.func(given_param)
#
#     # then
#     assert result == :success
#   end
#
#   test "should fail when the scenario is W" do
#     # given
#     given_param = 1
#
#     MyHTTP
#     |> stub(:get)
#     |> then_return(%{status: 500, body: ""})
#
#     MyHTTP
#     |> stub(:get)
#     |> then_do(fn -> %{status: 500, body: ""} end)
#
#     # when
#     result = MyModule.func(given_param)
#
#     # then
#     assert result == :fail
#   end
#
#   test "should produce message in Kafka when insert an user" do
#     # given
#     given_user = %{name: "Jeff"}
#
#     # when
#     MyModule.insert(given_user)
#
#     # then
#     assert called(MockKafka, :produce, ["created", given_user])
#     assert called(MockKafka, :produce, [any_arg(), given_user]) # or this
#     assert called(MockKafka, :produce, any_args(2)) # or this
#   end
