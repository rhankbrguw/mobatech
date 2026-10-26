import { z } from "zod";

export const branchSchema = z.object({
  name: z.string().min(1, "Name is required"),
  address: z.string().min(1, "Address is required"),
  latitude: z.number({ message: "Latitude is required" }),
  longitude: z.number({ message: "Longitude is required" }),
  image_url: z.string().optional(),
  gmaps_link: z.string().optional(),
});

export type BranchFormData = z.infer<typeof branchSchema>;
