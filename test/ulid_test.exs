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

  describe "extract_timestamp/1" do
    test "extracts a timestamp from a text ulid" do
      ulid = "01ARYZ6S4124TJP2BQQZX06FKM"
      assert Ulid.extract_timestamp(ulid) == 1_469_918_176_385
    end

    test "extracts a timestamp from a raw ulid" do
      ulid = <<1, 86, 61, 243, 100, 129, 149, 125, 206, 44, 55, 150, 198, 186, 71, 79>>
      assert Ulid.extract_timestamp(ulid) == 1_469_918_176_385
    end

    test "extracts a timestamp from a uuid ulid" do
      uuid = "01563df3-6481-957d-ce2c-3796c6ba474f"
      assert Ulid.extract_timestamp(uuid) == 1_469_918_176_385
    end
  end

  describe "from_uuid/1" do
    test "converts ulid to uuid" do
      result = Ulid.from_uuid(Ulid.generate_uuid(1_469_918_176_385))
      assert String.length(result) == 26
      assert binary_part(result, 0, 10) == "01ARYZ6S41"
    end
  end

  describe "to_uuid/1" do
    test "converts ulid to uuid" do
      result = Ulid.to_uuid(Ulid.generate(1_469_918_176_385))
      assert String.length(result) == 36
      assert binary_part(result, 0, 8) == "01563df3"
    end

    test "converts raw ulid to uuid" do
      result = Ulid.to_uuid(Ulid.generate_binary(1_469_918_176_385))
      assert String.length(result) == 36
      assert binary_part(result, 0, 8) == "01563df3"
    end
  end
end
