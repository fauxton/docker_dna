defmodule DockerDna.Ancestry do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_ancestor(dockerfile) do
    Agent.update(__MODULE__, fn(ancestors) ->
      [dockerfile | ancestors]
    end)
  end

  def fetch do
    Agent.get __MODULE__, fn(ancestors) ->
      ancestors
    end
  end
end
