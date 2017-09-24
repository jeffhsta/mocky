defmodule Mocky.Mixfile do
  use Mix.Project

  def project do
    [app: :mocky,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger], mod: {Mocky.Application, []}]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp description, do: "Elixir mock library"

  defp package do
    [maintainers: ["Jefferson Stachelski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jeffhsta/mocky"}
    ]
  end
end
