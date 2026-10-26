"use client";
import { useState, useEffect } from "react";
import { APP_STRINGS } from "@/constants";
import { Promo } from "@/types/api";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";

interface PromosFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  promo?: Promo | null;
  onSuccess: () => void;
  setToast: (toast: { isOpen: boolean; message: string; type: "success" | "error" }) => void;
}

function usePromosForm(isOpen: boolean, promo: Promo | null | undefined, onClose: () => void, onSuccess: () => void, setToast: (t: { isOpen: boolean; message: string; type: "success" | "error" }) => void) {
  const queryClient = useQueryClient();
  const [formData, setFormData] = useState({ title: "", subtitle: "", themeColor: APP_STRINGS.promos.defaultColor as string, is_active: true });

  useEffect(() => {
    if (isOpen) {
      setFormData({
        title: promo?.title || "", subtitle: promo?.subtitle || "",
        themeColor: promo?.themeColor || APP_STRINGS.promos.defaultColor, is_active: promo?.is_active ?? true,
      });
    }
  }, [isOpen, promo]);

  const promoMutation = useMutation({
    mutationFn: (data: typeof formData) => {
      if (promo?.id) return adminService.updatePromo(promo.id, data);
      return adminService.createPromo(data);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.promoSaveSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["promos"] });
      onSuccess();
      onClose();
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof Error ? err.message : APP_STRINGS.common.saveError, type: "error" });
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    promoMutation.mutate(formData);
  };

  return { formData, setFormData, isSubmitting: promoMutation.isPending, handleSubmit };
}

function PromosFormFields({ formData, setFormData, isSubmitting }: { formData: { title: string; subtitle: string; themeColor: string; is_active: boolean }; setFormData: React.Dispatch<React.SetStateAction<{ title: string; subtitle: string; themeColor: string; is_active: boolean }>>; isSubmitting: boolean }) {
  return (
    <>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.promos.title}</label>
        <input disabled={isSubmitting} type="text" required value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder={APP_STRINGS.promos.titlePlaceholder} />
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.promos.subtitle}</label>
        <input disabled={isSubmitting} type="text" required value={formData.subtitle} onChange={(e) => setFormData({ ...formData, subtitle: e.target.value })} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder={APP_STRINGS.promos.subtitlePlaceholder} />
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.promos.themeColor}</label>
          <div className="flex items-center gap-3">
            <input disabled={isSubmitting} required type="color" value={formData.themeColor} onChange={(e) => setFormData({ ...formData, themeColor: e.target.value })} className="w-10 h-10 rounded-lg cursor-pointer border-0 bg-transparent p-0" />
            <input disabled={isSubmitting} required type="text" value={formData.themeColor} onChange={(e) => setFormData({ ...formData, themeColor: e.target.value })} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground uppercase font-mono focus:border-primary outline-none transition-all" placeholder={APP_STRINGS.promos.defaultColor} />
          </div>
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.promos.statusActive}</label>
          <label className="flex items-center mt-3 cursor-pointer">
            <input disabled={isSubmitting} type="checkbox" checked={formData.is_active} onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })} className="w-5 h-5 rounded border-glass-border text-primary focus:ring-primary/50 bg-overlay-dark dark:bg-overlay-light" />
            <span className="ml-2 text-sm text-foreground/75">{APP_STRINGS.promos.active}</span>
          </label>
        </div>
      </div>
    </>
  );
}

// Migrated to React Query
export function PromosFormModal({ isOpen, onClose, promo, onSuccess, setToast }: PromosFormModalProps) {
  const { formData, setFormData, isSubmitting, handleSubmit } = usePromosForm(isOpen, promo, onClose, onSuccess, setToast);
  return (
    <Modal isOpen={isOpen} onClose={onClose} title={promo ? APP_STRINGS.promos.editPromo : APP_STRINGS.promos.addPromo}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <PromosFormFields formData={formData} setFormData={setFormData} isSubmitting={isSubmitting} />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>Batal</Button>
          <Button type="submit" isLoading={isSubmitting}>Simpan</Button>
        </div>
      </form>
    </Modal>
  );
}
