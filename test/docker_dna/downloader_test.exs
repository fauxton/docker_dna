defmodule DockerDnaDownloaderTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import ExUnit.CaptureIO

  @contents """
  FROM msaraiva/erlang:17.5
  MAINTAINER Marlus Saraiva <marlus.saraiva@gmail.com>
  """

  @mock_dockerfile_response """
    {"contents": #{@contents}}
  """

  test "requests Dockerfile from passed image" do
    assert capture_io(fn ->
      use_cassette :stub, [
        url: "https://hub.docker.com/v2/repositories/foo/bar/dockerfile/",
        body: @mock_dockerfile_response
      ] do
        assert DockerDna.Downloader.download("foo/bar") == :ok
      end
    end) == "Unable to download image (foo/bar).\n"
  end
end
