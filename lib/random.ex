defmodule Ulid.Random do
  def encode(size) do
    1..size
      |> Enum.map(fn _index ->
          Enum.random(0..(String.length(Ulid.Utils.encoding) - 1))
        end)
      |> Ulid.Utils.concatenate_encodings
  end
end
