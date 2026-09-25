"use client";

import { useEffect, useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { pharmacistSchema, type PharmacistFormValues } from "@/schemas/pharmacist";
import { APP_STRINGS } from "@/constants";
import { User } from "@/types/api";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { PhoneInput } from "@/components/ui/PhoneInput";
import { ImageUpload } from "./ImageUpload";
import { Eye, EyeOff } from "lucide-react";

interface PharmacistFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  pharmacist: User | null;
  onSave: (data: PharmacistFormValues & { role: string }) => Promise<void>;
  showToast?: (message: string, type: "success" | "error") => void;
}

export function PharmacistFormModal({ isOpen, onClose, pharmacist, onSave, showToast }: PharmacistFormModalProps) {
  const [submitting, setSubmitting] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const { register, handleSubmit, control, reset, formState: { errors } } = useForm<PharmacistFormValues>({
    resolver: zodResolver(pharmacistSchema),
    defaultValues: { full_name: "", email: "", phone_number: "+62", password: "", image_url: "" },
  });

  useEffect(() => {
    if (isOpen) {
      reset({
        full_name: pharmacist?.full_name || "",
        email: pharmacist?.email || "",
        phone_number: pharmacist?.phone_number || "+62",
        password: "",
        image_url: pharmacist?.image_url || "",
      });
      setShowPassword(false);
    }
  }, [pharmacist, isOpen, reset]);

  const onSubmit = async (data: PharmacistFormValues) => {
    setSubmitting(true);
    try {
      await onSave({ ...data, role: "pharmacist" });
      onClose();
    } catch {
      showToast?.(APP_STRINGS.common.saveError, "error");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={pharmacist ? APP_STRINGS.pharmacists.editTitle : APP_STRINGS.pharmacists.addTitle}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacists.nameLabel}</label>
          <input disabled={submitting} type="text" {...register("full_name")} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.full_name ? "border-error focus:border-error" : ""}`} placeholder={APP_STRINGS.pharmacists.namePlaceholder} />
          {errors.full_name && <p className="text-xs text-error mt-1">{errors.full_name.message}</p>}
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacists.emailLabel}</label>
            <input disabled={submitting} type="email" {...register("email")} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.email ? "border-error focus:border-error" : ""}`} placeholder={APP_STRINGS.pharmacists.emailPlaceholder} />
            {errors.email && <p className="text-xs text-error mt-1">{errors.email.message}</p>}
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacists.phoneLabel}</label>
            <Controller control={control} name="phone_number" render={({ field }) => (<PhoneInput disabled={submitting} value={field.value} onChange={field.onChange} className={errors.phone_number ? "border-error focus-within:border-error" : ""} />)} />
            {errors.phone_number && <p className="text-xs text-error mt-1">{errors.phone_number.message}</p>}
          </div>
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacists.passwordLabel}</label>
          <div className="relative">
            <input disabled={submitting} type={showPassword ? "text" : "password"} {...register("password")} className={`w-full h-10 px-3 pr-10 rounded-xl border glass-input text-sm text-foreground ${errors.password ? "border-error focus:border-error" : ""}`} placeholder={pharmacist ? APP_STRINGS.pharmacists.passwordEditNote : APP_STRINGS.pharmacists.passwordPlaceholder} />
            <button type="button" disabled={submitting} onClick={() => setShowPassword((p) => !p)} className="absolute right-3 top-1/2 -translate-y-1/2 text-foreground/40 hover:text-foreground transition-colors cursor-pointer">
              {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
            </button>
          </div>
          {errors.password && <p className="text-xs text-error mt-1">{errors.password.message}</p>}
        </div>
        <Controller control={control} name="image_url" render={({ field }) => (<ImageUpload imageUrl={field.value || ""} setImageUrl={(val) => field.onChange(val)} label="Foto Profil Apoteker" />)} />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" disabled={submitting} onClick={onClose}>{APP_STRINGS.doctors.cancelBtn}</Button>
          <Button type="submit" isLoading={submitting}>{APP_STRINGS.doctors.saveBtn}</Button>
        </div>
      </form>
    </Modal>
  );
}
