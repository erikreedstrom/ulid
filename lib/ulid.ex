defmodule Ulid do
  @moduledoc """
  Universally Unique Lexicographically Sortable Identifier
  """

  alias Ulid.{Decoder, Encoder}

  @typedoc """
  An Crockford 32 encoded ULID string.
  """
  @type t :: <<_::208>>

  @typedoc """
  A raw binary representation of a ULID.
  """
  @type raw :: <<_::128>>

  @typedoc """
  A uuid representation of a ULID.
  """
  @type uuid :: <<_::288>>

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

  @doc """
  Generates a binary ULID.

  ## Examples

      iex> Ulid.generate_uuid()
      "016396c5-b711-31a2-a739-1dcf09541b93"

      iex> Ulid.generate_uuid(1469918176385)
      "01563df3-6481-961f-7ae6-f445f82a2b8b"
  """
  @spec generate_uuid(none() | integer()) :: uuid
  def generate_uuid(timestamp \\ System.system_time(:milliseconds)) do
    with {:ok, t} <- Ulid.Encoder.encode_uuid(generate_binary(timestamp)) do
      t
    end
  end

  @doc """
  Extracts a timestamp from a ulid.

  ## Examples

      iex> Ulid.extract_timestamp(<<1, 86, 61, 243, 100, 129, 149, 125, 206, 44, 55, 150, 198, 186, 71, 79>>)
      1469918176385

      iex> Ulid.extract_timestamp("01ARYZ6S4124TJP2BQQZX06FKM")
      1469918176385

      iex> Ulid.extract_timestamp("01563df3-6481-1135-2b09-77bffa033e74")
      1469918176385
  """
  @spec extract_timestamp(t | raw | uuid) :: integer | :error
  def extract_timestamp(<<_::unsigned-size(288)>> = text) do
    with {:ok, bytes} <- Decoder.decode_uuid(text), do: extract_timestamp(bytes)
  end

  def extract_timestamp(<<_::unsigned-size(208)>> = text) do
    with {:ok, bytes} <- Decoder.decode(text), do: extract_timestamp(bytes)
  end

  def extract_timestamp(<<timestamp::unsigned-size(48), _::unsigned-size(80)>>), do: timestamp

  @doc """
  Converts a ulid to its uuid form.

  ## Examples

      iex> Ulid.to_uuid(<<1, 99, 150, 178, 200, 245, 145, 16, 174, 235, 231, 88, 83, 10, 188, 83>>)
      "016396b2-c8f5-9110-aeeb-e758530abc53"

      iex> Ulid.to_uuid("01CEBB5J7NJ48AXTZ7B19GNF2K")
      "016396b2-c8f5-9110-aeeb-e758530abc53"
  """
  @spec to_uuid(t | raw) :: uuid | :error
  def to_uuid(<<_::unsigned-size(208)>> = text) do
    with {:ok, bytes} <- Decoder.decode(text), do: to_uuid(bytes)
  end

  def to_uuid(<<_::unsigned-size(128)>> = binary) do
    with {:ok, uuid} <- Encoder.encode_uuid(binary), do: uuid
  end

  @doc """
  Converts a ulid to its uuid form.

  ## Examples

      iex> Ulid.from_uuid("016396b2-c8f5-9110-aeeb-e758530abc53")
      "01CEBB5J7NJ48AXTZ7B19GNF2K"

  """
  @spec from_uuid(uuid) :: t | :error
  def from_uuid(<<_::unsigned-size(288)>> = text) do
    with {:ok, bytes} <- Decoder.decode_uuid(text),
         {:ok, t} <- Ulid.Encoder.encode(bytes) do
      t
    end
  end
end
