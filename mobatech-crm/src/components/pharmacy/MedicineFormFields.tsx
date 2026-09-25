import { UseFormRegister, Control, Controller } from "react-hook-form";
import { type MedicineFormData } from "@/schemas/medicine";
import { APP_STRINGS } from "@/constants";
import { MedicineCategory } from "@/types/api";
import { ImageUpload } from "@/components/ImageUpload";

interface MedicineFormFieldsProps {
  register: UseFormRegister<MedicineFormData>;
  control: Control<MedicineFormData>;
  isSubmitting: boolean;
  categories: MedicineCategory[];
}

function MedicineNameFields({ register, isSubmitting }: Pick<MedicineFormFieldsProps, "register" | "isSubmitting">) {
  return (
    <div className="grid grid-cols-2 gap-4">
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacy.medicineName}</label>
        <input disabled={isSubmitting} type="text" required {...register("name")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="Contoh: Paracetamol 500mg" />
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">Nama Generik</label>
        <input disabled={isSubmitting} type="text" {...register("generic_name")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="Contoh: Acetaminophen" />
      </div>
    </div>
  );
}

function MedicineDosageFields({ register, isSubmitting, categories }: Pick<MedicineFormFieldsProps, "register" | "isSubmitting" | "categories">) {
  return (
    <div className="grid grid-cols-3 gap-4">
      <div>
        <label className="block text-xs font-semibold mb-2">Dosis</label>
        <input disabled={isSubmitting} type="text" {...register("dosage")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="500mg" />
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">Satuan</label>
        <input disabled={isSubmitting} type="text" {...register("unit")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="Tablet" />
      </div>
      <div>
        <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacy.category}</label>
        <select disabled={isSubmitting} {...register("category_id")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground cursor-pointer focus:border-primary outline-none transition-all">
          <option value="">Pilih Kategori</option>
          {categories.map((c) => (<option key={c.id} value={c.id}>{c.name}</option>))}
        </select>
      </div>
    </div>
  );
}

function MedicineStockPhotoFields({ register, control, isSubmitting }: Pick<MedicineFormFieldsProps, "register" | "control" | "isSubmitting">) {
  return (
    <>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacy.price}</label>
          <input disabled={isSubmitting} type="number" required min={0} {...register("price")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="15000" />
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.pharmacy.stock}</label>
          <input disabled={isSubmitting} type="number" min={0} {...register("stock")} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder="100" />
        </div>
      </div>
      <Controller name="image_url" control={control} render={({ field }) => (<ImageUpload imageUrl={field.value || ""} setImageUrl={(url) => field.onChange(url)} label={APP_STRINGS.pharmacy.medicinePhoto} />)} />
      <div className="flex items-center gap-2">
        <input disabled={isSubmitting} type="checkbox" id="requiresPrescription" {...register("requires_prescription")} className="rounded border-glass-border text-primary focus:ring-primary w-4 h-4 cursor-pointer" />
        <label htmlFor="requiresPrescription" className="text-xs font-semibold cursor-pointer">{APP_STRINGS.pharmacy.requiresPrescription}</label>
      </div>
    </>
  );
}

export function MedicineFormFields(props: MedicineFormFieldsProps) {
  return (
    <div className="space-y-4">
      <MedicineNameFields register={props.register} isSubmitting={props.isSubmitting} />
      <MedicineDosageFields register={props.register} isSubmitting={props.isSubmitting} categories={props.categories} />
      <MedicineStockPhotoFields register={props.register} control={props.control} isSubmitting={props.isSubmitting} />
    </div>
  );
}
