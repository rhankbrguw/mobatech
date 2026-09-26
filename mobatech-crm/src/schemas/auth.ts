import { z } from "zod";
import { FormValidators } from "@/lib/validators";

export const loginSchema = z.object({
  email: z
    .string()
    .min(1, { message: "empty" })
    .superRefine((val, ctx) => {
      const err = FormValidators.email(val);
      if (err) ctx.addIssue({ code: z.ZodIssueCode.custom, message: err });
    }),
  password: z.string().min(1, { message: "empty" }),
});

export type LoginFormValues = z.infer<typeof loginSchema>;
