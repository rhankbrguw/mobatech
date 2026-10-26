import { z } from "zod";

export const prescriptionItemSchema = z.object({
  medicine_id: z.coerce.number().catch(0).nullable().optional(),
  custom_medicine: z.string().optional(),
  dosage_instruction: z.string().optional(),
  duration: z.string().optional(),
  quantity: z.coerce.number().min(1).catch(1),
  notes: z.string().optional()
});

export const prescriptionSchema = z.object({
  user_id: z.coerce.number().min(1).catch(0),
  appointment_id: z.coerce.number().catch(0).nullable().optional(),
  doctor_name: z.string().optional(),
  diagnosis: z.string().optional(),
  items: z.array(prescriptionItemSchema).default([])
});

export type PrescriptionItemValues = z.infer<typeof prescriptionItemSchema>;
export type PrescriptionFormValues = z.infer<typeof prescriptionSchema>;
