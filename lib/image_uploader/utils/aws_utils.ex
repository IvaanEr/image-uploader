defmodule ImageUploader.AwsUtils do
  @moduledoc """
  This module provides some functionalities to upload files to S3
  """

  @s3_bucket "test"

  @doc """
    Upload a file to S3 on bucket @s3_bucket.
  """
  @spec upload_file(String.t()) :: :error | :ok
  def upload_file(file_path) do
    case get_file(file_path) do
      {:ok, binary} ->
        upload_binary(binary, file_path)

      {:error, err} ->
        IO.puts(err)
        :error
    end
  end

  @doc """
    Get a file from S3 from bucket @s3_bucket
  """
  @spec get(binary()) :: any() | :error
  def get(object) do
    %{status_code: status, body: body} =
      ExAws.S3.get_object(@s3_bucket, object)
      |> ExAws.request!()

    case status do
      200 -> body
      _ -> :error
    end
  end

  @doc """
  Upload a binary to S3
  """
  def upload_binary(binary, path) do
    %{status_code: status} =
      ExAws.S3.put_object(@s3_bucket, path, binary)
      |> ExAws.request!()

    case status do
      200 -> :ok
      _ -> :error
    end
  end

  @spec get_file(String.t()) :: {:ok, binary()} | {:error, String.t()}
  defp get_file(file_path) do
    case File.read(file_path) do
      {:ok, binary} -> {:ok, binary}
      {:error, _error} -> {:error, "Error fetching file from #{file_path}"}
    end
  end

end
