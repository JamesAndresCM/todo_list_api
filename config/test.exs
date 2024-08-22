import Config

config :todo_list_api, TodoListDB.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "pass",
  database: "todo_list_test",
  hostname: "localhost"

config :todo_list_api, :port, 9090

config :todo_list_api, :server, false
