"use client";

import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { medicineSchema, type MedicineFormData } from "@/schemas/medicine";
export type { MedicineFormData };
import { Medicine, MedicineCategory } from "@/types/api";
import { APP_STRINGS } from "@/constants";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { MedicineFormFields } from "./MedicineFormFields";

interface MedicineFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  medicine: Partial<Medicine> | null;
  categories: MedicineCategory[];
  onSave: (payload: Partial<Medicine>) => Promise<void>;
}

function useMedicineForm(isOpen: boolean, medicine: Partial<Medicine> | null, onSave: (payload: Partial<Medicine>) => Promise<void>) {
  const { register, handleSubmit, control, reset, formState: { isSubmitting } } = useForm<MedicineFormData, unknown, MedicineFormData>({
    // @ts-expect-error type mismatch with zod preprocess
    resolver: zodResolver(medicineSchema),
    defaultValues: { name: "", generic_name: "", dosage: "", unit: "", category_id: undefined, price: undefined, stock: undefined, image_url: "", requires_prescription: false }
  });

  useEffect(() => {
    if (isOpen) {
      const defs = medicine ? {
        name: medicine.name || "", generic_name: medicine.generic_name || "", dosage: medicine.dosage || "", unit: medicine.unit || "",
        category_id: medicine.category_id, price: medicine.price, stock: medicine.stock, image_url: medicine.image_url || "", requires_prescription: medicine.requires_prescription || false
      } : { name: "", generic_name: "", dosage: "", unit: "", category_id: undefined, price: undefined, stock: undefined, image_url: "", requires_prescription: false };
      reset(defs);
    }
  }, [isOpen, medicine, reset]);

  const onSubmitForm = async (data: MedicineFormData) => {
    // @ts-expect-error type mismatch with medicine
    const payload: Partial<Medicine> = { ...data };
    if (medicine?.id) payload.id = medicine.id;
    await onSave(payload);
  };

  return { register, handleSubmit, control, isSubmitting, onSubmitForm };
}

export function MedicineFormModal({ isOpen, onClose, medicine, categories, onSave }: MedicineFormModalProps) {
  const { register, handleSubmit, control, isSubmitting, onSubmitForm } = useMedicineForm(isOpen, medicine, onSave);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={medicine?.id ? APP_STRINGS.pharmacy.editMedicine : APP_STRINGS.pharmacy.addMedicine}>
      <form onSubmit={handleSubmit(onSubmitForm)} className="space-y-4">
        <MedicineFormFields register={register} control={control} isSubmitting={isSubmitting} categories={categories} />
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="ghost" onClick={onClose}>{APP_STRINGS.common.cancel}</Button>
          <Button type="submit" isLoading={isSubmitting}>{APP_STRINGS.common.save}</Button>
        </div>
      </form>
    </Modal>
  );
}
