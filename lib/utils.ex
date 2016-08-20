defmodule Ulid.Utils do
  @encoding "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  def encoding, do: @encoding

  def concatenate_encodings(positions) do
    positions
      |> Enum.reduce("", fn(position, output) ->
          output <> String.at(@encoding, position)
        end)
      |> String.reverse
  end
end
