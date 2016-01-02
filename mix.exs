defmodule DockerDna.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_dna,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: [main_module: DockerDna.CLI],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:mock, "~> 0.1", only: :test},
      {:exvcr, "~> 0.5", only: :test},
      {:httpoison, "~> 0.7.2"},
      {:poison, "~> 1.5"},
      {:dogma, "~> 0.0", only: :dev}
    ]
  end
end
