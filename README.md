# TodoListApi

## Initial Setup
- Set database url in `.env` file
- Install dependencies `mix deps.get`
- Create database and migrate `MIX_ENV=dev mix ecto.setup`
- execute `MIX_ENV=dev mix run --no-halt`

## Endpoints
- [postman](https://documenter.getpostman.com/view/3505861/2sA3sAfn5u)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `todo_list_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:todo_list_api, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/todo_list_api>.

