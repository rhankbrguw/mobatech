"use client";
import { useEffect, useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { api } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { FormValidators } from "@/lib/validators";
import { Doctor, Polyclinic } from "@/types/api";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { ImageUpload } from "./ImageUpload";
import { PhoneInput } from "@/components/ui/PhoneInput";
import { DoctorFormFields } from "./DoctorFormFields";

const doctorSchema = z.object({
  name: z.string()
    .min(1, "Nama wajib diisi")
    .superRefine((val, ctx) => {
      const err = FormValidators.name(val);
      if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
    }),
  polyclinic_id: z.number().min(1, "Poliklinik wajib dipilih"),
  specialization: z.string().min(1, "Spesialisasi wajib diisi"),
  contact_info: z.string()
    .min(1, "Kontak wajib diisi")
    .superRefine((val, ctx) => {
      const err = FormValidators.phone(val);
      if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
    }),
  description: z.string().min(1, "Deskripsi wajib diisi"),
  image_url: z.string().optional(),
  is_active: z.boolean(),
  email: z.string().email("Email tidak valid").optional().or(z.literal("")),
});

export type DoctorFormValues = z.infer<typeof doctorSchema>;

interface DoctorFormModalProps {
  isOpen: boolean; onClose: () => void; doctor: Doctor | null;
  onSave: (payload: { name: string; specialization: string; polyclinic_id?: number; contact_info: string; description: string; image_url: string; is_active: boolean; email?: string }) => Promise<void>;
}

export function DoctorFormModal({ isOpen, onClose, doctor, onSave }: DoctorFormModalProps) {
  const [polyclinics, setPolyclinics] = useState<Polyclinic[]>([]);
  const [submitting, setSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    control,
    reset,
    setValue,
    getValues,
    formState: { errors },
  } = useForm<DoctorFormValues>({
    resolver: zodResolver(doctorSchema),
    defaultValues: {
      name: "",
      polyclinic_id: 0,
      specialization: "",
      contact_info: "+62",
      description: "",
      image_url: "",
      is_active: true,
      email: "",
    },
  });

  useEffect(() => {
    if (isOpen) {
      const fetchPolys = async () => {
        try {
          const res = await api.get<Polyclinic[]>("/api/polyclinics");
          setPolyclinics(res.data || []);
        } catch (err) { console.error("Failed to fetch polyclinics", err); }
      };
      fetchPolys();
    }
  }, [isOpen]);

  useEffect(() => {
    if (isOpen) {
      reset({
        name: doctor?.name || "",
        polyclinic_id: doctor?.polyclinic_id ?? 0,
        specialization: doctor?.specialization || "",
        contact_info: doctor?.contact_info || "+62",
        description: doctor?.description || "",
        image_url: doctor?.image_url || "",
        is_active: doctor?.is_active ?? true,
        email: "",
      });
    }
  }, [doctor, isOpen, reset]);

  const onSubmit = async (data: DoctorFormValues) => {
    setSubmitting(true);
    try {
      const payload = {
        name: data.name,
        specialization: data.specialization,
        polyclinic_id: data.polyclinic_id || undefined,
        contact_info: data.contact_info,
        description: data.description,
        image_url: data.image_url || `https://api.dicebear.com/7.x/avataaars/svg?seed=${data.name || "Doctor"}`,
        is_active: data.is_active,
        ...(data.email ? { email: data.email } : {})
      };
      await onSave(payload);
      onClose();
    } catch (err) {
      console.error("Error saving doctor:", err);
    } finally {
      setSubmitting(false);
    }
  };

  const { onChange: onPolyChange, onBlur: onPolyBlur, name: polyName, ref: polyRef } = register("polyclinic_id");

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={doctor ? APP_STRINGS.doctors.editTitle : APP_STRINGS.doctors.addTitle}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <DoctorFormFields 
          register={register} 
          control={control} 
          errors={errors} 
          submitting={submitting} 
          polyclinics={polyclinics} 
          setValue={setValue} 
          getValues={getValues} 
          doctor={doctor} 
        />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" disabled={submitting} onClick={onClose}>{APP_STRINGS.doctors.cancelBtn}</Button>
          <Button type="submit" isLoading={submitting}>{APP_STRINGS.doctors.saveBtn}</Button>
        </div>
      </form>
    </Modal>
  );
}


