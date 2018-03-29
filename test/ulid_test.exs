defmodule UlidTest do
  use ExUnit.Case, async: true

  describe "generate/0" do
    test "generates 26 characters" do
      result = Ulid.generate()
      assert String.length(result) == 26
    end

    test "is sortable" do
      ulid1 = Ulid.generate()
      Process.sleep(1)
      ulid2 = Ulid.generate()

      assert ulid2 > ulid1
    end
  end
end
