import { useState } from "react";
import { Eye, EyeOff } from "lucide-react";
import { UseFormRegister, Control, FieldErrors, UseFormSetValue, UseFormGetValues, Controller } from "react-hook-form";
import { type DoctorFormValues } from "@/schemas/doctor";
import { APP_STRINGS } from "@/constants";
import { Polyclinic, Doctor } from "@/types/api";
import { PhoneInput } from "@/components/ui/PhoneInput";
import { ImageUpload } from "./ImageUpload";

interface DoctorFormFieldsProps {
  register: UseFormRegister<DoctorFormValues>;
  control: Control<DoctorFormValues>;
  errors: FieldErrors<DoctorFormValues>;
  submitting: boolean;
  polyclinics: Polyclinic[];
  setValue: UseFormSetValue<DoctorFormValues>;
  getValues: UseFormGetValues<DoctorFormValues>;
  doctor: Doctor | null;
}

function DoctorNamePolySection({ register, control, errors, submitting, polyclinics, setValue, getValues }: Omit<DoctorFormFieldsProps, "doctor">) {
  return (
    <div className="grid grid-cols-2 gap-4">
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.nameLabel}</label>
        <input disabled={submitting} type="text" {...register("name")} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.name ? "border-error focus:border-error" : ""}`} placeholder={APP_STRINGS.doctors.namePlaceholder} />
        {errors.name && <p className="text-xs text-error mt-1">{errors.name?.message as string}</p>}
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">Poliklinik</label>
        <Controller
          control={control}
          name="polyclinic_id"
          render={({ field }) => (
            <select
              disabled={submitting}
              value={field.value || ""}
              onChange={(e) => {
                const id = Number(e.target.value) || 0;
                field.onChange(id);
                const poly = polyclinics.find((p) => p.id === id);
                if (poly && !getValues("specialization")) {
                  setValue("specialization", poly.name, { shouldValidate: true });
                }
              }}
              className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground cursor-pointer focus:border-primary outline-none"
            >
              <option value="" className="bg-card text-foreground">Pilih Poliklinik</option>
              {polyclinics.filter((p) => p.is_active !== false).map((p) => {
                const pId = p.id || (p as { ID?: number }).ID;
                return (
                  <option key={pId} value={pId} className="bg-card text-foreground">{p.name}</option>
                );
              })}
            </select>
          )}
        />
        {errors.polyclinic_id && <p className="text-xs text-error mt-1">{errors.polyclinic_id?.message as string}</p>}
      </div>
    </div>
  );
}

function DoctorAccountSection({ register, errors, submitting, doctor }: Pick<DoctorFormFieldsProps, "register" | "errors" | "submitting" | "doctor">) {
  const [showPassword, setShowPassword] = useState(false);
  if (doctor) return null;
  return (
    <div className="grid grid-cols-2 gap-4">
      <div>
        <label className="block text-xs font-semibold mb-2">Email Akun (Opsional)</label>
        <input disabled={submitting} type="email" {...register("email")} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.email ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} placeholder="dr.nama@herminahospitals.com" />
        {errors.email && <p className="text-xs text-error mt-1">{errors.email?.message as string}</p>}
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.passwordLabel}</label>
        <div className="relative">
          <input
            disabled={submitting}
            type={showPassword ? "text" : "password"}
            {...register("password")}
            className={`w-full h-10 px-3 pr-10 rounded-xl border glass-input text-sm text-foreground ${errors.password ? "border-error focus:border-error" : "focus:border-primary outline-none"}`}
            placeholder={APP_STRINGS.doctors.passwordPlaceholder}
          />
          <button
            type="button"
            disabled={submitting}
            onClick={() => setShowPassword((p) => !p)}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-foreground/40 hover:text-foreground transition-colors cursor-pointer"
          >
            {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
          </button>
        </div>
        {errors.password && <p className="text-xs text-error mt-1">{errors.password?.message as string}</p>}
      </div>
    </div>
  );
}

function DoctorSpecSection({ register, errors, submitting }: Pick<DoctorFormFieldsProps, "register" | "errors" | "submitting">) {
  return (
    <div>
      <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.specLabel}</label>
      <input disabled={submitting} type="text" {...register("specialization")} className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.specialization ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} placeholder={APP_STRINGS.doctors.specPlaceholder} />
      {errors.specialization && <p className="text-xs text-error mt-1">{errors.specialization?.message as string}</p>}
    </div>
  );
}

function DoctorContactDescSection({ register, control, errors, submitting }: Pick<DoctorFormFieldsProps, "register" | "control" | "errors" | "submitting">) {
  return (
    <>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.contactLabel}</label>
        <Controller control={control} name="contact_info" render={({ field }) => (<PhoneInput disabled={submitting} value={field.value} onChange={field.onChange} className={errors.contact_info ? "border-error focus-within:border-error" : ""} />)} />
        {errors.contact_info && <p className="text-xs text-error mt-1">{errors.contact_info?.message as string}</p>}
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.descLabel}</label>
        <textarea disabled={submitting} {...register("description")} className={`w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none ${errors.description ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} placeholder={APP_STRINGS.doctors.descPlaceholder} />
        {errors.description && <p className="text-xs text-error mt-1">{errors.description?.message as string}</p>}
      </div>
      <Controller control={control} name="image_url" render={({ field }) => (<ImageUpload imageUrl={field.value || ""} setImageUrl={(val) => field.onChange(val)} label={APP_STRINGS.doctors.imgLabel} />)} />
      <div className="flex items-center gap-2">
        <input disabled={submitting} type="checkbox" id="isActive" {...register("is_active")} className="rounded border-glass-border text-primary focus:ring-primary w-4 h-4 cursor-pointer" />
        <label htmlFor="isActive" className="text-xs font-semibold cursor-pointer">{APP_STRINGS.doctors.activeLabel}</label>
      </div>
    </>
  );
}

export function DoctorFormFields(props: DoctorFormFieldsProps) {
  return (
    <div className="space-y-4">
      <DoctorNamePolySection register={props.register} control={props.control} errors={props.errors} submitting={props.submitting} polyclinics={props.polyclinics} setValue={props.setValue} getValues={props.getValues} />
      <DoctorSpecSection register={props.register} errors={props.errors} submitting={props.submitting} />
      <DoctorAccountSection register={props.register} errors={props.errors} submitting={props.submitting} doctor={props.doctor} />
      <DoctorContactDescSection register={props.register} control={props.control} errors={props.errors} submitting={props.submitting} />
    </div>
  );
}
