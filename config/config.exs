import Config

config :todo_list_api, :ecto_repos, [TodoListDB.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.env}.exs"
