"use client";

import { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import { Card } from "./ui/Card";
import { Button } from "./ui/Button";

interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  description: string;
  confirmText?: string;
  cancelText?: string;
  isLoading?: boolean;
  variant?: "primary" | "danger" | "warning";
}

export function ConfirmModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  description,
  confirmText = "Konfirmasi",
  cancelText = "Batal",
  isLoading = false,
  variant = "primary",
}: ConfirmModalProps) {
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

  const btnVariant = variant === "danger" ? "outline" : variant === "warning" ? "secondary" : "primary";
  const btnClass = variant === "danger" 
    ? "bg-rose-500 text-white hover:bg-rose-600 border-none" 
    : "";

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div 
        className="fixed inset-0 bg-black/40 backdrop-blur-sm transition-opacity" 
        onClick={onClose}
      />
      <Card className="w-full max-w-sm shadow-2xl p-6 relative z-[101] animate-slide-in">
        <h3 className="text-lg font-bold mb-2">{title}</h3>
        <p className="text-sm text-foreground/70 mb-6 leading-relaxed">{description}</p>
        <div className="flex justify-end gap-3">
          <Button 
            onClick={onClose} 
            disabled={isLoading}
            variant="ghost"
          >
            {cancelText}
          </Button>
          <Button 
            onClick={onConfirm} 
            disabled={isLoading}
            variant={btnVariant}
            className={btnClass}
          >
            {isLoading ? "Memproses..." : confirmText}
          </Button>
        </div>
      </Card>
    </div>,
    document.body
  );
}
