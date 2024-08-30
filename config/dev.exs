import Config

database_url = System.get_env("DATABASE_URL")

config :todo_list_api, port: 4000
if String.valid?(database_url) do
  config :todo_list_api,
         TodoListDB.Repo,
         url: database_url
else
  config :todo_list_api,
         TodoListDB.Repo,
         database: "todo_list_dev",
         hostname: "localhost"
end
