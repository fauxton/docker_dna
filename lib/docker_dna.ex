defmodule DockerDna do
  alias DockerDna.Ancestry
  alias DockerDna.Downloader
  alias DockerDna.Exporter

  def reassemble(nil), do: Exporter.export!

  def reassemble(image) when is_binary(image) do
    case image |> Downloader.download do
      %{"contents" => dockerfile } ->
        dockerfile
          |> add_to_family_tree
          |> find_ancestor
          |> reassemble
      _ -> false
    end
  end

  def add_to_family_tree(dockerfile) do
    Ancestry.add_ancestor(dockerfile)
    dockerfile
  end

  def find_ancestor(dockerfile) do
    # This currently ignores tags, i.e. author/image:tag
    case Regex.named_captures(~r/FROM (?<ancestor>.*\/.*):/, dockerfile) do
      %{"ancestor" => ancestor} -> ancestor
      nil -> nil
    end
  end
end
