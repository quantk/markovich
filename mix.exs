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
    [applications: [:logger, :nadia, :jason, :faust, :cubdb, :memoize, :poison],
     mod: {App, []}]
  end

  defp deps do
    [
      {:nadia, "~> 0.6.0"},
      {:poison, "~> 3.1"},
      {:faust, "~> 0.1.0"},
      {:jason, "~> 1.2"},
      {:cubdb, "~> 1.0.0-rc.10"},
      {:memoize, "~> 1.3"},
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
