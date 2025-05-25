export default function Pagination({ meta, setPage }: any) {
  return (
    <nav className="mt-4 flex justify-between max-w-xs mx-auto">
      <button onClick={() => setPage((p: number) => Math.max(p - 1, 1))} disabled={meta.page_number <= 1} className="px-4 py-2 bg-gray-300 rounded disabled:opacity-50">Anterior</button>
      <span>Página {meta.page_number} de {meta.total_pages}</span>
      <button onClick={() => setPage((p: number) => (p < meta.total_pages ? p + 1 : p))} disabled={meta.page_number >= meta.total_pages} className="px-4 py-2 bg-gray-300 rounded disabled:opacity-50">Siguiente</button>
    </nav>
  );
}