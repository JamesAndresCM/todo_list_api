export interface TodoFormPayload {
  name: string;
  description: string;
  resetForm: () => void;
  setErrors: (errors: any) => void;
}

export interface UpdatePayload extends TodoFormPayload {
  editingId: number;
  setEditingId: (id: number | null) => void;
}
