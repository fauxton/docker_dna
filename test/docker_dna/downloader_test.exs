defmodule DockerDnaDownloaderTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @contents """
  FROM msaraiva/erlang:17.5
  MAINTAINER Marlus Saraiva <marlus.saraiva@gmail.com>
  """

  @mock_dockerfile_response """
    {"contents": #{@contents}}
  """

  test "requests Dockerfile from passed image" do
    use_cassette :stub, [
      url: "https://hub.docker.com/v2/repositories/foo/bar/dockerfile/",
      body: @mock_dockerfile_response
    ] do
      assert DockerDna.Downloader.download("foo/bar") == :ok
    end
  end
end
