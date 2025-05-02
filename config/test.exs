import Config
config :boogaloo, token_signing_secret: "lPll9t1B34pReNq9DOtSvJdd3nFXEQD9"
config :bcrypt_elixir, log_rounds: 1
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :boogaloo, Boogaloo.Repo,
  database: Path.expand("../boogaloo_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :boogaloo, BoogalooWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lyCzUuWKoGB0guvEPIv3wNr4Ebmn2gqQVaryCTz3+L7qN37S+b7iwmF5lXTQkGDq",
  server: false

# In test we don't send emails
config :boogaloo, Boogaloo.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
