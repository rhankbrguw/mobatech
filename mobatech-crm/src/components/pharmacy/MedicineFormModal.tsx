"use client";

import { useEffect } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Medicine, MedicineCategory } from "@/types/api";
import { APP_STRINGS } from "@/lib/constants";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { ImageUpload } from "@/components/ImageUpload";
import { MedicineFormFields } from "./MedicineFormFields";

interface MedicineFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  medicine: Partial<Medicine> | null;
  categories: MedicineCategory[];
  onSave: (payload: Partial<Medicine>) => Promise<void>;
}

const medicineSchema = z.object({
  name: z.string().min(1, "Nama obat wajib diisi"),
  generic_name: z.string().optional().nullable().catch(""),
  dosage: z.string().optional().nullable().catch(""),
  unit: z.string().optional().nullable().catch(""),
  category_id: z.preprocess((val) => val === "" || val === null ? undefined : Number(val), z.number().optional()),
  price: z.preprocess((val) => val === "" || val === null ? undefined : Number(val), z.number().min(0, "Harga tidak valid")),
  stock: z.preprocess((val) => val === "" || val === null || isNaN(Number(val)) ? undefined : Number(val), z.number().optional()),
  image_url: z.string().optional().nullable().catch(""),
  requires_prescription: z.boolean().optional().default(false),
});

type MedicineFormValues = z.infer<typeof medicineSchema>;

export function MedicineFormModal({ isOpen, onClose, medicine, categories, onSave }: MedicineFormModalProps) {
  const {
    register,
    handleSubmit,
    control,
    reset,
    formState: { isSubmitting }
  } = useForm<MedicineFormValues>({
    // @ts-expect-error type mismatch with form data
    resolver: zodResolver(medicineSchema),
    defaultValues: {
      name: "",
      generic_name: "",
      dosage: "",
      unit: "",
      category_id: undefined,
      price: undefined,
      stock: undefined,
      image_url: "",
      requires_prescription: false,
    }
  });

  useEffect(() => {
    if (isOpen) {
      if (medicine) {
        reset({
          name: medicine.name || "",
          generic_name: medicine.generic_name || "",
          dosage: medicine.dosage || "",
          unit: medicine.unit || "",
          category_id: medicine.category_id,
          price: medicine.price,
          stock: medicine.stock,
          image_url: medicine.image_url || "",
          requires_prescription: medicine.requires_prescription || false,
        });
      } else {
        reset({
          name: "",
          generic_name: "",
          dosage: "",
          unit: "",
          category_id: undefined,
          price: undefined,
          stock: undefined,
          image_url: "",
          requires_prescription: false,
        });
      }
    }
  }, [isOpen, medicine, reset]);

  const onSubmitForm = async (data: MedicineFormValues) => {
    // @ts-expect-error type mismatch with medicine
    const payload: Partial<Medicine> = { ...data };
    if (medicine?.id) {
      payload.id = medicine.id;
    }
    await onSave(payload);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={medicine?.id ? APP_STRINGS.pharmacy.editMedicine : APP_STRINGS.pharmacy.addMedicine}>
      {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
      <form onSubmit={handleSubmit(onSubmitForm as any)} className="space-y-4">
        <MedicineFormFields 
          register={register}
          control={control}
          isSubmitting={isSubmitting}
          categories={categories}
        />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>{APP_STRINGS.common.cancel}</Button>
          <Button type="submit" isLoading={isSubmitting}>{APP_STRINGS.common.save}</Button>
        </div>
      </form>
    </Modal>
  );
}
