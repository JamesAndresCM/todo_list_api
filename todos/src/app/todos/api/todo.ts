import { TodoList, ApiResponse } from "@/app/todos/interfaces/todo/todo";

const BASE_URL = "http://localhost:4000/api/v1";

export async function fetchTodoLists(
  page: number = 1,
  per_page: number = 10
): Promise<ApiResponse<TodoList>> {
  const res = await fetch(`${BASE_URL}/todo_lists?page=${page}&per_page=${per_page}`, {
    cache: "no-store",
  });
  if (!res.ok) throw new Error("Error al obtener las listas: " + res.statusText);
  const json: ApiResponse<TodoList> = await res.json();

  json.data = json.data.map(list => ({
    ...list
  }));

  return json;
}

export async function createTodoList(data: { name: string; description: string }): Promise<TodoList> {
  const res = await fetch(`${BASE_URL}/todo_lists`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ todo_list: data }),
  });

  const json = await res.json();

  if (!res.ok) {
    if (json.errors) {
      throw { validationErrors: json.errors };
    } else {
      throw new Error("Error desconocido al crear la lista.");
    }
  }

  return json.data;
}

export async function deleteTodoList(id: string | number): Promise<void> {
  const res = await fetch(`${BASE_URL}/todo_lists/${id}`, {
    method: "DELETE",
  });

  if (!res.ok) {
    throw new Error("Error al eliminar la lista");
  }
}

export async function updateTodoList(id: string | number, data: { name: string; description: string }): Promise<TodoList> {
  const res = await fetch(`${BASE_URL}/todo_lists/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ todo_list: data }),
  });

  const json = await res.json();

  if (!res.ok) {
    if (json.errors) {
      throw { validationErrors: json.errors };
    }
    throw new Error("Error al actualizar la lista");
  }

  return json.data;
}

export async function toggleTodoListStatus(id: number | string): Promise<TodoList> {
  const res = await fetch(`${BASE_URL}/todo_lists/${id}/toggle`, {
    method: "PUT",
  });
  if (!res.ok) {
    const errorJson = await res.json().catch(() => ({}));
    throw new Error(`Error al cambiar status: ${JSON.stringify(errorJson)}`);
  }
  const json = await res.json();
  return json.data;
}


