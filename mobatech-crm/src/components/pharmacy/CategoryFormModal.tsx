"use client";

import { useState } from "react";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";

interface CategoryFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (payload: { name: string; description: string }) => Promise<void>;
}

export function CategoryFormModal({ isOpen, onClose, onSave }: CategoryFormModalProps) {
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;
    setSubmitting(true);
    try {
      await onSave({ name, description });
      setName("");
      setDescription("");
      onClose();
    } catch {
      // Handled by parent
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Kategori Obat">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-semibold mb-2">Nama Kategori</label>
          <input
            disabled={submitting}
            type="text"
            required
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none"
            placeholder="Contoh: Analgesik, Vitamin..."
          />
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">Deskripsi (Opsional)</label>
          <textarea
            disabled={submitting}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none focus:border-primary outline-none"
            placeholder="Deskripsi singkat kategori obat..."
          />
        </div>
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" disabled={submitting} onClick={onClose}>Batal</Button>
          <Button type="submit" isLoading={submitting}>Simpan</Button>
        </div>
      </form>
    </Modal>
  );
}
