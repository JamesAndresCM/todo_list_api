import Config

config :todo_list_api, port: 80

database_url = System.get_env("DATABASE_URL")

if String.valid?(database_url) do
  config :todo_list_api, TodoListDB.Repo,
         url: database_url
else
  config :todo_list_api, TodoListDB.Repo,
         database: "todo_list_prod",
         username: "postgres",
         password: "postgres",
         hostname: "localhost"
end
