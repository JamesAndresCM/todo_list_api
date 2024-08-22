defmodule Routes.TodoListRouter do
  use Plug.Router
  alias Repositories.TodoListRepository
  alias Serializers.{TodoListJSON, ChangesetJSON}
  alias Services.PaginatorService
  plug(:match)
  @default_record 0

  # We want the response to be sent in json format.
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  plug(:dispatch)

  defp set_todo_list(conn) do
    todo_list_id = try do
      conn.params["id"] |> String.to_integer()
    rescue _ ->
      @default_record
    end

    conn =
      try do
        assign(conn, :todo_list, TodoListRepository.find_by_id!(todo_list_id))
      rescue
        _ ->
          error_message = Jason.encode!(%{error: "record not found"})
          resp_content_json(conn, 404, error_message)
      end

    conn
  end

  defp resp_content_json(conn, code, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, message)
    |> halt()
  end

  get "/todo_lists" do
    todo_lists = TodoListRepository.list_all()
    paginator = todo_lists |> PaginatorService.new(conn.query_params)

    meta_data = %{
      page_number: paginator.page_number,
      per_page: paginator.per_page,
      total_pages: paginator.total_pages,
      total_elements: paginator.total_elements
    }

    todo_lists = TodoListJSON.index(paginator.entries, meta_data)
    resp_content_json(conn, 200, Jason.encode!(todo_lists))
  end

  get "/todo_lists/:id" do
    conn = set_todo_list(conn)
    todo_list = conn.assigns[:todo_list]

    if todo_list do
      resp_content_json(conn, 200, Jason.encode!(todo_list |> TodoListJSON.show()))
    else
      conn
    end
  end

  post "/todo_lists" do
    params = Map.get(conn.body_params, "todo_list", %{})

    case TodoListRepository.create(params) do
      {:ok, todo_list} ->
        resp_content_json(conn, 200, Jason.encode!(todo_list |> TodoListJSON.show()))

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})
        resp_content_json(conn, 422, Jason.encode!(errors))
    end
  end

  delete "/todo_lists/:id" do
    case TodoListRepository.destroy(id) do
      {:ok, record} ->
        resp_content_json(
          conn,
          200,
          Jason.encode!(%{message: "record #{record.id} has been destroyed!"})
        )

      {:error, message} ->
        resp_content_json(conn, 422, Jason.encode!(%{message: message}))
    end
  end

  put "/todo_lists/:id" do
    params = Map.get(conn.body_params, "todo_list", %{})
    conn = set_todo_list(conn)
    todo_list = conn.assigns[:todo_list]

    if todo_list do
      case TodoListRepository.update(todo_list, params) do
        {:ok, record} ->
          resp_content_json(conn, 200, Jason.encode!(record |> TodoListJSON.show()))

        {:error, changeset} ->
          errors = ChangesetJSON.error(%{changeset: changeset})
          resp_content_json(conn, 422, Jason.encode!(errors))
      end
    else
      conn
    end
  end

  put "/todo_lists/:id/toggle" do
    conn = set_todo_list(conn)
    todo_list = conn.assigns[:todo_list]

    if todo_list do
      case TodoListRepository.update_status(todo_list) do
        {:ok, todo_list} ->
          resp_content_json(conn, 200, Jason.encode!(todo_list |> TodoListJSON.show()))

        _ ->
          resp_content_json(conn, 422, Jason.encode!(%{message: "error to change status"}))
      end
    else
      conn
    end
  end

  match _ do
    resp_content_json(conn, 404, Jason.encode!(%{error: "Route not found"}))
  end
end
