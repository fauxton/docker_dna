defmodule DockerDna.Exporter do
  alias DockerDna.Ancestry
  alias DockerDna.Formatter

  @moduledoc """
  Writes a formatted Dockerfile to disk.
  """

  def export!(options) do
    {:ok, dockerfile} =
      options
        |> dockerfile_src
        |> File.open([:write, :utf8])
    IO.write dockerfile, content()
  end

  defp dockerfile_src(options) do
    Enum.find_value(options, fn({"-o", val}) -> val end) || "Dockerfile.dna"
  end

  defp content do
    Ancestry.fetch |> Formatter.format!
  end
end
