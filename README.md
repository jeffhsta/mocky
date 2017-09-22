# Mocky

It's a library to mock and stub your Elixir module.

It basically works using Agent and switch to real or fake module using the
configuration file.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mocky` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mocky, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mock](https://hexdocs.pm/mocky).
