defmodule DockerDna do
  use HTTPoison.Base

  def reassemble(image) do
    image
      |> download_dockerfile 
      |> sanitize_contents 
      |> write_to_dockerfile
  end

  def find_ancestor(dockerfile) do
    %{"ancestor" => ancestor} = Regex.named_captures(~r/FROM (?<ancestor>.*\/.*):/, dockerfile)
    ancestor
  end

  def sanitize_contents(response) do
    json = response.body |> Poison.decode!
    json["contents"]
  end

  def write_to_dockerfile(contents) do
    {:ok, dockerfile} = File.open "Dockerfile.dna", [:write, :utf8]
    IO.write dockerfile, contents
  end

  def download_dockerfile(image) do
    image |> download_url |> get!
  end

  defp download_url(image) do
    "https://hub.docker.com/v2/repositories/#{image}/dockerfile/"
  end
end
