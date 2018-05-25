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

  @doc """
  Decodes a uuid binary to its ulid binary form.

  ## Examples

      iex> Ulid.Decoder.decode_uuid("016396b2-c8f5-9110-aeeb-e758530abc53")
      <<1, 99, 150, 178, 200, 245, 145, 16, 174, 235, 231, 88, 83, 10, 188, 83>>
  """
  @spec decode_uuid(Ulid.uuid()) :: {:ok, Ulid.raw()} | :error
  def decode_uuid(
        <<a1, a2, a3, a4, a5, a6, a7, a8, ?-, b1, b2, b3, b4, ?-, c1, c2, c3, c4, ?-, d1, d2, d3, d4, ?-, e1, e2, e3,
          e4, e5, e6, e7, e8, e9, e10, e11, e12>>
      ) do
    try do
      <<d(a1)::4, d(a2)::4, d(a3)::4, d(a4)::4, d(a5)::4, d(a6)::4, d(a7)::4, d(a8)::4, d(b1)::4, d(b2)::4, d(b3)::4,
        d(b4)::4, d(c1)::4, d(c2)::4, d(c3)::4, d(c4)::4, d(d1)::4, d(d2)::4, d(d3)::4, d(d4)::4, d(e1)::4, d(e2)::4,
        d(e3)::4, d(e4)::4, d(e5)::4, d(e6)::4, d(e7)::4, d(e8)::4, d(e9)::4, d(e10)::4, d(e11)::4, d(e12)::4>>
    catch
      :error -> :error
    else
      binary ->
        {:ok, binary}
    end
  end

  def decode_uuid(_), do: :error

  ## PRIVATE FUNCTIONS

  defp decode_bytes(<<>>, <<_::2, shifted::bitstring>>), do: shifted

  defp decode_bytes(<<codepoint::unsigned, rest::bitstring>>, acc) do
    decode_bytes(rest, <<acc::bitstring, i(codepoint)::unsigned-size(5)>>)
  end

  @compile {:inline, i: 1}

  for n <- 0..31 do
    defp i(unquote(:binary.at(@crockford_alphabet, n))), do: unquote(n)
  end

  @compile {:inline, d: 1}

  defp d(?0), do: 0
  defp d(?1), do: 1
  defp d(?2), do: 2
  defp d(?3), do: 3
  defp d(?4), do: 4
  defp d(?5), do: 5
  defp d(?6), do: 6
  defp d(?7), do: 7
  defp d(?8), do: 8
  defp d(?9), do: 9
  defp d(?A), do: 10
  defp d(?B), do: 11
  defp d(?C), do: 12
  defp d(?D), do: 13
  defp d(?E), do: 14
  defp d(?F), do: 15
  defp d(?a), do: 10
  defp d(?b), do: 11
  defp d(?c), do: 12
  defp d(?d), do: 13
  defp d(?e), do: 14
  defp d(?f), do: 15
  defp d(_), do: throw(:error)
end
