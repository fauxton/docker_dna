defmodule DockerDnaCLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import DockerDna.CLI
  import Mock
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "knows how to help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
    assert parse_args([]) == :help
  end

  test "shows help message" do
    assert capture_io(fn ->
      DockerDna.CLI.process(:help)
    end) == Application.get_env(:text, :help)<>"\n"
  end

  test "extracts passed image as arg" do
    assert parse_args(["msaraiva/elixir"]) == {:reassemble, "msaraiva/elixir", []}
    assert parse_args(["foobar"]) == {:reassemble, "foobar", []}
  end

  test "shows error message when image format invalid" do
    assert capture_io(fn ->
      DockerDna.CLI.process({:reassemble, "foobar", []})
    end) == "Bad Dockerfile!"<>"\n"
  end

  test "reassembles image when image format valid" do
    with_mock DockerDna, [reassemble: fn(_image, _options) -> true end] do
      DockerDna.CLI.process({:reassemble, "foo/bar", []})
      assert called DockerDna.reassemble("foo/bar", [])
    end
  end
end
