import Config

config :todo_list_api, TodoList.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  # username: your_username,
  # password: your_password,
  database: "todo_list_test",
  hostname: "localhost"
