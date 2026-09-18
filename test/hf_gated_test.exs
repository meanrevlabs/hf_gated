defmodule HfGatedTest do
  use ExUnit.Case, async: true

  # Offline contract test: no network, no tokens required.
  # HTTP branches (401/404/parquet magic) are exercised manually
  # against a live gated dataset before each release.

  setup do
    Code.ensure_loaded!(HfGated)
    :ok
  end

  test "public API: two functions with correct arities" do
    assert function_exported?(HfGated, :fetch_file, 3)
    assert function_exported?(HfGated, :fetch!, 3)
  end

  test "fetch_file without token: no option error (public datasets supported)" do
    # v0.1.0 raised KeyError (fetch!) when :token was missing.
    # v0.1.1 proceeds without the auth header; against an
    # unreachable host we expect a network error - NOT an
    # argument error. Network access itself is not required:
    # DNS failure counts.
    assert {:error, {:network, _}} =
             HfGated.fetch_file("any/dataset", "file.parquet",
               token: nil,
               base_url: "https://invalid.hf-gated-nonexistent-host.example"
             )
  end

end
