defmodule UlidBench do
  use Benchfella

  @ulid_raw Ulid.generate_binary()
  @ulid_text Ulid.generate()

  bench "generate" do
    Ulid.generate()
    nil
  end

  bench "generate_binary" do
    Ulid.generate_binary()
    nil
  end

  bench "encode" do
    Ulid.Encoder.encode(@ulid_raw)
    nil
  end

  bench "decode" do
    Ulid.Decoder.decode(@ulid_text)
    nil
  end
end
