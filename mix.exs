defmodule Ulid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ulid,
      version: "1.0.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # Benchmarking
      {:benchfella, "~> 0.3.5", only: [:dev, :test]},
      # Static checking
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Universally Unique Lexicographically Sortable Identifier
    """
  end

  defp package do
    [
      name: :ulid,
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Erik Reedstrom", "Johnny Feng"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Homepolish/ulid"}
    ]
  end
end
