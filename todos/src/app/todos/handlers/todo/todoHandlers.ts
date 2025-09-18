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

export const handleCreate = (setLists: React.Dispatch<React.SetStateAction<TodoList[]>>) => {
  return async (data: TodoFormPayload) => {
    try {
      const newList = await createTodoList({ name: data.name, description: data.description });
      
      // Reset form after successful creation
      data.resetForm();
      
      // Don't update state here - let real-time events handle it
      // This prevents duplicates when SSE events arrive
      console.log('Item created successfully, waiting for real-time update...');
      
      return newList;
    } catch (error: any) {
      console.error('Error creating todo list:', error);
      
      // Set validation errors if they exist
      if (error.validationErrors) {
        data.setErrors(error.validationErrors);
      }
      
      throw error;
    }
  };
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
    
    // Don't update state here - let real-time events handle it
    // This prevents duplicates when SSE events arrive
    console.log('Item updated successfully, waiting for real-time update...');
    
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
    
    // Don't update state here - let real-time events handle it
    // This prevents duplicates when SSE events arrive
    console.log('Item deleted successfully, waiting for real-time update...');
    
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
    
    // Don't update state here - let real-time events handle it
    // This prevents duplicates when SSE events arrive
    console.log('Item toggled successfully, waiting for real-time update...');
    
  } catch (err) {
    console.error(err);
  }
};
