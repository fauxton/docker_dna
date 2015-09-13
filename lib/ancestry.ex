defmodule DockerDna.Ancestry do
  @moduledoc """
  Ancestry holds the current state of an image's ancestry.
  Each ancestor that is successfully downloaded is prepended.
  In order to process the list before we
  export the custom Dockerfile, you can fetch the current list.
  You can also find your next ancestor.
  """

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_ancestor(dockerfile) do
    Agent.update(__MODULE__, fn(ancestors) ->
      [dockerfile | ancestors]
    end)
    dockerfile
  end

  def fetch do
    Agent.get __MODULE__, fn(ancestors) ->
      ancestors
    end
  end

  def find_next_ancestor(dockerfile) do
    # This currently ignores tags, i.e. author/image:tag
    case Regex.named_captures(~r/FROM (?<ancestor>.*\/.*):/, dockerfile) do
      %{"ancestor" => ancestor} -> ancestor
      nil -> nil
    end
  end
end
