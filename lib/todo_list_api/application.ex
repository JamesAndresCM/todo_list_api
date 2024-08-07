defmodule TodoListApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: TodoListApi.Worker.start_link(arg)
      # {TodoListApi.Worker, arg}
      TodoListDB.Repo,
      #{Plug.Cowboy, scheme: :http, plug: Router, options: [port: Application.get_env(:todo_list_api, :port)]}
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: port()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoListApi.Supervisor]
    Logger.info "The server listening at port: #{port()}"
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:todo_list_api, :port)
end
