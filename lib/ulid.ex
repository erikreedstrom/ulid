defmodule Ulid do
  @moduledoc """
  Universally Unique Lexicographically Sortable Identifier
  """

  @typedoc """
  An Crockford 32 encoded ULID string.
  """
  @type t :: <<_::208>>

  @typedoc """
  A raw binary representation of a ULID.
  """
  @type raw :: <<_::128>>

  @doc """
  Generates a Crockford 32 encoded ULID string.

  ## Examples

      iex> Ulid.generate()
      "01C9S8AD5XXR8QP6VBPN41R3TA"

      iex> Ulid.generate(1469918176385)
      "01ARYZ6S4124TJP2BQQZX06FKM"
  """
  @spec generate(none() | integer()) :: t | :error
  def generate(timestamp \\ System.system_time(:milliseconds)) do
    with {:ok, t} <- Ulid.Encoder.encode(generate_binary(timestamp)) do
      t
    end
  end

  @doc """
  Generates a binary ULID.

  ## Examples

      iex> Ulid.generate_binary()
      <<1, 98, 114, 124, 105, 203, 130, 43, 45, 123, 70, 66, 93, 91, 180, 93>>

      iex> Ulid.generate_binary(1469918176385)
      <<1, 86, 61, 243, 100, 129, 149, 125, 206, 44, 55, 150, 198, 186, 71, 79>>
  """
  @spec generate_binary(none() | integer()) :: raw
  def generate_binary(timestamp \\ System.system_time(:milliseconds)) do
    <<timestamp::unsigned-size(48), :crypto.strong_rand_bytes(10)::binary>>
  end
end
