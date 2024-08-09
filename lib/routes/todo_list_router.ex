defmodule Routes.TodoListRouter do
  use Plug.Router
  alias Repositories.TodoListRepository
  alias Serializers.{TodoListJSON, ChangesetJSON}
  plug :match

  # We want the response to be sent in json format.
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :dispatch

  get "/todo_lists" do
    todo_lists = TodoListRepository.all() |> TodoListJSON.index
    send_resp(conn, 200, Jason.encode!(todo_lists))
  end

  get "/todo_lists/:id" do
    try do
      todo_list = TodoListRepository.find_by_id!(id)
      send_resp(conn, 200, Jason.encode!(todo_list |> TodoListJSON.show))
    rescue _ ->
      send_resp(conn, 404, Jason.encode!(%{error: "record not found"}))
    end
  end

  post "/todo_lists" do
    params = Map.get(conn.body_params, "todo_list", %{})
    case TodoListRepository.create(params) do
      {:ok, todo_list} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(todo_list |> TodoListJSON.show))
      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(errors))
    end
  end
end
