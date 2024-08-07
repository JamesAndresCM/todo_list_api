defmodule TodoListDB.Repo do
  use Ecto.Repo,
    otp_app: :todo_list_api,
    adapter: Ecto.Adapters.Postgres

  def count(table) do
    aggregate(table, :count, :id)
  end

  def first(table) do
    table |> first()
  end

  def last(table) do
    table |> last()
  end
end
