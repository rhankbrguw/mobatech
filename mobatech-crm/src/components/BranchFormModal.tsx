import React, { useEffect } from "react";
import { useForm, Controller, Control, FieldErrors, UseFormRegister } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { branchSchema, type BranchFormData } from "@/schemas/branch";
import { Branch } from "@/types/api";
import { APP_STRINGS } from "@/constants";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { ImageUpload } from "@/components/ImageUpload";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";

interface BranchFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  branch: Branch | null;
  onSuccess: () => void;
  setToast: (toast: {isOpen: boolean, message: string, type: 'success' | 'error'}) => void;
}

function BranchBasicFields({ register, errors, saving }: { register: UseFormRegister<BranchFormData>; errors: FieldErrors<BranchFormData>; saving: boolean }) {
  return (
    <>
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
    </>
  );
}

function BranchLocationFields({ register, control, errors, saving }: { register: UseFormRegister<BranchFormData>; control: Control<BranchFormData>; errors: FieldErrors<BranchFormData>; saving: boolean }) {
  return (
    <>
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
      <Controller name="image_url" control={control} render={({ field }) => (<ImageUpload imageUrl={field.value || ""} setImageUrl={(url) => field.onChange(url)} label={APP_STRINGS.branches.imgLabel} />)} />
    </>
  );
}

// Migrated to React Query
export function BranchFormModal({ isOpen, onClose, branch, onSuccess, setToast }: BranchFormModalProps) {
  const queryClient = useQueryClient();
  const { register, handleSubmit, reset, control, formState: { errors } } = useForm<BranchFormData>({
    resolver: zodResolver(branchSchema),
    defaultValues: { name: "", address: "", latitude: 0, longitude: 0, image_url: "", gmaps_link: "" }
  });

  useEffect(() => {
    if (isOpen) {
      const defs = branch ? { name: branch.name, address: branch.address, latitude: branch.latitude, longitude: branch.longitude, image_url: branch.image_url, gmaps_link: branch.gmaps_link }
                          : { name: "", address: "", latitude: 0, longitude: 0, image_url: "", gmaps_link: "" };
      reset(defs);
    }
  }, [branch, isOpen, reset]);

  const saveMutation = useMutation({
    mutationFn: async (data: BranchFormData) => {
      const payload = { ...data, image_url: data.image_url || `https://placehold.co/400x400/1e5e44/FFFFFF/png?text=${encodeURIComponent(data.name)}`, gmaps_link: data.gmaps_link || "" };
      if (branch) {
        return adminService.updateBranch(branch.id, payload);
      }
      return adminService.createBranch(payload);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: branch ? APP_STRINGS.branches.successUpdate : APP_STRINGS.branches.successCreate, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["branches"] });
      onSuccess();
      onClose();
    },
    onError: (err: unknown) => {
      const msg = err instanceof Error ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    }
  });

  const onSubmit = (data: BranchFormData) => {
    saveMutation.mutate(data);
  };

  const saving = saveMutation.isPending;

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={branch ? APP_STRINGS.branches.editTitle : APP_STRINGS.branches.addTitle}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <BranchBasicFields register={register} errors={errors} saving={saving} />
        <BranchLocationFields register={register} control={control} errors={errors} saving={saving} />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose} disabled={saving}>{APP_STRINGS.branches.cancelBtn}</Button>
          <Button type="submit" isLoading={saving} disabled={saving}>{APP_STRINGS.branches.saveBtn}</Button>
        </div>
      </form>
    </Modal>
  );
}
