defmodule Routes.TodoListRouter do
  use Plug.Router
  alias Repositories.TodoListRepository
  alias Serializers.{TodoListJSON, ChangesetJSON}
  plug(:match)

  # We want the response to be sent in json format.
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  plug(:dispatch)

  defp set_todo_list(conn) do
    todo_list_id = conn.params["id"] |> String.to_integer()

    conn =
      try do
        assign(conn, :todo_list, TodoListRepository.find_by_id!(todo_list_id))
      rescue
        _ ->
          error_message = Jason.encode!(%{error: "record not found"})

          conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, error_message)
          |> halt()
      end

    conn
  end

  get "/todo_lists" do
    todo_lists = TodoListRepository.all() |> TodoListJSON.index()
    send_resp(conn, 200, Jason.encode!(todo_lists))
  end

  get "/todo_lists/:id" do
    conn = set_todo_list(conn)
    todo_list = conn.assigns[:todo_list]

    if todo_list do
      send_resp(conn, 200, Jason.encode!(todo_list |> TodoListJSON.show()))
    else
      conn
    end
  end

  post "/todo_lists" do
    params = Map.get(conn.body_params, "todo_list", %{})

    case TodoListRepository.create(params) do
      {:ok, todo_list} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(todo_list |> TodoListJSON.show()))

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(errors))
    end
  end

  delete "/todo_lists/:id" do
    case TodoListRepository.destroy(id) do
      {:ok, record} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "record #{record.id} has been destroyed!"}))

      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: message}))
    end
  end

  put "/todo_lists/:id" do
    params = Map.get(conn.body_params, "todo_list", %{})
    conn = set_todo_list(conn)
    todo_list = conn.assigns[:todo_list]

    if todo_list do
      case TodoListRepository.update(todo_list, params) do
        {:ok, record} ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(record |> TodoListJSON.show()))

        {:error, changeset} ->
          errors = ChangesetJSON.error(%{changeset: changeset})

          conn
          |> put_resp_content_type("application/json")
          |> send_resp(422, Jason.encode!(errors))
      end
    else
      conn
    end
  end
end
