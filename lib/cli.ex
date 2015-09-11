defmodule DockerDna.CLI do
  def main(args) do
    args |> parse_args |> process
  end

  def process(:help) do
    IO.puts Application.get_env(:text, :help)
  end

  def process({:reassemble, image}) when is_binary(image) do
    if Regex.match?(~r/.*\/.*/, image) do
      IO.puts "Reassembling Dockerfile!"
      DockerDna.reassemble(image)
    else
      IO.puts "Bad Dockerfile!"
    end
  end

  def parse_args(args) do
    options = OptionParser.parse(args)
    case options do
      {[help: true], _, _} -> :help
      {[], [image], _} -> {:reassemble, image}
      _ -> :help
    end
  end
end
