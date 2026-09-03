"use client";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { doctorSchema, type DoctorFormValues } from "@/schemas/doctor";
export type { DoctorFormValues };
import { APP_STRINGS } from "@/constants";
import { Doctor } from "@/types/api";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { DoctorFormFields } from "./DoctorFormFields";
import { useQuery } from "@tanstack/react-query";
import { polyclinicService } from "@/services";

interface DoctorFormModalProps {
  isOpen: boolean; onClose: () => void; doctor: Doctor | null;
  onSave: (payload: { name: string; specialization: string; polyclinic_id?: number; contact_info: string; description: string; image_url: string; is_active: boolean; email?: string }) => Promise<void>;
  showToast?: (message: string, type: "success" | "error") => void;
}

async function handleDoctorSave(data: DoctorFormValues, onSave: DoctorFormModalProps["onSave"], onClose: () => void, showToast?: DoctorFormModalProps["showToast"]) {
  try {
    const payload = {
      name: data.name, specialization: data.specialization, polyclinic_id: data.polyclinic_id || undefined,
      contact_info: data.contact_info, description: data.description,
      image_url: data.image_url || `https://api.dicebear.com/7.x/avataaars/svg?seed=${data.name || "Doctor"}`,
      is_active: data.is_active, ...(data.email ? { email: data.email } : {})
    };
    await onSave(payload);
    onClose();
  } catch { showToast?.(APP_STRINGS.common.saveError, "error"); }
}

function useDoctorForm(isOpen: boolean, doctor: Doctor | null, onClose: () => void, onSave: DoctorFormModalProps["onSave"], showToast?: DoctorFormModalProps["showToast"]) {
  const { data: polyclinicsRes } = useQuery({
    queryKey: ["polyclinics"],
    queryFn: () => polyclinicService.getPolyclinics(),
    enabled: isOpen,
  });
  const polyclinics = polyclinicsRes?.data || [];

  const [submitting, setSubmitting] = useState(false);
  const { register, handleSubmit, control, reset, setValue, getValues, formState: { errors } } = useForm<DoctorFormValues>({
    resolver: zodResolver(doctorSchema),
    defaultValues: { name: "", polyclinic_id: 0, specialization: "", contact_info: "+62", description: "", image_url: "", is_active: true, email: "" },
  });

  useEffect(() => {
    if (isOpen) {
      reset({
        name: doctor?.name || "", polyclinic_id: doctor?.polyclinic_id ?? 0, specialization: doctor?.specialization || "",
        contact_info: doctor?.contact_info || "+62", description: doctor?.description || "", image_url: doctor?.image_url || "",
        is_active: doctor?.is_active ?? true, email: "",
      });
    }
  }, [doctor, isOpen, reset]);

  const onSubmit = async (data: DoctorFormValues) => {
    setSubmitting(true);
    await handleDoctorSave(data, onSave, onClose, showToast);
    setSubmitting(false);
  };

  return { register, handleSubmit, control, setValue, getValues, errors, polyclinics, submitting, onSubmit };
}

// Migrated to React Query
export function DoctorFormModal({ isOpen, onClose, doctor, onSave, showToast }: DoctorFormModalProps) {
  const { register, handleSubmit, control, setValue, getValues, errors, polyclinics, submitting, onSubmit } = useDoctorForm(isOpen, doctor, onClose, onSave, showToast);
  return (
    <Modal isOpen={isOpen} onClose={onClose} title={doctor ? APP_STRINGS.doctors.editTitle : APP_STRINGS.doctors.addTitle}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <DoctorFormFields register={register} control={control} errors={errors} submitting={submitting} polyclinics={polyclinics} setValue={setValue} getValues={getValues} doctor={doctor} />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" disabled={submitting} onClick={onClose}>{APP_STRINGS.doctors.cancelBtn}</Button>
          <Button type="submit" isLoading={submitting}>{APP_STRINGS.doctors.saveBtn}</Button>
        </div>
      </form>
    </Modal>
  );
}
