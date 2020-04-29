defmodule ImageUploader.FileUtils do
  @moduledoc """
  Provide functionalities to save data to files
  """
  require Logger

  @temp "/tmp/"

  def upload_binary(binary, path) do
    case File.write("#{@temp}/#{path}", binary) do
      :ok -> Logger.debug("File #{path} saved")
            :ok
      {:error, res} -> Logger.error(res)
                      :error
    end
  end
end
