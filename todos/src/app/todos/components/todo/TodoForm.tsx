'use client';
import { useState, useEffect, FormEvent } from 'react';

export default function TodoForm({ editingId, initialData, onSubmit, onCancel }: any) {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [errors, setErrors] = useState<any>({});

  useEffect(() => {
    if (initialData) {
      setName(initialData.name);
      setDescription(initialData.description);
    } else {
      setName('');
      setDescription('');
    }
  }, [initialData]);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    onSubmit({ name, description, setErrors, resetForm });
  };

  const resetForm = () => {
    setName('');
    setDescription('');
    setErrors({});
  };

  return (
    <form onSubmit={handleSubmit} className="mb-4">
      <div className="mb-2">
        <input value={name} onChange={e => setName(e.target.value)} placeholder="Nombre" className="border px-2 py-1 w-full" />
        {errors.name && <p className="text-red-600 text-sm">{errors.name.join(', ')}</p>}
      </div>

      <div className="mb-2">
        <textarea value={description} onChange={e => setDescription(e.target.value)} placeholder="Descripción" className="border px-2 py-1 w-full" />
        {errors.description && <p className="text-red-600 text-sm">{errors.description.join(', ')}</p>}
      </div>

      <button type="submit" className="bg-blue-600 text-white px-4 py-1 disabled:bg-gray-400" disabled={!name || !description}>
        {editingId ? 'Actualizar' : 'Agregar'}
      </button>

      {editingId && (
        <button type="button" onClick={onCancel} className="ml-2 text-gray-600 underline">
          Cancelar
        </button>
      )}
    </form>
  );
}