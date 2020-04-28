defmodule ImageUploaderWeb.Router do
  use ImageUploaderWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ImageUploaderWeb do
    pipe_through :api
  end
end
