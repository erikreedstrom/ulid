defmodule Ulid.Time do
  @doc """
  Creates an identifier based on the time and the length provided

  ## Examples

  A ten length character encoded result:

      iex> Ulid.Time.encode 1469918176385, 10
      "01ARYZ6S41"

  A twelve length character encoded result:

      iex> Ulid.Time.encode 1470264322240, 12
      "0001AS99AA60"

  A truncated result

      iex> Ulid.Time.encode 1470118279201, 8
      "AS4Y1E11"
  """
  def encode(time, output_size) do
    {positions, _} = calculate_encodings(time, output_size)
    Ulid.Utils.concatenate_encodings(positions)
  end

  defp calculate_encodings(initial_time, size) do
    Enum.map_reduce(1..size, initial_time, fn _index, time ->
      accumulated_encode(round time)
    end)
  end

  defp accumulated_encode(time) do
    character_position = rem time, String.length(Ulid.Utils.encoding)
    acumulated_time = (time - character_position) / String.length(Ulid.Utils.encoding)
    {character_position, acumulated_time}
  end
end
