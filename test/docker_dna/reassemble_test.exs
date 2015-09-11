defmodule DockerDnaReassemblerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @mock_dockerfile_response """
    {"contents": "FROM msaraiva/erlang:17.5\nMAINTAINER Marlus Saraiva <marlus.saraiva@gmail.com>\n\nRUN apk --update add wget git erlang17-crypto erlang17-syntax-tools erlang17-inets erlang17-ssl \\\n    erlang17-public-key erlang17-asn1 erlang17-sasl erlang17-erl-interface erlang17-dev && \\\n    rm -rf /var/cache/apk/*\n\nRUN wget https://github.com/elixir-lang/elixir/releases/download/v1.0.4/Precompiled.zip && \\\n    mkdir -p /opt/elixir-1.0.4/ && \\\n    unzip Precompiled.zip -d /opt/elixir-1.0.4/ && \\\n    rm Precompiled.zip\n\nENV PATH $PATH:/opt/elixir-1.0.4/bin\n\nRUN mix local.hex --force && \\\n    mix local.rebar --force\n\nCMD [\"/bin/sh\"]\n"}
    """

  test "requests Dockerfile from passed image" do
    use_cassette :stub, [
      url: "https://hub.docker.com/v2/repositories/msaraiva/elixir/dockerfile/", 
      body: @mock_dockerfile_response
    ] do
      response = DockerDna.download_dockerfile("msaraiva/elixir")
      assert response.body == @mock_dockerfile_response
    end
  end

  @dockerfile """
  FROM msaraiva/erlang:17.5
  
  MAINTAINER Marlus Saraiva <Marlus.saraiva@gmail.com>
  """
  test "finds ancestor within returned Dockerfile" do
    assert DockerDna.find_ancestor(@dockerfile) == "msaraiva/erlang"
  end
end
