defmodule TodoList.Repo.Migrations.CreateTodoList do
  use Ecto.Migration

  def change do
    create table(:todo_lists) do
      add :name, :string
      add :description, :text
      add :status, :integer, default: 0

      timestamps()
    end

    create unique_index(:todo_lists, [:name])
  end
end
