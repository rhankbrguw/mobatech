import { UseFormRegisterReturn } from "react-hook-form";

export function Field({ label, type = "text", registerProps }: { label: string; type?: string; registerProps: UseFormRegisterReturn }) {
  return (
    <div className="space-y-1">
      <label className="text-xs text-foreground/50 font-semibold">{label}</label>
      <input type={type} {...registerProps} className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground" />
    </div>
  );
}
