# HfGated

Read files from gated/private Hugging Face datasets with a token.
Parquet goes straight into `Explorer.DataFrame`.

```elixir
Mix.install([{:hf_gated, "~> 0.1"}])

df = HfGated.fetch!("user/dataset", "latest.parquet", token: token)
```

## Functions

- `fetch_file/3` - any file as `{:ok, binary}`
- `fetch!/3` - parquet -> `Explorer.DataFrame` with readable
  errors (401 - bad token or no access, 404 - file not found,
  non-parquet - with a payload preview)

The token is passed only through arguments; the library never
stores it.

## Installation

Add to your dependencies:

```elixir
{:hf_gated, "~> 0.1"}
```

or in Livebook:

```elixir
Mix.install([{:hf_gated, "~> 0.1"}])
```

## License

MIT - see [LICENSE](LICENSE).
