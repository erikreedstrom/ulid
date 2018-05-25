defmodule Ulid.EncoderTest do
  use ExUnit.Case, async: true

  describe "encode/1" do
    test "encodes a binary ulid" do
      ulid = <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>

      {:ok, result} = Ulid.Encoder.encode(ulid)

      assert String.length(result) == 26
      assert String.starts_with?(result, "01C9S7RTEB")
    end
  end

  describe "encode_uuid/1" do
    test "encodes a binary ulid to uuid" do
      ulid = <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>

      {:ok, result} = Ulid.Encoder.encode_uuid(ulid)

      assert String.length(result) == 36
      assert result == "0162727c-69cb-822b-2d7b-46425d5bb45d"
    end
  end
end
