defmodule Repositories.TodoListRepository do
  alias TodoListDB.{Repo, TodoList}
  def all() do
    Repo.all(TodoList)
  end

  def find_by_id!(id) do
    Repo.get!(TodoList, id)
  end

  def create(params) do
    %TodoList{} |> TodoList.changeset(params) |> Repo.insert
  end

  def update(todo_list = %TodoList{}, params) do
    todo_list |> TodoList.changeset(params) |> Repo.update()
  end

  def destroy(id) do
    try do
     todo_list = find_by_id!(id)
     Repo.delete(todo_list)
    rescue _ ->
      {:error, "record not found"}
    end
  end
end
