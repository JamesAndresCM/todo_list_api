defmodule Repositories.TodoListRepository do
  import Ecto.Query, warn: false
  alias TodoListDB.{Repo, TodoList}

  def all() do
    Repo.all(TodoList)
  end

  def list_all() do
    from t in TodoList
  end

  def find_by_id!(id) do
    Repo.get!(TodoList, id)
  end

  def create(params) do
    %TodoList{} |> TodoList.changeset(params) |> Repo.insert()
  end

  def update(todo_list = %TodoList{}, params) do
    todo_list |> TodoList.changeset(params) |> Repo.update()
  end

  def update_status(todo_list = %TodoList{}) do
    todo_list |> TodoList.changeset_status() |> Repo.update()
  end

  def destroy(id) do
    try do
      todo_list = find_by_id!(id)
      Repo.delete(todo_list)
    rescue
      _ ->
        {:error, "record not found"}
    end
  end
end
