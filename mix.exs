defmodule HfGated.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :hf_gated,
      version: @version,
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [main: "HfGated", source_ref: "v#{@version}"]
    ]
  end

  def application, do: []

  defp deps do
    [
      {:req, "~> 0.7.4"},
      {:explorer, "~> 0.12.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "Read files from gated/private Hugging Face datasets " <>
        "with a token; parquet straight into Explorer.DataFrame.",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/meanrevlabs/hf_gated",
        "Changelog" => "https://github.com/meanrevlabs/hf_gated/blob/main/CHANGELOG.md"
      },
      files: ["lib", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"]
    ]
  end

end
