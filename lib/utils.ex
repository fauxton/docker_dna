defmodule DockerDna.Utils do
  @moduledoc """
  A junk drawer currenly containing a half-baked attempt 
  to limit application logging within tests.
  """

  def status(text) do
    if System.get_env("MIX_ENV") == :test, do: nil, else: IO.puts text
  end
end
