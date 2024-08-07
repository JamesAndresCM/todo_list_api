defmodule TodoListDB.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses [incomplete: 0, complete: 1]
  schema "todo_lists" do
    field :name
    field :description
    field :status, Ecto.Enum, values: @statuses, default: :incomplete
    timestamps()
  end

  def changeset(todo_list, attrs) do
    todo_list 
    |> cast(attrs, [:name, :description, :status])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
