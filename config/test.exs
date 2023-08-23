import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :taco_hotdog, TacoHotdog.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "taco_hotdog_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :taco_hotdog, TacoHotdogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KrrIXr0QGGmgrJ4djtpKQrq4F2JtMx4laO1SWn/UywvL1QJz1jHMI2kDp6Ja2Em0",
  server: false

# In test we don't send emails.
config :taco_hotdog, TacoHotdog.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
