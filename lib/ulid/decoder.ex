defmodule Ulid.Decoder do
  @moduledoc """
  Handles the decoding of text Ulids.
  """

  @crockford_alphabet "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  @doc """
  Encodes a Ulid binary to its textual form.

  ## Examples

      iex> ulid = "01C9S7RTEBG8NJTYT689ENQD2X"
      iex> Ulid.Decoder.decode(ulid)
      {:ok, <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>}
  """
  @spec decode(Ulid.t()) :: {:ok, Ulid.raw()} | :error
  def decode(<<_::unsigned-size(208)>> = text) do
    decode_bytes(text, <<>>)
  catch
    :error -> :error
  else
    binary -> {:ok, binary}
  end

  ## PRIVATE FUNCTIONS

  defp decode_bytes(<<>>, <<_::2, shifted::bitstring>>), do: shifted

  defp decode_bytes(<<codepoint::unsigned, rest::bitstring>>, acc) do
    decode_bytes(rest, <<acc::bitstring, i(codepoint)::unsigned-size(5)>>)
  end

  @compile {:inline, i: 1}

  for n <- 0..31 do
    defp i(unquote(:binary.at(@crockford_alphabet, n))), do: unquote(n)
  end
end
