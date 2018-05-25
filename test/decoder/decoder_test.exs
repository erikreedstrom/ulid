defmodule Ulid.DecoderTest do
  use ExUnit.Case, async: true

  describe "decode/1" do
    test "decodes a text ulid" do
      ulid = "01C9S7RTEBG8NJTYT689ENQD2X"
      expected = <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>

      {:ok, result} = Ulid.Decoder.decode(ulid)

      assert byte_size(result) == 16
      assert result == expected
    end
  end

  describe "decode_uuid/1" do
    test "decodes a text uuid" do
      uuid = "0162727c-69cb-822b-2d7b-46425d5bb45d"
      expected = <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>

      {:ok, result} = Ulid.Decoder.decode_uuid(uuid)

      assert byte_size(result) == 16
      assert result == expected
    end
  end
end
