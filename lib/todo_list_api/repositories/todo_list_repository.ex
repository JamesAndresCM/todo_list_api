defmodule Repositories.TodoListRepository do
  alias TodoListDB.{Repo, TodoList}
  def all() do
    Repo.all(TodoList)
  end

  def find_by_id!(id) when is_binary(id) do
    Repo.get!(TodoList, id)
  end
  def find_by_id!(_), do: nil

  def create(params) do
    %TodoList{} |> TodoList.changeset(params) |> Repo.insert
  end
end
