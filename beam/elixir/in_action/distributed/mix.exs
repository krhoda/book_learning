defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
        :observer,
        :runtime_tools,
        :wx
      ],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:plug_cowboy, "~> 2.6"}
      # {:distillery, "~> 2.0"}
    ]
  end

  def cli do
    [
      preferred_envs: [release: :prod]
    ]
  end
end
