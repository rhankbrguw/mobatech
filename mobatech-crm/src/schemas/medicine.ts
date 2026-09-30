import { z } from "zod";

export const medicineSchema = z.object({
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

export type MedicineFormData = z.infer<typeof medicineSchema>;
