import React from "react";
import { Modal } from "@/components/Modal";

interface RejectPrescriptionModalProps {
  isOpen: boolean;
  onClose: () => void;
  rejectReason: string;
  setRejectReason: (reason: string) => void;
  onSubmit: () => void;
}

export function RejectPrescriptionModal({
  isOpen,
  onClose,
  rejectReason,
  setRejectReason,
  onSubmit,
}: RejectPrescriptionModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tolak E-Resep">
      <div className="space-y-4">
        <p className="text-sm text-foreground/70">
          Silakan masukkan alasan penolakan E-Resep ini. Pasien akan menerima notifikasi beserta alasan yang Anda berikan.
        </p>
        <div>
          <label className="block text-sm font-medium mb-1">Alasan Penolakan</label>
          <textarea
            className="w-full border border-glass-border rounded-xl p-3 bg-overlay-dark dark:bg-overlay-light outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
            rows={4}
            placeholder="Contoh: Stok obat Paracetamol sedang kosong."
            value={rejectReason}
            onChange={(e) => setRejectReason(e.target.value)}
          />
        </div>
        <div className="flex justify-end gap-3 mt-4">
          <button
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium border border-glass-border rounded-xl hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors"
          >
            Batal
          </button>
          <button
            onClick={onSubmit}
            className="px-4 py-2 text-sm font-medium bg-error text-error-foreground rounded-xl hover:bg-error/90 transition-colors"
          >
            Tolak Resep
          </button>
        </div>
      </div>
    </Modal>
  );
}
