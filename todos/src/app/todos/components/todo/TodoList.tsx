import TodoItem from './TodoItem';

export default function TodoList({ lists, onEdit, onDelete, onToggle }: any) {
  if (!lists.length) return <p>No hay listas para mostrar.</p>;
  return (
    <ul>
      {lists.map((list: any) => (
        <TodoItem key={list.id} list={list} onEdit={onEdit} onDelete={onDelete} onToggle={onToggle} />
      ))}
    </ul>
  );
}