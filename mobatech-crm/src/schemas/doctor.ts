import { z } from "zod";
import { FormValidators } from "@/lib/validators";

export const doctorSchema = z.object({
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
  email: z.string().superRefine((val, ctx) => {
    if (val && val.trim()) {
      const err = FormValidators.email(val);
      if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
    }
  }).optional().or(z.literal("")),
});

export type DoctorFormValues = z.infer<typeof doctorSchema>;
