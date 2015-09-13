defmodule DockerDna.Exporter do
  alias DockerDna.Ancestry
  alias DockerDna.Formatter

  def export! do
    {:ok, dockerfile} = File.open "Dockerfile.dna", [:write, :utf8]
    IO.write dockerfile, content
  end

  defp content do
    Ancestry.fetch |> Formatter.format!
  end
end
