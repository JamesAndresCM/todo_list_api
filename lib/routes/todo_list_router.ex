defmodule Routes.TodoListRouter do
  use Plug.Router
  alias Repositories.TodoListRepository
  plug :match

  # We want the response to be sent in json format.
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :dispatch

  @users [%{id: 1, name: "jaime"},  %{id: 2, name: "andres"}]

  get "/todo_lists" do
    send_resp(conn, 200, Jason.encode!(%{data: render_all()}))
  end


  defp render_all do
    for n <- TodoListRepository.all(), do: %{id: n.id, name: n.name, description: n.description, status: n.status}
  end
end
