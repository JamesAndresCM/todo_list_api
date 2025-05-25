'use client';

import { useEffect, useState } from 'react';
import { fetchTodoLists } from '../todos/api/todo';
import { TodoList as TodoListType, Meta } from '@/app/todos/interfaces/todo/todo';
import { TodoList, TodoForm, Pagination } from '@/app/todos/components/todo';
import { handleCreate, handleUpdate, handleDelete, handleToggle } from '@/app/todos/handlers/todo';
import { TodoFormPayload } from '@/app/todos/interfaces/todo';


export default function TodoPage() {
  const [lists, setLists] = useState<TodoListType[]>([]);
  const [meta, setMeta] = useState<Meta | null>(null);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchTodoLists(page)
      .then((res) => {
        setLists(res.data);
        setMeta(res.meta);
      })
      .catch((e) => {
        console.error('Error al cargar las listas:', e);
      })
      .finally(() => setLoading(false));
  }, [page]);

  const handleEdit = (list: TodoListType) => {
    setEditingId(list.id);
  };

  return (
    <main className="p-4 max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Todo Lists</h1>

      <TodoForm
        key={editingId ?? 'create'}
        editingId={editingId}
        onCancel={() => setEditingId(null)}
        onSubmit={(payload: TodoFormPayload) =>
          editingId
            ? handleUpdate(
                {
                  ...payload,
                  editingId,
                  setEditingId,
                },
                setLists
              )
            : handleCreate(payload, setLists)
        }
        initialData={editingId ? lists.find((l) => l.id === editingId) : null}
      />


      {loading ? (
        <p>Cargando...</p>
      ) : (
        <TodoList
          lists={lists}
          onEdit={handleEdit}
          onDelete={(id: number | string) => handleDelete(id, setLists)}
          onToggle={(id: number | string) => handleToggle(id, setLists)}
        />
      )}

      {meta && <Pagination meta={meta} setPage={setPage} />}
    </main>
  );
}
