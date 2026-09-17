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
end
