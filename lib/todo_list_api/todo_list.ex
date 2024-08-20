defmodule TodoListDB.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses [incomplete: 0, complete: 1]
  schema "todo_lists" do
    field(:name)
    field(:description)
    field(:status, Ecto.Enum, values: @statuses, default: :incomplete)
    timestamps()
  end

  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  def changeset_status(todo_list) do
    todo_list |> Ecto.Changeset.change() |> toggle_status()
  end

  defp toggle_status(changeset) do
    status =
      case changeset.data.status do
        :complete -> :incomplete
        :incomplete -> :complete
        _ -> :incomplete
      end

    put_change(changeset, :status, status)
  end
end
