defmodule DockerDnaAncestryTest do
  use ExUnit.Case
  alias DockerDna.Ancestry

  @unofficial """
  FROM msaraiva/erlang:17.5
  MAINTAINER Marlus Saraiva <Marlus.saraiva@gmail.com>
  """
  @official """
  FROM alpine:3.2
  MAINTAINER Marlus Saraiva <marlus.saraiva@gmail.com>
  """
  test "finds ancestor within returned Dockerfile" do
    assert Ancestry.find_next_ancestor(@unofficial) == "msaraiva/erlang"
    assert Ancestry.find_next_ancestor(@official) == nil
  end
end
