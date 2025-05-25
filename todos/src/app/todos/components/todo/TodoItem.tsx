export default function TodoItem({ list, onEdit, onDelete, onToggle }: any) {
  return (
    <li className="border p-2 my-1 flex justify-between items-center">
      <input type="checkbox" checked={list.status === 'complete'} onChange={() => onToggle(list.id)} />
      <div>
        <strong>{list.name}</strong> - {list.description}
      </div>
      <div className="space-x-2">
        <button onClick={() => onEdit(list)} className="bg-blue-500 text-white px-2 py-1 rounded">Editar</button>
        <button onClick={() => onDelete(list.id)} className="bg-red-500 text-white px-2 py-1 rounded">Eliminar</button>
      </div>
    </li>
  );
}