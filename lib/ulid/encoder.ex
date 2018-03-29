defmodule Ulid.Encoder do
  @moduledoc """
  Handles the encoding of raw Ulids.
  """

  @crockford_alphabet "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  @doc """
  Encodes a Ulid binary to its textual form.

  ## Examples

      iex> ulid = Ulid.generate_binary()
      <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>
      iex> Ulid.Encoder.encode(ulid)
      "01C9S7RTEBG8NJTYT689ENQD2X"
  """
  @spec encode(Ulid.raw()) :: {:ok, Ulid.t()} | :error
  def encode(<<_::unsigned-size(128)>> = bytes) do
    encode_bytes(<<0::2, bytes::binary>>, <<>>)
  catch
    _ -> :error
  else
    encoded -> {:ok, encoded}
  end

  ## PRIVATE FUNCTIONS

  for n <- 0..31 do
    defp encode_bytes(<<unquote(n)::unsigned-size(5), rest::bitstring>>, acc) do
      encode_bytes(rest, acc <> unquote(String.at(@crockford_alphabet, n)))
    end
  end

  defp encode_bytes(<<>>, acc), do: acc
end
