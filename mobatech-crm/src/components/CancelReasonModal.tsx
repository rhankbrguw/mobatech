import React, { useState } from "react";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";

interface CancelReasonModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (reason: string) => void;
  isLoading?: boolean;
  title?: string;
  description?: string;
}

export function CancelReasonModal({
  isOpen,
  onClose,
  onConfirm,
  isLoading = false,
  title = "Batalkan Janji Temu",
  description = "Silakan masukkan alasan pembatalan janji temu. Pihak terkait akan menerima notifikasi penjelasan ini.",
}: CancelReasonModalProps) {
  const [reason, setReason] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = reason.trim();
    if (trimmed.length < 5) {
      setError("Alasan pembatalan wajib diisi minimal 5 karakter");
      return;
    }
    setError("");
    onConfirm(trimmed);
  };

  const handleClose = () => {
    setReason("");
    setError("");
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={handleClose} title={title}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <p className="text-sm text-foreground/70">{description}</p>
        <div>
          <label htmlFor="cancel-reason" className="block text-xs font-semibold uppercase tracking-wider text-foreground/70 mb-1.5">
            Alasan Pembatalan <span className="text-error">*</span>
          </label>
          <textarea
            id="cancel-reason"
            rows={3}
            className="w-full border border-glass-border rounded-xl p-3 bg-overlay-dark dark:bg-overlay-light text-foreground text-sm outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all placeholder:text-foreground/40"
            placeholder="Contoh: Dokter berhalangan hadir atau ada perubahan jadwal poliklinik."
            value={reason}
            onChange={(e) => {
              setReason(e.target.value);
              if (error) setError("");
            }}
          />
          {error && <p className="text-xs text-error mt-1">{error}</p>}
        </div>
        <div className="flex justify-end gap-3 pt-2">
          <Button type="button" variant="outline" onClick={handleClose} disabled={isLoading}>
            Batal
          </Button>
          <Button type="submit" variant="danger" disabled={isLoading || reason.trim().length < 5} isLoading={isLoading}>
            Konfirmasi Pembatalan
          </Button>
        </div>
      </form>
    </Modal>
  );
}
