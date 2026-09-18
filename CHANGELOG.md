# Changelog

## v0.1.2

- `fetch_file!/3` added - the README of 0.1.1 documented it,
  but the function itself was missing from the release
- module docs updated accordingly

## v0.1.1

- `:token` is now optional: public datasets can be fetched
  without any token; gated datasets still require one (401
  otherwise)

## v0.1.0

- `fetch_file/3` - fetch any file from a gated dataset as `{:ok, binary}`
- `fetch!/3` - parquet -> `Explorer.DataFrame` (PAR1 magic check,
  readable exceptions on 401/404/non-parquet)
