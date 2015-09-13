defmodule DockerDna.Downloader do
  use HTTPoison.Base

  @moduledoc """
  Downloads a Dockerfile given a Docker Hub image.
  Uses HTTPoison for its HTTP calls.
  """

  def download(image) do
    try do
      response = image |> download_url |> get!
      response.body |> Poison.decode!
    rescue
      exception ->
        DockerDna.Utils.status("Unable to download image (#{image}).")
    end
  end

  defp download_url(image) do
    "https://hub.docker.com/v2/repositories/#{image}/dockerfile/"
  end
end
