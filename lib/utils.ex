defmodule DockerDna.Utils do
  def status(text) do
    if System.get_env("MIX_ENV") == :test, do: nil, else: IO.puts text
  end
end
