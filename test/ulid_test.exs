defmodule UlidTest do
  use ExUnit.Case, async: true
  doctest Ulid.Time

  test "generates 26 characters" do
    assert String.length(Ulid.generate) == 26
  end

  test "is sortable" do
    ulid1 = Ulid.generate
    ulid2 = Ulid.generate

    assert ulid2 > ulid1
  end
end
