# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :image_uploader,
  ecto_repos: [ImageUploader.Repo]

# Configures the endpoint
config :image_uploader, ImageUploaderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PRib6l0FvhCcvyjjVe3IRPoAjMW4fKorM2y1idyEuy7lfoSx87sdXb9p4uezXxiw",
  render_errors: [view: ImageUploaderWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ImageUploader.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "hy6nQVgy"]

config :ex_aws,
  access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
  secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
