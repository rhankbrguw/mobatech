"use client";

import { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import { Card } from "./ui/Card";

interface DeleteModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title?: string;
  description?: string;
  isLoading?: boolean;
}

export function DeleteModal({
  isOpen,
  onClose,
  onConfirm,
  title = "Konfirmasi Hapus",
  description = "Apakah Anda yakin ingin menghapus data ini?",
  isLoading = false,
}: DeleteModalProps) {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [isOpen]);

  if (!isOpen || !mounted) return null;

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div 
        className="fixed inset-0 bg-black/40 backdrop-blur-sm" 
        onClick={onClose}
      />
      <Card className="w-full max-w-sm shadow-2xl p-6 relative z-[101] animate-slide-in">
        <h3 className="text-base font-bold mb-2">{title}</h3>
        <p className="text-sm text-foreground/70 mb-6">{description}</p>
        <div className="flex justify-end gap-2">
          <button 
            onClick={onClose} 
            disabled={isLoading}
            className="px-4 py-2 text-sm font-medium hover:bg-black/5 dark:hover:bg-white/5 rounded-lg transition-colors disabled:opacity-50"
          >
            Batal
          </button>
          <button 
            onClick={onConfirm} 
            disabled={isLoading}
            className="px-4 py-2 text-sm font-medium bg-rose-500 text-white rounded-lg hover:bg-rose-600 transition-colors flex items-center justify-center disabled:opacity-50"
          >
            {isLoading ? "Menghapus..." : "Hapus"}
          </button>
        </div>
      </Card>
    </div>,
    document.body
  );
}
