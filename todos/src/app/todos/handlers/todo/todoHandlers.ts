'use client';

import {
  createTodoList,
  deleteTodoList,
  updateTodoList,
  toggleTodoListStatus,
} from '@/app/todos/api/todo';
import {
  TodoFormPayload,
  UpdatePayload,
  TodoList
} from '@/app/todos/interfaces/todo';

export const handleCreate = async (
  { name, description, resetForm, setErrors }: TodoFormPayload,
  setLists: React.Dispatch<React.SetStateAction<TodoList[]>>
) => {
  try {
    const newList = await createTodoList({ name, description });
    setLists((prev) => [newList, ...prev]);
    resetForm();
  } catch (err: any) {
    if (err.validationErrors) setErrors(err.validationErrors);
  }
};

export const handleUpdate = async (
  {
    editingId,
    name,
    description,
    resetForm,
    setErrors,
    setEditingId,
  }: UpdatePayload,
  setLists: React.Dispatch<React.SetStateAction<TodoList[]>>
) => {
  try {
    const updated = await updateTodoList(editingId, { name, description });
    setLists((prev) =>
      prev.map((l) => (l.id === editingId ? updated : l))
    );
    setEditingId(null);
    resetForm();
  } catch (err: any) {
    if (err.validationErrors) setErrors(err.validationErrors);
  }
};

export const handleDelete = async (
  id: number | string,
  setLists: React.Dispatch<React.SetStateAction<TodoList[]>>
) => {
  if (!confirm('¿Estás seguro?')) return;
  try {
    await deleteTodoList(id);
    setLists((prev) => prev.filter((l) => l.id !== id));
    
  } catch (err) {
    console.error(err);
  }
};

export const handleToggle = async (
  id: number | string,
  setLists: React.Dispatch<React.SetStateAction<TodoList[]>>
) => {
  try {
    const updated = await toggleTodoListStatus(id);
    setLists((prev) => prev.map((l) => (l.id === id ? updated : l)));
  } catch (err) {
    console.error(err);
  }
};
