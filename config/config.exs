# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bloggex,
  ecto_repos: [Bloggex.Repo]

# Configures the endpoint
config :bloggex, BloggexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "TggigzA5Kbhjg3SJ7CQksdsV6vUCLmTBBDNUwfay95sstTZymy3mpoD5KmqVabg6",
  render_errors: [view: BloggexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bloggex.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Guardian configuration
config :bloggex, Bloggex.Guardian,
  issuer: "bloggex",
  secret_key: "tbTHTcQjGnWIWr9sUNBqWSpHuhKwTkcUk7gbn9vM4exnaajtCvYjL240Y1rW+XT8"

config :bloggex, BloggexWeb.AuthPipeline,
  module: BloggexWeb.Guardian,
  error_handler: BloggexWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
