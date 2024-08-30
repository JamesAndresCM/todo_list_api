import Config

config :todo_list_api, :ecto_repos, [TodoListDB.Repo]

import_config "#{Mix.env}.exs"
