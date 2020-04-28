defmodule ImageUploaderWeb.UploadController do
  use ImageUploaderWeb, :controller
  alias ImageUploader.Buffer

  def image_upload(conn, %{"device_id" => id, "image" => image}) do
    Buffer.push({id, image})
    conn
    |> send_resp(:created, "")
  end

end
