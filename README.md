# ulid
Universally Unique Lexicographically Sortable Identifier implementation for Elixir

<h1 align="center">
	<br>
	<br>
	<img width="360" src="logo.png" alt="ulid">
	<br>
	<br>
	<br>
</h1>

[![GitHub License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/Homepolish/ulid)

# Universally Unique Lexicographically Sortable Identifier

UUID can be suboptimal for many uses-cases because:

- It isn't the most character efficient way of encoding 128 bits of randomness
- The string format itself is apparently based on the original MAC & time version (UUIDv1 from Wikipedia)
- It provides no other information than randomness

Instead, herein is proposed ULID:

- 128-bit compatibility with UUID
- 1.21e+24 unique ULIDs per millisecond
- Lexicographically sortable!
- Canonically encoded as a 26 character string, as opposed to the 36 character UUID
- Uses Crockford's base32 for better efficiency and readability (5 bits per character)
- Case insensitive
- No special characters (URL safe)

### Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ulid` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ulid, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ulid` is started before your application:

    ```elixir
    def application do
      [applications: [:ulid]]
    end
    ```

### Usage

Ulids can be generated with a simple call.

```elixir
iex> Ulid.generate()
"01ARZ3NDEKTSV4RRFFQ69G5FAV"
```

#### Seed Time

One can also input a seed time which will consistently give the same time component.
This is useful for migrating to ulid.

```elixir
iex> {:ok, dt} = DateTime.from_naive(~N[2018-01-01 00:00:00], "Etc/UTC")
iex> timestamp = DateTime.to_unix(dt, :millisecond)
iex> Ulid.generate(timestamp)
"01C2QG9400RY29DZPBYFNM93FJ"
```

#### Binary

Generating raw binary Ulids is also possible.

```elixir
iex> Ulid.generate_binary()
<<1, 98, 114, 66, 176, 35, 120, 165, 246, 238, 101, 132, 56, 100, 63, 177>>
```

```elixir
iex> {:ok, dt} = DateTime.from_naive(~N[2018-01-01 00:00:00], "Etc/UTC")
iex> timestamp = DateTime.to_unix(dt, :millisecond)
iex> Ulid.generate_binary(timestamp)
<<1, 96, 175, 4, 144, 0, 76, 227, 163, 150, 142, 231, 2, 152, 139, 26>>
```

### Extracting timestamp

It is possible to extract the timestamp from Ulids as well.

```elixir
iex> Ulid.extract_timestamp(<<1, 86, 61, 243, 100, 129, 149, 125, 206, 44, 55, 150, 198, 186, 71, 79>>)
1469918176385
```

```elixir
iex> Ulid.extract_timestamp("01ARYZ6S4124TJP2BQQZX06FKM")
1469918176385
```

## Specification

Below is the current specification of ULID as implemented in this repository.

```
 01AN4Z07BY      79KA1307SR9X4MV3

|----------|    |----------------|
 Timestamp          Randomness
  10 chars           16 chars
   48bits             80bits
   base32             base32
```

### Components

**Timestamp**
- 48 bit integer
- UNIX-time in milliseconds
- Won't run out of space till the year 10895 AD.

**Randomness**
- 80 bits
- Cryptographically secure source of randomness, if possible

### Sorting

The left-most character must be sorted first, and the right-most character sorted last. The default ASCII order is used for sorting.

### Binary Layout and Byte Order

The components are encoded as 16 octets. Each component is encoded with the Most Significant Byte first (network byte order).

```
0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      32_bit_uint_time_high                    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     16_bit_uint_time_low      |       16_bit_uint_random      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       32_bit_uint_random                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       32_bit_uint_random                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### String Representation

```
ttttttttttrrrrrrrrrrrrrrrr

where
t is Timestamp
r is Randomness
```

## Test Suite

```
mix test
```

### Performance

Encoding

```
## UlidBench
benchmark name   iterations   average time
generate            1000000   2.91 µs/op
generate_binary     1000000   1.04 µs/op
encode              1000000   1.72 µs/op
decode              1000000   1.76 µs/op
```

### Credits and references:

* https://github.com/alizain/ulid
* https://github.com/ulid-org/spec
* https://github.com/dcuddeback/ulid-elixir
