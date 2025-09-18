defmodule Router do
  # Bring Plug.Router module into scope
  use Plug.Router
  use Plug.ErrorHandler

  # Attach the Logger to log incoming requests 
  plug(Plug.Logger)

  plug CORSPlug,
  origin: [System.get_env("FRONTEND_URL"), "http://localhost:3000"],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  headers: ["Content-Type", "Authorization", "Cache-Control"],
  max_age: 86400

  
  # Tell Plug to match the incoming request with the defined endpoints
  plug(:match)

  # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route.(Using the Jayson parser)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # SSE events route - delegated to EventRouter
  forward "/api/v1/events", to: Routes.EventRouter

  forward "/api/v1", to: Routes.TodoListRouter
  # Dispatch the connection to the matched handler
  plug(:dispatch)

  # Fallback handler when there was no match
  match _ do
    conn
    |> Plug.Conn.put_resp_header("location", "/api/v1/todo_lists")
    |> Plug.Conn.send_resp(302, "Redirecting...")
    |> halt()
  end
end
