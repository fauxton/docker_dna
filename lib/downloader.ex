defmodule DockerDna.Downloader do
  use HTTPoison.Base
  def download(image) do
    try do
      response = image |> download_url |> get!
      response.body |> Poison.decode!
    rescue
      exception -> DockerDna.Utils.status("Unable to download image (#{image}).")
    end
  end

  defp download_url(image) do
    "https://hub.docker.com/v2/repositories/#{image}/dockerfile/"
  end
end
