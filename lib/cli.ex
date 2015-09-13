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

  def process({:reassemble, image, options}) when is_binary(image) do
    if Regex.match?(~r/.*\/.*/, image) do
      Utils.status "Reassembling Dockerfile!"
      DockerDna.Ancestry.start_link
      DockerDna.reassemble(image, options)
    else
      IO.puts "Bad Dockerfile!"
    end
  end

  def parse_args(args) do
    options = OptionParser.parse(args)
    case options do
      {[help: true], _, _} -> :help
      {[], [image], options} -> {:reassemble, image, options}
      _ -> :help
    end
  end
end
