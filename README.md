# HfGated

Read files from Hugging Face datasets: gated/private with a
token, public without one. Parquet goes straight into
`Explorer.DataFrame`.

## Quick start

Gated dataset (a read token is required):

```elixir
Mix.install([{:hf_gated, "~> 0.1"}])

df = HfGated.fetch!("user/dataset", "latest.parquet", token: token)
```

Public dataset (no token needed):

```elixir
docs = HfGated.fetch_file!("user/public-dataset", "docs.md")
```

## Functions

- `fetch_file/3` - any file as `{:ok, binary}`; omit `token:`
  for public datasets, pass it for gated ones
- `fetch_file!/3` - same, but returns the binary directly and
  raises on error
- `fetch!/3` - parquet -> `Explorer.DataFrame` with readable
  errors (401 - bad token or no access, 404 - file not found,
  non-parquet - with a payload preview)

The token is passed only through arguments; the library never
stores it. Gated datasets without a token return
`:unauthorized`.

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
