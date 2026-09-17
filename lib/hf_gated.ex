defmodule HfGated do
  @moduledoc """
  Read files from gated/private Hugging Face datasets.

  Hides the plumbing: token authorization, CDN redirects,
  tmp-file handling, parquet format validation. Parquet files
  are returned directly as `Explorer.DataFrame`.

  ## Quick start

      Mix.install([{:hf_gated, "~> 0.1"}])

      df = HfGated.fetch!("user/dataset", "latest.parquet", token: token)

  ## Functions

    - `fetch_file/3` - any file as `{:ok, binary}`
    - `fetch!/3` - parquet -> `Explorer.DataFrame` (raises on
      error: a client notebook should fail with a clear
      message instead of silently working with nil)

  ## Errors

  401 (bad token / no access), 404 (file not found), network
  failures, and non-parquet payloads are all reported with
  readable messages.
  """

  @default_base "https://huggingface.co/datasets"

  @doc """
  Fetches a file from a gated dataset.

  Returns `{:ok, binary}` or `{:error, reason}`. The binary can
  be saved or processed further on your own.

  ## Options

    - `:token` - HF read token (required)
    - `:revision` - branch or tag (default `"main"`)
    - `:base_url` - host override (useful in tests)
  """
  @spec fetch_file(String.t(), String.t(), keyword()) ::
          {:ok, binary()} | {:error, term()}
  def fetch_file(dataset_id, path_in_repo, opts) do
    token = Keyword.fetch!(opts, :token)
    revision = Keyword.get(opts, :revision, "main")
    base = Keyword.get(opts, :base_url, @default_base)

    url = "#{base}/#{dataset_id}/resolve/#{revision}/#{path_in_repo}"

    case Req.get(url,
           headers: [{"authorization", "Bearer #{token}"}],
           redirect: true,
           decode_body: false,
           retry: :transient
         ) do
      {:ok, %{status: 200, body: body}} when is_binary(body) ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :unauthorized}

      {:ok, %{status: 404}} ->
        {:error, :not_found}

      {:ok, %{status: status}} ->
        {:error, {:http, status}}

      {:error, reason} ->
        {:error, {:network, reason}}
    end
  end

  @doc """
  Fetches a parquet file and reads it into `Explorer.DataFrame`.

  Validates the parquet magic bytes (fast failure instead of a
  cryptic Polars error - e.g. when the payload is an LFS
  pointer). Raises with a readable message on any error.
  """
  @spec fetch!(String.t(), String.t(), keyword()) ::
          Explorer.DataFrame.t() | no_return()
  def fetch!(dataset_id, path_in_repo, opts) do
    case fetch_file(dataset_id, path_in_repo, opts) do
      {:ok, body} ->
        case binary_part(body, 0, 4) do
          "PAR1" ->
            tmp_path =
              Path.join(System.tmp_dir!(), "hf_gated_#{System.unique_integer([:positive])}.parquet")

            File.write!(tmp_path, body)
            df = Explorer.DataFrame.from_parquet!(tmp_path)
            File.rm(tmp_path)
            df

          other ->
            preview = binary_part(body, 0, min(byte_size(body), 64))

            raise """
            Not a parquet file (leading bytes: #{inspect(other)}).
            The file may be corrupted, or this is an LFS pointer.
            Payload preview: #{preview}
            """
        end

      {:error, :unauthorized} ->
        raise "401: invalid token or no access to #{dataset_id}"

      {:error, :not_found} ->
        raise "404: file #{path_in_repo} not found in #{dataset_id}"

      {:error, reason} ->
        raise "Fetch failed: #{inspect(reason)}"
    end
  end
end
