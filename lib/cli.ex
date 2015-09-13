defmodule DockerDna.CLI do
  alias DockerDna.Utils

  @moduledoc """
  CLI handles command line parsing and delegation
  of business logic to other application modules.
  """

  def main(args) do
    args |> parse_args |> process
  end

  def process(:help) do
    IO.puts Application.get_env(:text, :help)
  end

  def process({:reassemble, image}) when is_binary(image) do
    if Regex.match?(~r/.*\/.*/, image) do
      Utils.status "Reassembling Dockerfile!"
      DockerDna.Ancestry.start_link
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
