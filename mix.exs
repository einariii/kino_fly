defmodule KinoFly.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_fly,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.9.4"},
      {:req, "~> 0.3.9"},
      {:jason, "~> 1.4"}
    ]
  end
end
