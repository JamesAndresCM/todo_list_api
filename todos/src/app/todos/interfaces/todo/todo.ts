export interface TodoList {
  id: number;
  name: string;
  description: string;
  status: 'complete' | 'incomplete';
}

export interface Meta {
  page_number: number;
  per_page: number;
  total_elements: number;
  total_pages: number;
}

export interface ApiResponse<T> {
  data: T[];
  meta: Meta;
}
