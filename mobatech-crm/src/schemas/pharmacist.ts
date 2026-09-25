import { z } from "zod";
import { FormValidators } from "@/lib/validators";

export const pharmacistSchema = z.object({
  full_name: z.string().min(1, "Nama lengkap wajib diisi").superRefine((val, ctx) => {
    const err = FormValidators.name(val);
    if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
  }),
  email: z.string().min(1, "Email wajib diisi").superRefine((val, ctx) => {
    const err = FormValidators.email(val);
    if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
  }),
  phone_number: z.string().min(1, "Nomor telepon wajib diisi").superRefine((val, ctx) => {
    const err = FormValidators.phone(val);
    if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
  }),
  password: z.string().optional().or(z.literal("")),
  image_url: z.string().optional(),
});

export type PharmacistFormValues = z.infer<typeof pharmacistSchema>;
