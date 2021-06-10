defmodule App.Mixfile do
  use Mix.Project

  def project do
    [app: :app,
     version: "0.1.0",
     elixir: "~> 1.3",
     default_task: "server",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  def application do
    [applications: [:logger, :nadia, :jason, :cubdb, :memoize, :poison, :markovify],
     mod: {App, []}]
  end

  defp deps do
    [
      {:nadia, "~> 0.6.0"},
      {:poison, "~> 3.1"},
      {:jason, "~> 1.2"},
      {:cubdb, "~> 1.0.0-rc.10"},
      {:memoize, "~> 1.3"},
      {:markovify, "~> 0.3.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
