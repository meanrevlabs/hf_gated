# Changelog

## v0.1.0

- `fetch_file/3` - fetch any file from a gated dataset as `{:ok, binary}`
- `fetch!/3` - parquet -> `Explorer.DataFrame` (PAR1 magic check,
  readable exceptions on 401/404/non-parquet)
