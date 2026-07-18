import { UseFormRegister, Control, FieldErrors, UseFormSetValue, UseFormGetValues, Controller } from "react-hook-form";
import { DoctorFormValues } from "./DoctorFormModal";
import { APP_STRINGS } from "@/lib/constants";
import { Polyclinic } from "@/types/api";
import { PhoneInput } from "@/components/ui/PhoneInput";
import { ImageUpload } from "./ImageUpload";
import { Doctor } from "@/types/api";

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

export function DoctorFormFields({
  register, control, errors, submitting, polyclinics, setValue, getValues, doctor
}: DoctorFormFieldsProps) {
  const { onChange: onPolyChange, onBlur: onPolyBlur, name: polyName, ref: polyRef } = register("polyclinic_id", { valueAsNumber: true });

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.nameLabel}</label>
          <input 
            disabled={submitting} 
            type="text" 
            {...register("name")} 
            className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.name ? "border-error focus:border-error" : ""}`} 
            placeholder={APP_STRINGS.doctors.namePlaceholder} 
          />
          {errors.name && <p className="text-xs text-error mt-1">{errors.name?.message as string}</p>}
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">Poliklinik</label>
          <select 
            disabled={submitting} 
            name={polyName}
            ref={polyRef}
            onBlur={onPolyBlur}
            onChange={(e) => {
              onPolyChange(e);
              const id = Number(e.target.value);
              const poly = polyclinics.find((p) => p.id === id);
              if (poly && !getValues("specialization")) {
                setValue("specialization", poly.name, { shouldValidate: true });
              }
            }}
            className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground cursor-pointer focus:border-primary outline-none"
          >
            <option value="">Pilih Poliklinik</option>
            {polyclinics.filter((p) => p.is_active).map((p) => (
              <option key={p.id} value={p.id}>{p.name}</option>
            ))}
          </select>
          {errors.polyclinic_id && <p className="text-xs text-error mt-1">{errors.polyclinic_id?.message as string}</p>}
        </div>
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.specLabel}</label>
          <input 
            disabled={submitting} 
            type="text" 
            {...register("specialization")} 
            className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.specialization ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} 
            placeholder={APP_STRINGS.doctors.specPlaceholder} 
          />
          {errors.specialization && <p className="text-xs text-error mt-1">{errors.specialization?.message as string}</p>}
        </div>
        {!doctor && (
          <div>
            <label className="block text-xs font-semibold mb-2">Email Korporat (Auto-Create Akun)</label>
            <input 
              disabled={submitting} 
              type="email" 
              {...register("email")} 
              className={`w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground ${errors.email ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} 
              placeholder="opsional: dr.nama@hermina.com" 
            />
            {errors.email && <p className="text-xs text-error mt-1">{errors.email?.message as string}</p>}
          </div>
        )}
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.contactLabel}</label>
        <Controller
          control={control}
          name="contact_info"
          render={({ field }) => (
            <PhoneInput 
              disabled={submitting} 
              value={field.value} 
              onChange={field.onChange} 
              className={errors.contact_info ? "border-error focus-within:border-error" : ""} 
            />
          )}
        />
        {errors.contact_info && <p className="text-xs text-error mt-1">{errors.contact_info?.message as string}</p>}
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.doctors.descLabel}</label>
        <textarea 
          disabled={submitting} 
          {...register("description")} 
          className={`w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none ${errors.description ? "border-error focus:border-error" : "focus:border-primary outline-none"}`} 
          placeholder={APP_STRINGS.doctors.descPlaceholder} 
        />
        {errors.description && <p className="text-xs text-error mt-1">{errors.description?.message as string}</p>}
      </div>
      <Controller
        control={control}
        name="image_url"
        render={({ field }) => (
          <ImageUpload 
            imageUrl={field.value || ""} 
            setImageUrl={(val) => field.onChange(val)} 
            label={APP_STRINGS.doctors.imgLabel} 
          />
        )}
      />
      <div className="flex items-center gap-2">
        <input 
          disabled={submitting} 
          type="checkbox" 
          id="isActive" 
          {...register("is_active")}
          className="rounded border-glass-border text-primary focus:ring-primary w-4 h-4 cursor-pointer" 
        />
        <label htmlFor="isActive" className="text-xs font-semibold cursor-pointer">{APP_STRINGS.doctors.activeLabel}</label>
      </div>
    </div>
  );
}
