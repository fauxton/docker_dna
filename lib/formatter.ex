defmodule DockerDna.Formatter do
  @moduledoc """
  Formats the contents of a collection of Dockerfiles
  in preparation for export. Strips lines that should
  be unique within a single Dockerfile, such as
  FROM, as well as removes some noise for added
  readability
  """

  def format!(dockerfiles) when is_list(dockerfiles) do
    last = Enum.count(dockerfiles) - 1
    dockerfiles |> Enum.with_index |> Enum.map(fn(f) ->
      case f do
        {dockerfile, 0} -> sanitize_contents(dockerfile, :first)
        {dockerfile, ^last} -> sanitize_contents(dockerfile, :last)
        {dockerfile, _} -> sanitize_contents(dockerfile, :middle)
      end
    end) |> Enum.join("\n")
  end

  defp sanitize_contents(dockerfile, :first) do
    dockerfile
      |> strip_maintainer
      |> strip_cmd
      |> String.strip
  end

  defp sanitize_contents(dockerfile, :middle) do
    dockerfile
      |> strip_maintainer
      |> strip_cmd
      |> strip_from
      |> String.strip
  end

  defp sanitize_contents(dockerfile, :last) do
    dockerfile
      |> strip_maintainer
      |> strip_from
      |> String.strip
  end

  defp strip_from(dockerfile) do
    dockerfile |> String.replace(~r/FROM .*\n/, "")
  end

  defp strip_cmd(dockerfile) do
    dockerfile |> String.replace(~r/CMD .*\n/, "")
  end

  defp strip_maintainer(dockerfile) do
    dockerfile |> String.replace(~r/MAINTAINER .*\n/, "")
  end
end
