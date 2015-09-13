defmodule DockerDna do
  alias DockerDna.Ancestry
  alias DockerDna.Downloader
  alias DockerDna.Exporter

  @moduledoc """
  DockerDna is the entry point for the application logic.
  It delegates to more specialized modules for specific behavior,
  exposing only a single public API.
  """

  def reassemble(nil, options), do: Exporter.export!(options)

  def reassemble(image, options \\ []) when is_binary(image) do
    case image |> Downloader.download do
      %{"contents" => dockerfile } ->
        dockerfile
          |> Ancestry.add_ancestor
          |> Ancestry.find_next_ancestor
          |> reassemble(options)
      _ -> false
    end
  end
end
