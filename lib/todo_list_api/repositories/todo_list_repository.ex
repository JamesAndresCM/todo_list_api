defmodule Repositories.TodoListRepository do
  alias TodoListDB.{Repo, TodoList}
  def all() do
    Repo.all(TodoList)
  end
end
