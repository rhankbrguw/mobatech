import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { Prescription, Medicine, PrescriptionItem } from "@/types/api";
import { Pill, Plus } from "lucide-react";
import { PrescriptionItemCard, PrescriptionEmptyState } from "./PrescriptionItemCard";
import { useForm, useFieldArray, useWatch, Path, PathValue } from "react-hook-form";
import { Field } from "./PrescriptionFormField";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";

const prescriptionItemSchema = z.object({
  medicine_id: z.coerce.number().catch(0).nullable().optional(),
  custom_medicine: z.string().optional(),
  dosage_instruction: z.string().optional(),
  duration: z.string().optional(),
  quantity: z.coerce.number().min(1).catch(1),
  notes: z.string().optional()
});

const formSchema = z.object({
  user_id: z.coerce.number().min(1).catch(0),
  appointment_id: z.coerce.number().catch(0).nullable().optional(),
  doctor_name: z.string().optional(),
  diagnosis: z.string().optional(),
  items: z.array(prescriptionItemSchema).default([])
});

type FormValues = z.infer<typeof formSchema>;

interface PrescriptionFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (prescription: Partial<Prescription>) => Promise<void>;
  initialAppointmentId?: number;
  initialUserId?: number;
  initialDoctorName?: string;
  initialDiagnosis?: string;
  medicines: Medicine[];
}

export function PrescriptionFormModal({
  isOpen, onClose, onSave,
  initialAppointmentId, initialUserId,
  initialDoctorName, initialDiagnosis, medicines
}: PrescriptionFormModalProps) {
  
  const { register, control, handleSubmit, setValue, formState: { isSubmitting } } = useForm<FormValues>({
    resolver: zodResolver(formSchema) as unknown as import("react-hook-form").Resolver<FormValues>,
    defaultValues: {
      user_id: initialUserId || 0,
      appointment_id: initialAppointmentId || 0,
      doctor_name: initialDoctorName || "",
      diagnosis: initialDiagnosis || "",
      items: []
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: "items"
  });

  const watchItems = useWatch({ control, name: "items" });
  const watchUserId = useWatch({ control, name: "user_id" });

  const addItem = () => {
    append({ medicine_id: 0, custom_medicine: "", dosage_instruction: "", duration: "", quantity: 1, notes: "" });
  };

  const updateItem = (i: number, field: string, val: string | number) => {
    setValue(`items.${i}.${field}` as Path<FormValues>, val as PathValue<FormValues, Path<FormValues>>, { shouldValidate: true, shouldDirty: true });
  };

  const removeItem = (i: number) => {
    remove(i);
  };

  const onSubmit = async (data: FormValues) => {
    if (!data.user_id || !data.items?.length) return;
    try {
      const processed = {
        ...data,
        items: data.items.map(i => ({ 
          ...i, 
          medicine_id: i.medicine_id === 0 ? null : i.medicine_id 
        }))
      };
      await onSave(processed as Partial<Prescription>);
      onClose();
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Terbitkan E-Resep Baru">
      <div className="space-y-5">
        {/* ── Metadata ── */}
        <div className="grid grid-cols-2 gap-3">
          <Field label="ID Pasien *" type="number" registerProps={register("user_id")} />
          <Field label="ID Janji Temu" type="number" registerProps={register("appointment_id")} />
          <Field label="Nama Dokter" registerProps={register("doctor_name")} />
          <Field label="Diagnosa Medis" registerProps={register("diagnosis")} />
        </div>

        {/* ── Medicine List ── */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Pill size={16} className="text-primary" />
              <span className="text-sm font-bold">Daftar Obat</span>
              {(fields.length > 0) && (
                <span className="text-xs font-bold bg-primary/15 text-primary px-2 py-0.5 rounded-full">{fields.length}</span>
              )}
            </div>
            <button type="button" onClick={addItem} className="flex items-center gap-1.5 text-xs font-bold text-primary hover:text-primary/80 bg-primary/10 hover:bg-primary/20 px-3 py-1.5 rounded-full transition-colors cursor-pointer">
              <Plus size={14} /> Tambah
            </button>
          </div>

          {!fields.length && <PrescriptionEmptyState onAdd={addItem} />}

          <div className="space-y-2">
            {fields.map((field, idx) => {
              const itemData = watchItems?.[idx] || field;
              return (
                <PrescriptionItemCard 
                  key={field.id} 
                  item={itemData as unknown as PrescriptionItem}
                  index={idx} 
                  medicines={medicines} 
                  onUpdate={updateItem} 
                  onRemove={removeItem} 
                />
              );
            })}
          </div>
        </div>

        {/* ── Footer ── */}
        <div className="flex justify-end gap-2 pt-2 border-t border-glass-border/50">
          <Button variant="ghost" onClick={onClose} disabled={isSubmitting}>Batal</Button>
          <Button onClick={handleSubmit(onSubmit as unknown as import("react-hook-form").SubmitHandler<FormValues>)} isLoading={isSubmitting} disabled={!fields.length || !watchUserId}>Terbitkan E-Resep</Button>
        </div>
      </div>
    </Modal>
  );
}


