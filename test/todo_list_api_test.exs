defmodule Routes.TodoListRouterTest do
  use ExUnit.Case
  use Plug.Test

  alias TodoListDB.Repo
  alias Router
  alias Repositories.TodoListRepository

  @opts Router.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    todo_list = create_todo_list_fixture()
    {:ok, todo_list: todo_list}
  end

  defp create_todo_list_fixture do
    params = %{
      name: "Test Todo List",
      description: "This is a test todo list."
    }
    TodoListRepository.create(params)
  end

  test "GET /todo_lists returns a list of todo lists" do
    conn = conn(:get, "/api/v1/todo_lists")
    conn = Router.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body != ""
  end
 end
