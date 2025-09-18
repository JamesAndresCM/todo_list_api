'use client';

import { useEffect, useState, useCallback } from 'react';
import { fetchTodoLists } from '../todos/api/todo';
import { TodoList as TodoListType, Meta } from '@/app/todos/interfaces/todo/todo';
import { TodoList, TodoForm, Pagination } from '@/app/todos/components/todo';
import { handleCreate, handleUpdate, handleDelete, handleToggle } from '@/app/todos/handlers/todo';
import { TodoFormPayload } from '@/app/todos/interfaces/todo';
import { useServerSentEvents } from '@/app/todos/hooks/useServerSentEvents';


export default function TodoPage() {
  const [lists, setLists] = useState<TodoListType[]>([]);
  const [meta, setMeta] = useState<Meta | null>(null);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  
  const handleRealtimeMessage = useCallback((event: string, payload: any) => {
    console.log('Real-time event:', event, payload);
    
    switch (event) {
      case 'todo_list_created':
        setLists(prev => [payload.data, ...prev]);
        break;
      case 'todo_list_updated':
        setLists(prev => prev.map(list => 
          list.id === payload.data.id ? payload.data : list
        ));
        break;
      case 'todo_list_deleted':
        setLists(prev => prev.filter(list => list.id !== payload.id));
        break;
      case 'todo_list_toggled':
        setLists(prev => prev.map(list => 
          list.id === payload.data.id ? payload.data : list
        ));
        break;
    }
  }, []);

  const { connect, disconnect, isConnected } = useServerSentEvents(handleRealtimeMessage);

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

  useEffect(() => {
    // Connect to SSE when component mounts
    connect();
    
    // Cleanup on component unmount is handled in the hook
  }, [connect]);

  const handleEdit = (list: TodoListType) => {
    setEditingId(list.id);
  };

  return (
    <main className="p-4 max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">
        Todo Lists 
        {isConnected && <span className="text-green-500 text-sm ml-2">🟢 En tiempo real</span>}
        {!isConnected && <span className="text-red-500 text-sm ml-2">🔴 Desconectado</span>}
      </h1>

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
            : handleCreate(setLists)(payload)
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
