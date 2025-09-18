defmodule Routes.EventRouter do
  use Plug.Router
  
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn =
      conn
      |> put_resp_header("content-type", "text/event-stream")
      |> put_resp_header("cache-control", "no-cache")
      |> put_resp_header("connection", "keep-alive")
      |> put_resp_header("access-control-allow-origin", "*")
      |> put_resp_header("access-control-allow-headers", "content-type")
      |> send_chunked(200)

    # Subscribe to PubSub events
    Phoenix.PubSub.subscribe(TodoListApi.PubSub, "todo_lists:lobby")
    
    # Send initial connection message
    {:ok, conn} = chunk(conn, "data: #{Jason.encode!(%{type: "connected"})}\n\n")
    
    # Keep connection alive and listen for events
    listen_for_events(conn)
  end

  defp listen_for_events(conn) do
    receive do
      {event, payload} ->
        data = Jason.encode!(%{type: event, payload: payload})
        case chunk(conn, "data: #{data}\n\n") do
          {:ok, conn} -> listen_for_events(conn)
          {:error, _} -> conn
        end
    after
      30_000 ->
        # Send keep-alive every 30 seconds
        case chunk(conn, "data: #{Jason.encode!(%{type: "keep-alive"})}\n\n") do
          {:ok, conn} -> listen_for_events(conn)
          {:error, _} -> conn
        end
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
