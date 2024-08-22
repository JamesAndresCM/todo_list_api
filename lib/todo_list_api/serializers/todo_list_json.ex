defmodule Serializers.TodoListJSON do
  def index(todo_lists, meta) do
    %{data: for(el <- todo_lists, do: data(el)), meta: meta}
  end

  def show(todo_list) do
    %{data: data(todo_list)}
  end

  defp data(todo_list) do
    %{
      id: todo_list.id,
      name: todo_list.name,
      description: todo_list.description,
      status: todo_list.status
    }
  end
end
