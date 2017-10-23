# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :learning_redirecting, LearningRedirectingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Sz6E4RQ2HjAG8IWKzui8EzCW9HmlYh3VCLNkgs0T6k1Glop3TuUHg7R+CBogt9eJ",
  render_errors: [view: LearningRedirectingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: LearningRedirecting.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
