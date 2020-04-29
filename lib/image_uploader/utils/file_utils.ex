defmodule ImageUploader.FileUtils do
  @moduledoc """
  Provide functionalities to save data to files
  """
  require Logger

  @temp "/tmp/"

  def upload_binary(binary, path) do
    case File.write("#{@temp}/#{path}", binary) do
      :ok -> :ok
      {:error, res} -> Logger.debug(res)
                      :error
    end
  end
end
