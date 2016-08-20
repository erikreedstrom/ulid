defmodule Ulid do
  @time_length 10
  @random_length 16

  def generate do
    milliseconds_timestamp = :os.timestamp
      |> Tuple.to_list
      |> Enum.join
      |> String.to_integer
      |> (&(&1 / 1000)).()
      |> round

    Ulid.Time.encode(milliseconds_timestamp, @time_length)
      <> Ulid.Random.encode(@random_length)
  end
end
