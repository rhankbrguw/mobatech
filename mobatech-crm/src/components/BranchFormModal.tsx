import React, { useState, useEffect } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Branch } from "@/types/api";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { ImageUpload } from "@/components/ImageUpload";

const branchSchema = z.object({
  name: z.string().min(1, "Name is required"),
  address: z.string().min(1, "Address is required"),
  latitude: z.number({ message: "Latitude is required" }),
  longitude: z.number({ message: "Longitude is required" }),
  image_url: z.string().optional(),
  gmaps_link: z.string().optional(),
});

type BranchFormData = z.infer<typeof branchSchema>;

export function BranchFormModal({
  isOpen,
  onClose,
  branch,
  onSuccess,
  setToast,
}: {
  isOpen: boolean;
  onClose: () => void;
  branch: Branch | null;
  onSuccess: () => void;
  setToast: (toast: {isOpen: boolean, message: string, type: 'success' | 'error'}) => void;
}) {
  const [saving, setSaving] = useState(false);

  const { register, handleSubmit, reset, control, formState: { errors } } = useForm<BranchFormData>({
    resolver: zodResolver(branchSchema),
    defaultValues: {
      name: "",
      address: "",
      latitude: 0,
      longitude: 0,
      image_url: "",
      gmaps_link: "",
    }
  });

  useEffect(() => {
    if (isOpen) {
      if (branch) {
        reset({
          name: branch.name,
          address: branch.address,
          latitude: branch.latitude,
          longitude: branch.longitude,
          image_url: branch.image_url,
          gmaps_link: branch.gmaps_link,
        });
      } else {
        reset({
          name: "",
          address: "",
          latitude: 0,
          longitude: 0,
          image_url: "",
          gmaps_link: "",
        });
      }
    }
  }, [branch, isOpen, reset]);

  const onSubmit = async (data: BranchFormData) => {
    setSaving(true);
    const payload = {
      ...data,
      image_url: data.image_url || `https://placehold.co/400x400/1e5e44/FFFFFF/png?text=${encodeURIComponent(data.name)}`,
      gmaps_link: data.gmaps_link || "",
    };

    try {
      if (branch) {
        await api.put(`/api/admin/branches/${branch.id}`, payload);
        setToast({ isOpen: true, message: APP_STRINGS.branches.successUpdate, type: "success" });
      } else {
        await api.post("/api/admin/branches", payload);
        setToast({ isOpen: true, message: APP_STRINGS.branches.successCreate, type: "success" });
      }
      onSuccess();
      onClose();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={branch ? APP_STRINGS.branches.editTitle : APP_STRINGS.branches.addTitle}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.nameLabel}</label>
          <input disabled={saving} type="text" {...register("name")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.branches.namePlaceholder} />
          {errors.name && <p className="text-red-500 text-xs mt-1">{errors.name.message}</p>}
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.addressLabel}</label>
          <textarea disabled={saving} {...register("address")} className="w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none focus:border-primary outline-none" placeholder={APP_STRINGS.branches.addressPlaceholder} />
          {errors.address && <p className="text-red-500 text-xs mt-1">{errors.address.message}</p>}
        </div>
        <div className="flex gap-4">
          <div className="flex-1">
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.latLabel}</label>
            <input disabled={saving} type="number" step="any" {...register("latitude", { valueAsNumber: true })} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.branches.latPlaceholder} />
            {errors.latitude && <p className="text-red-500 text-xs mt-1">{errors.latitude.message}</p>}
          </div>
          <div className="flex-1">
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.lngLabel}</label>
            <input disabled={saving} type="number" step="any" {...register("longitude", { valueAsNumber: true })} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.branches.lngPlaceholder} />
            {errors.longitude && <p className="text-red-500 text-xs mt-1">{errors.longitude.message}</p>}
          </div>
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.gmapsLabel}</label>
          <input disabled={saving} type="url" {...register("gmaps_link")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder={APP_STRINGS.branches.gmapsPlaceholder} />
          {errors.gmaps_link && <p className="text-red-500 text-xs mt-1">{errors.gmaps_link.message}</p>}
        </div>
        <Controller
          name="image_url"
          control={control}
          render={({ field }) => (
            <ImageUpload 
              imageUrl={field.value || ""} 
              setImageUrl={(url) => field.onChange(url)} 
              label={APP_STRINGS.branches.imgLabel} 
            />
          )}
        />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>{APP_STRINGS.branches.cancelBtn}</Button>
          <Button type="submit" isLoading={saving}>{APP_STRINGS.branches.saveBtn}</Button>
        </div>
      </form>
    </Modal>
  );
}
